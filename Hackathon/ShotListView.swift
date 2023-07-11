//
//  ShotListView.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/11.
//

import SwiftUI

struct ShotListView: View {
    let shotCount: Int
    
    var body: some View {
        NavigationView {
            List(0..<shotCount, id: \.self) { index in
                NavigationLink(destination: EditShotView(shotNumber: index + 1)) {
                    HStack {
                        Text("分镜\(index + 1)")
                            .font(.headline)
                        
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

