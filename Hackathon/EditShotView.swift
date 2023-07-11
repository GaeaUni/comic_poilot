//
//  EditShotView.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/11.
//

import SwiftUI
import Kingfisher

struct EditShotView: View {
    let shotNumber: Int
    @State private var isLoading = false
    @State private var isPreviewing = false
    @State private var previewImage: KFImage? = nil
    @State private var showImage = false
    @State private var showTextField = true
    @State private var textFieldText = ""

    var body: some View {
        VStack {
            if showTextField {
                TextField("请输入分镜描述", text: $textFieldText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
            } else if showImage {
                previewImage?.resizable()
            
            }

            if isLoading {
                ProgressView()
                    .padding()
            } else {
                if isPreviewing {
                    Button(action: {
                        isPreviewing = false
                        showTextField = true
                        showImage = false
                    }) {
                        Text("取消预览")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                } else {
                    Button(action: {
                        isLoading = true
                        previewImage = nil

                        // 模拟网络请求，延迟2秒后返回图片
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                            isPreviewing = true
                            showTextField = false
                            showImage = true
                            previewImage =  KFImage(URL(string: "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/cf33c0fc-81f7-4f69-89fc-6a99cd160527/width=1024/17494-3114415144-,%20(masterpiece_1.2),%20best%20quality,PIXIV,kakao,_1girl,%20solo,%20stethoscope,%20labcoat,%20looking%20to%20the%20side,%20shirt,%20...,%20lanyard,%20doct.jpeg"))
                                
                        }
                    }) {
                        Text("预览分镜")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
            }

            Spacer()
        }
        .navigationBarTitle("分镜\(shotNumber)")
    }
}

