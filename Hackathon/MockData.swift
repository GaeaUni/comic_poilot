//
//  MockData.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/12.
//

import Foundation

class MockData {
    static let mockShotListsText = """
    格子1：画面展示平行宇宙的景象，星球、星系、黑洞等元素交织在一起，旁白介绍这个世界的设定：“在这个平行宇由中，每个人都可能在特定条件下觉醒一项超能力，但大部分人不会觉醒。”
    格子2：画面转向一个城市的景象，高楼大厦、繁忙的街道，旁白继续：“杰克，一个普通的程序员，他在长达三十年的人生中，井没有觉醒超能力。”
    格子3：画面中，杰克坐在电脑前，眼神疲意，旁白说：“他只能靠打工赚取微薄的新水。”
    格子4：画面展示杰克在一间破日的公寓里，面对一堆账单，旁白说：“他背负着高额的房货，生活在经济的压力下。“画面中，杰克的表情焦虑。
    格子5：画面展示经济危机的新闻报道，旁白说：“经济危机的来临，让杰克的生活更加艰难。“
    格子6：画面展示杰克在被一群粗暴的债主威胁的情況下，旁白说：“为了不断货，他只好借高利贷。“
    格子7：画面中，杰克的手中突然出现了一把光芒闪耀的键盘，旁白说：“在一次高利货的暴力催收中，杰克意外觉醒了超能力。“
    格子8：画面展示杰克在键盘前快速敲打，旁白说：“他的超能力是一把键盘，用这把键盘可以敲出任何想要的代码。“
    格子9：画面中，代码如瀑布般从键盛流出，环绕在杰克周围，旁白说：“他开始利用他的超能力，创造出一些前所未有的技术“
    格子10：画面展示杰克站在一座科技大厦的顶端，旁白说：“他的名声日益增长，他成为了一位知名科学家。“
    格子11：画面展示杰克在接受媒体采访，旁白说：“他为人类创造了多项跨时代的技术，同时也为自己创造了巨额财富。“
    格子12：画面展示杰克和他的家人在山林中的新家，旁白说：“最終他携带巨额财富，携带家人隐居山林，过上了幸福的生活。“
    """
    static var mockShotLists: [ShotListView.Shot] {
        let shotTexts = mockShotListsText.components(separatedBy: "\n")
        return shotTexts.map { shotText -> ShotListView.Shot in
            guard let range = shotText.range(of: "：") else {
                return ShotListView.Shot(title: "", description: "")
            }

            let title = String(shotText[..<range.lowerBound])
            let description = String(shotText[range.upperBound...])

            return ShotListView.Shot(title: title, description: description)
        }
    }
}
