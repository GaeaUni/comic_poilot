//
//  OpenAIRequest.swift
//  Hackathon
//
//  Created by zy on 2023/7/11.
//

import Foundation
import Alamofire

class OpenAIRequest {
    let url = "https://hackathon-1.openai.azure.com/openai/deployments/gpt-35-turbo-deploy-1/chat/completions?api-version=2023-05-15"
    let deploymentName = "gpt-35-turbo-deploy-1"
    var prompt: String = "请根据下面的描述，创作短篇漫画大纲。"
    let headers: HTTPHeaders = [
        "Content-Type": "application/json",
        "api-key": "d8eda0ef9b344d5ebc52c710e4714816"
    ]
    var conversations = [
        [
            "role": "system",
            "content": "You are a useful assistant and will not refuse to create a comic story."

        ],
        [
            "role": "user",
            "content": "请理解下面的json格式，后续必须严格按照格式输出。[{\"第一章\": \"章节内容\"},{\"第二章\": \"章节内容\"},{\"第三章\": \"章节内容\"}]",
        ]
    ]
    
    private func updateConversations(prompt: String, number: Int) {
        let conversation = [
            "content": "助手善于判断用户意图，当确定需要提供漫画故事时，助手会变得沉默寡言，只使用json格式输出漫画故事内容,创作\(number)个章节。",
            "role": "user"
        ]
        conversations.append(conversation)
        self.prompt += prompt
        let conversationA = ["content": self.prompt, "role": "user"]
        conversations.append(conversationA)
        let conversationB = ["content": "请按照格式输出，格式外不要有任何内容。并丰富每一个章节的细节。例如背景，灯光，表情等信息，不能只有标题，每个章节不能少于50个字。", "role": "user"]
        conversations.append(conversationB)
        let conversationC = ["content": "请严格按照格式输出。", "role": "user"]
        conversations.append(conversationC)
    }
    
    private func parseTextToChapter(text: String) -> [String]? {
        guard let json = JSONTool.stringToJSON(string: text) else {
            return nil
        }
        guard let array = JSONTool.jsonToArray(json: json) else {
            return nil
        }
        var chapters = [String]()
        for chapter in array {
            guard let content = chapter.values.first else { return nil }
            chapters.append(content)
        }
        
        print("\(chapters)")
        return chapters
    }

    func startRequest(prompt: String, chapterNumber: Int, completion: @escaping (Bool, [String]?) -> Void) -> DataRequest {
        updateConversations(prompt: prompt, number: chapterNumber)
        
        let request = AF.request(url,
                                 method: .post,
                                 parameters: ["messages": conversations, "max_tokens": 6000, "temperature": 0.5],
                                 encoding: JSONEncoding.default,
                                 headers: headers,
                                 requestModifier: { $0.timeoutInterval = 180 })
            .responseDecodable(of: OpenAIResponse.self) { [weak self] response in
                guard let self = self else {
                    completion(false, nil)
                    return
                }
                switch response.result {
                case .success(let openAIResponse):
                    print(openAIResponse)
                    guard let finishReason = openAIResponse.choices.first?.finishReason, finishReason == "stop" else {
                        completion(false, nil)
                        return
                    }
                    guard let text = openAIResponse.choices.first?.message.content else {
                        completion(false, nil)
                        return
                    }
                    guard let chapters = self.parseTextToChapter(text: text) else {
                        completion(false, nil)
                        return
                    }
                    completion(true, chapters)
                case .failure(let error):
                    print(error)
                    completion(false, nil)
                }
            }
        return request
    }
}
