//
//  DetailView.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/10.
//

import Alamofire
import SwiftUI

struct StoryGeneratorView: View {
    @State private var message = ""
    @State private var selectedShotCount = 1
    @State private var showShotList = false
    @State private var shots: [ShotListView.Shot] = []
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .topLeading) {
                // 多行文本框
                TextEditor(text: $message)
                    .font(.title3)
                    .lineSpacing(20)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0)

                    // 边框
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                // 注释文字
                if message.isEmpty {
                    Text("输入故事梗概")
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(15)
                }
            }
            .padding()

            if isLoading {
                ProgressView()
            } else {
                Button(action: {
                    // 点击按钮的操作
                    generateShots()
                }) {
                    Text("生成分镜")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue) // 设置按钮的背景颜色
                        .cornerRadius(8)
                }
                .sheet(isPresented: $showShotList) {
                    ShotListView(shots: shots)
                }
                .padding()
            }

            Stepper(value: $selectedShotCount, in: 1 ... 20) {
                Text("选择分镜数量: \(selectedShotCount)")
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("故事描述")
                    .font(.headline)
            }
        }
    }
}

extension StoryGeneratorView {
    // 生成分镜
    func generateShots() {
        // 发送网络请求，获取分镜的数据
        // 这里只是一个示例，你需要根据你的后端服务来实现这个功能
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            shots = parseShots(json: [:])
            showShotList = true
        }
    }

    // 解析分镜的数据
    func parseShots(json: [String: Any]) -> [ShotListView.Shot] {
        // 这里只是一个示例，你需要根据你的数据格式来实现这个功能
        return MockData.mockShotLists
    }
}
