//
//  ArticleViewModel.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import Foundation
import UIKit

/// Article View Model
struct ArticleViewModel: Equatable {
    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        true
    }
    
    private(set) var article: Article
}

// MARK: - Internal Methods
extension ArticleViewModel {
        
    init(_ article: Article) {
        self.article = article
    }
}

// MARK: - Internal Methods for Article Model

extension ArticleViewModel {
 
    /// Title
    var title: String {
         self.article.title ?? ""
    }
    
    /// Description
    var description: String? {
         self.article.description
    }
    
    /// Set Image from URL
    /// - Parameter completion: UIImage Type
    func image(completion: @escaping (UIImage?) -> Void) {
        
        guard let imageURL = article.imageURL else {
            completion(UIImage.imageForPlaceHolder())
            return
        }
        UIImage.imageForHeadline(url: imageURL) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
