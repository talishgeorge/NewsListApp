//
//  CellViewModel.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import Foundation
import UIKit

struct CellViewModel: Equatable {
    let title: String
    let description: String
    let imageUrl: String?
    
    /// Set Image from URL
    /// - Parameter completion: UIImage Type
    func image(completion: @escaping (UIImage?) -> Void) {
        
        guard let imageURL = imageUrl else {
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

struct HeaderViewModel: Equatable {
    let title: String
}
