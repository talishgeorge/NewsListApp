//
//  Category.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

/// Category Model
struct Category {
    let title: String
    let articles: [Article]
}

extension Category {
    
    /// If API fails, Load data from Local JSON
    static func loadLocalData() -> [Category] {
        var categories = [Category]()
        do {
            if let bundlePath = Bundle.main.path(forResource: ApiConstants.article,
                                                 ofType: ApiConstants.decodingType),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                do {
                    let data = try JSONDecoder().decode(NewsSourcesResponse.self, from: jsonData).articles
                    let category = Category(title: ApiConstants.newsCategory, articles: data)
                    categories.append(category)
                } catch _ {
                }
            }
        } catch {
        }
        return categories
    }
}
