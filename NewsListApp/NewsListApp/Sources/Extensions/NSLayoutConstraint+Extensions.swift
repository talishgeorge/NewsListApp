//
//  NSLayoutConstraint+Extensions.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import UIKit

extension NSLayoutConstraint {
    @objc func setActiveBreakable(priority: UILayoutPriority = UILayoutPriority(900)) {
        self.priority = priority
        isActive = true
    }
}
