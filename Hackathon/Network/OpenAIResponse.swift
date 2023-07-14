//
//  OpenAIResponse.swift
//  Hackathon
//
//  Created by zy on 2023/7/11.
//

import Foundation

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let role: String
            let content: String
        }
        
        let index: Int
        let finishReason: String
        let message: Message

        enum CodingKeys: String, CodingKey {
            case index
            case finishReason = "finish_reason"
            case message
        }
    }
    
    struct Usage: Decodable {
        let completionTokens: Int
        let promptTokens: Int
        let totalTokens: Int

        enum CodingKeys: String, CodingKey {
            case completionTokens = "completion_tokens"
            case promptTokens = "prompt_tokens"
            case totalTokens = "total_tokens"
        }
    }
    
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
}
