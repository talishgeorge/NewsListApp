//
//  NewsRequestModel.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

// API Request Model
final class NewsRequestModel: RequestModel {
    override var path: String {
        return ApiConstants.news
    }
}
