//
//  CannyAPI.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/13.
//

import Alamofire
import SwiftUI
import Foundation

class CannyAPI: ObservableObject {
    
    func response(prompt: String, inputImage: UIImage) async throws -> UIImage {
        let img = inputImage.pngData()?.base64EncodedString(options: .endLineWithLineFeed) ?? ""
                
                let payload: [String: Any] = [
                    "prompt": "8k,(masterpiece, \(prompt), <lora:hipoly_3dcg_v7-epoch:0.3:NF>",
                    "width": 512,
                    "height": 512,
                    "steps": 1,
                    "n_iter": 1,
                    "negative_prompt": "bad hands,women,no computer,two people,stronger",
                    "batch_size": 1,
                    "sampler_name": "Euler",
                    "alwayson_scripts": [
                        "controlnet": [
                            "args": [
                                [
                                    "input_image": "data:image/png;base64,\(img)",
                                    "module": "canny",
                                    "model": "control_v11p_sd15_canny"
                                ]
                            ]
                        ]
                    ],
                    "override_settings": [
                        "sd_model_checkpoint": "abyssorangemix2SFW_abyssorangemix2Sfw.safetensors",
                        "CLIP_stop_at_last_layers": 2
                    ] as [String: Any]
                ]
                
                let request = AF.request("http://10.76.192.20:7860/sdapi/v1/txt2img",
                                         method: .post,
                                         parameters: payload,
                                         encoding: JSONEncoding.default)
                
                let (data, _) = try await request.responseAsync()
        let responseData = try JSONDecoder().decode(ResponseData.self, from: data)
        return UIImage(data: Data(base64Encoded: responseData.images[1])!)!
    }
}

struct ResponseData: Decodable {
    let images: [String]
}

enum APIError: Error {
    case invalidResponse
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}


struct ContentView1: View {
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = processedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Text("No Image")
            }
            
            Button("Process Image") {
                // Load or capture an input image here
                // For example:

                inputImage = UIImage(contentsOfFile: "/Users/zhouliang/Desktop/work/ai/8.png")
                
                processedImage = OpenCVWrapper.cannyEdgeDetection(inputImage!)
                
            }
        }
        .padding()
    }

}

