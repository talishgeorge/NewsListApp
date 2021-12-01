//
//  NewsServices.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

final class NewsServices {
    func getNews(page: Int, perPage: Int, category: String?, completion: @escaping(Swift.Result<NewsSourcesResponse, ErrorModel>) -> Void) {
        ServiceManager.shared.sendRequest(request: NewsRequestModel()) { (result) in
            completion(result)
        }
    }
}
