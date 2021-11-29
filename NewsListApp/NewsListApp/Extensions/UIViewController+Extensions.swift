//
//  UIViewController+Extensions.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import UIKit

extension UIViewController {
    
    func showMessage(withTitle title: String = "NewsList", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
