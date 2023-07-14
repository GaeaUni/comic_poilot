//
//  ShotListView.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/11.
//

import SwiftUI

struct ShotListView: View {
    // 分镜数据模型
    struct Shot {
        let title: String
        let description: String
    }

    let shots: [Shot]

    var body: some View {
        NavigationView {
            List(shots, id: \.title) { shot in
                NavigationLink(destination: EditShotView(shot: shot)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(shot.title)
                                .font(.headline)
                            Text(shot.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()

                        Image(systemName: "pencil.circle")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarTitle("分镜列表")
        }
    }
}
