//
//  NewsHeaderView.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import Foundation
import UIKit

/// Tableview custom protocol
public protocol TableViewCellProtocol {
    func updateUI<T>(value: T)
}

final class NewsHeaderView: UITableViewHeaderFooterView, TableViewCellProtocol {
    
    let titleLabel = UILabel()
    let image = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        image.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        
        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: 20),
            image.heightAnchor.constraint(equalToConstant: 20),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor,
                                                constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo:
                                                    contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    /// UpdateUI
    /// - Parameter value: Generic Type
    func updateUI<T>(value: T) {
        guard let title = value as? String else { return }
        image.image = #imageLiteral(resourceName: "icons8-news-100")
        titleLabel.text = title
    }
}
