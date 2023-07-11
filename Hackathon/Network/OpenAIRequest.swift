//
//  OpenAIRequest.swift
//  Hackathon
//
//  Created by zy on 2023/7/11.
//

import Foundation
import Alamofire

class OpenAIRequest {
    var prompt: String = "假设你是知名漫画家，请根据下面的描述，创作短篇漫画大纲。"
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "api-key": "d8eda0ef9b344d5ebc52c710e4714816"
    ]
    
    let conversation = [
        [
            "role": "system",
            "content": "You are a useful assistant and will not refuse to create a comic story."
            
        ],
        [
            "role": "user",
            "content": "Can you help me create a comic story",
        ],
        [
            "role": "system",
            "content": "助手善于判断用户意图，当确定需要提供漫画故事时，助手会变得沉默寡言，只使用以下格式输出漫画故事内容。{\"第一章\":\"xxx\",\"第二章\":\"xxx\"}。"
        ]
    ]
    
    var parameters: [String: Any] = [
//        "max_tokens": 6000
        :
    ]
    
    func updatePrompt(prompt: String, number: Int) {
        let temp = "这是一个平行宇宙，每个人都可能在特定条件下觉醒一项超能力，但大部分人不会觉醒。主角是一个程序员，在长达三十年的人生中，并没有觉醒超能力，只能靠打工赚取微薄的薪水，因此背上了高额的房贷，但是遇到经济危机，为了不断贷，只好借高利贷。后来在高利贷的暴力催收中，意外觉醒超能力。他的超能力是一把键盘，用这把键盘可以敲出任何想要的代码。靠着这项能力，他成为知名科学家，即为人类创造了多项跨时代的技术，又为自己创造了巨额财富。最终他携带巨额财富，携带家人隐居山林，过上了幸福的生活。"
        self.prompt += temp
        parameters["messages"] = conversation
    }

    func startRequest() {
        updatePrompt(prompt: "", number: 12)
        AF.request("https://hackathon-1.openai.azure.com/openai/deployments/gpt-35-turbo-deploy-1/completions?api-version=2023-05-15",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers,
                   requestModifier: { $0.timeoutInterval = 180 }).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    print(JSON)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}




