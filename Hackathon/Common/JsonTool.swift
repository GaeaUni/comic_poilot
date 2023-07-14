//
//  JsonTool.swift
//  Hackathon
//
//  Created by zy on 2023/7/13.
//

import Foundation

class JSONTool {
    
    // 将字符串转换为JSON对象
    static func stringToJSON(string: String) -> Any? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json
        } catch {
            print("Error converting string to json: \(error)")
            return nil
        }
    }
    
    // 将JSON对象转换为数组
    static func jsonToArray(json: Any) -> [[String: String]]? {
        guard let array = json as? [[String: String]] else {
            return nil
        }
        
        return array
    }
    
    // 将JSON对象转换为字典
    static func jsonToDictionary(json: Any) -> [String: String]? {
        guard let dictionary = json as? [String: String] else {
            return nil
        }
        return dictionary
    }
}

