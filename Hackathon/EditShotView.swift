//
//  EditShotView.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/11.
//

import Kingfisher
import SwiftUI

struct EditShotView: View {
    let shot: ShotListView.Shot
    @State private var isLoading = false
    @State private var isPreviewing = false
    @State private var previewImage: KFImage? = nil
    @State private var showImage = false
    @State private var showTextField = true
    @State private var textFieldText = ""

    init(shot: ShotListView.Shot) {
        self.shot = shot
        _textFieldText = State(initialValue: shot.description)
    }

    var body: some View {
        VStack {
            if showTextField {
                TextEditor(text: $textFieldText)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            } else if showImage {
                previewImage?.resizable().aspectRatio(contentMode: .fit)
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
                        isPreviewing = true
                        showTextField = false
                        showImage = true

                        let description = shot.description.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        let url = URL(string: "https://image.pollinations.ai/prompt/\(description)")
                        previewImage = KFImage(url).onSuccess { _ in
                            isLoading = false
                        }.onFailure { _ in
                            fatalError()
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
        .navigationBarTitle("\(shot.title)")
    }
}
