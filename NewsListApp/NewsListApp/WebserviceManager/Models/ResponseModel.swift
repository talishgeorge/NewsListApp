//
//  ResponseModel.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

struct ResponseModel<T: Decodable>: Decodable {
    
    var status: String
    var totalResults: Int
    var error: ErrorModel {
        return ErrorModel(status)
    }
    var rawData: Data?
    var data: T?
    var json: String? {
        guard let rawData = rawData else { return nil }
        return String(data: rawData, encoding: String.Encoding.utf8)
    }
    var request: RequestModel?
    
    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        status = (try? keyedContainer.decode(String.self, forKey: CodingKeys.status)) ?? ""
        totalResults = (try? keyedContainer.decode(Int.self, forKey: CodingKeys.totalResults)) ?? 0
        data = try? keyedContainer.decode(T.self, forKey: CodingKeys.articles)
    }
}

// MARK: - Internal Functions

extension ResponseModel {
    enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case data
        case articles
    }
}
