//
//  ContentView.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/10.
//

import SwiftUI


import Kingfisher

struct ContentView: View {
    // 假设你有一个名为ListItem的数据模型，包含title, description和image属性
    var listData: [ListItem] = [
        // 这里填充你的本地数据
        .init(title: "Item 1", description: "Description 1", imageURL: "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/17d33c16-9053-411b-8a32-a093a00ce160/width=450/3978531179-1315543663-best%20quality,%20ultra%20high%20res,%201girl,%20sleeveless%20white%20button%20shirt,%20black%20skirt,%20black%20choker,%20cute,%20(Kpop%20idol),%20(aegyo%20sal_1),.jpeg"),
        .init(title: "Item 2", description: "Description 2", imageURL: "https://image.civitai.com/xG1nkqKTMzGDvpLrqFT7WA/0038e0a9-7543-482b-93bd-e855d2389028/width=450/00008-2987955084.jpeg"),
    ]

    var body: some View {
        NavigationView {
                    List(listData, id: \.self) { item in
                        NavigationLink(destination: StoryGeneratorView()) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text(item.description)
                                        .font(.subheadline)
                                }
                                .padding()
                                Spacer()
                                KFImage(URL(string: item.imageURL))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        }
                    }
                    .background(Color.gray.opacity(0.1)) // 更改整个列表的背景色为浅灰色
                }
        }
}

struct ListItem: Hashable {
    let title: String
    let description: String
    let imageURL: String
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
