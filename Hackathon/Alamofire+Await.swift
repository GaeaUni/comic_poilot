//
//  Alamofire+Await.swift
//  Hackathon
//
//  Created by 周亮 on 2023/7/13.
//

import Alamofire
import Combine

extension DataRequest {
    func responseAsync(queue: DispatchQueue = .main) async throws -> (Data, HTTPURLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            self.responseData(queue: queue) { response in
                switch response.result {
                case .success(let data):
                    if let httpResponse = response.response {
                        continuation.resume(returning: (data, httpResponse))
                    } else {
                        continuation.resume(throwing: AFError.responseValidationFailed(reason: .dataFileNil))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
