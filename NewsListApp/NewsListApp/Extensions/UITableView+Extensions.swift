//
//  UITableView+Extensions.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import UIKit

extension UITableView {
    
    func initHeaderview(_ backgorundColor: UIColor? = nil) {
        let streachAreaView = UIView()
        streachAreaView.translatesAutoresizingMaskIntoConstraints = false
        streachAreaView.backgroundColor = backgroundColor ?? tableHeaderView?.backgroundColor ?? UIColor.blue
        insertSubview(streachAreaView, at: 0)
        
        NSLayoutConstraint.activate([
            streachAreaView.topAnchor.constraint(equalTo: frameLayoutGuide.topAnchor).with(priority: .defaultHigh),
            streachAreaView.widthAnchor.constraint(equalTo: widthAnchor),
            streachAreaView.bottomAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
