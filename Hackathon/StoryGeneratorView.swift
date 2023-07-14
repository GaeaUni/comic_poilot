//
//  DetailView.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/10.
//

import Alamofire
import SwiftUI
import Alamofire

struct StoryGeneratorView: View {
    @State private var finalChapters = [String]()
    private var defaultMessage = "这是一个平行宇宙，每个人都可能在特定条件下觉醒一项超能力，但大部分人不会觉醒。主角是一个程序员，在长达三十年的人生中，并没有觉醒超能力，只能靠打工赚取微薄的薪水，因此背上了高额的房贷，但是遇到经济危机，为了不断贷，只好借高利贷。后来在高利贷的暴力催收中，意外觉醒超能力。他的超能力是一把键盘，用这把键盘可以敲出任何想要的代码。靠着这项能力，他成为知名科学家，即为人类创造了多项跨时代的技术，又为自己创造了巨额财富。最终他携带巨额财富，携带家人隐居山林，过上了幸福的生活。"
    private var request = OpenAIRequest()
    @State private var dataRequest: DataRequest?
    @State private var message = ""
    @State private var selectedShotCount = 4
    @State private var showShotList = false
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var shots: [ShotListView.Shot] = []

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
                    Text(defaultMessage)
                        .foregroundColor(Color(UIColor.placeholderText))
                        .padding(15)
                }
            }
            .padding()
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2)
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
                .disabled(isLoading) // 如果正在加载，则禁用按钮
                .sheet(isPresented: $showShotList) {
                    ShotListView(shots: shots)
                }
                .padding()
            }

            Stepper(value: $selectedShotCount, in: 4 ... 20) {
                Text("选择分镜数量: \(selectedShotCount)")
            }
            .padding()
            .disabled(isLoading)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("错误"), message: Text("请求失败，请重试"), dismissButton: .default(Text("好的")))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("故事描述")
                    .font(.headline)
            }
        }
        .onDisappear{
            dataRequest?.cancel()
        }
    }
}

extension StoryGeneratorView {
    // 生成分镜
    func generateShots() {
        isLoading = true
        var prompt = message
        if prompt.isEmpty {
            prompt = defaultMessage
        }
        dataRequest = request.startRequest(prompt: prompt, chapterNumber: selectedShotCount) { success, chapters in
            isLoading = false
            if success, let tempChapters = chapters {
                parseShots(chapters: tempChapters)
                showShotList = true
            } else {
                showAlert = true
            }
        }
    }

    // 解析分镜的数据
    func parseShots(chapters: [String]) {
        shots.removeAll()
        var index = 0
        for chapter in chapters {
            index += 1
            let short = ShotListView.Shot(title: "第\(index)章节", description: chapter)
            shots.append(short)
        }
    }
}
