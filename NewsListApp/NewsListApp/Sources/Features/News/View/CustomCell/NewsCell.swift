//
//  NewsCell.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import UIKit

class NewsCell : UITableViewCell {
    
    var titleLabel : UILabel = Factories().titleLabel
    
    var descriptionLabel : UILabel = Factories().descriptionLabel
    
    var newsImage : UIImageView = Factories().imageView
    
    // MARK: Initalizers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(newsImage)
        newsImage.translatesAutoresizingMaskIntoConstraints = false
        newsImage.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        newsImage.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        newsImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
                
        // configure titleLabel
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: newsImage.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        
        // configure authorLabel
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leadingAnchor.constraint(equalTo: newsImage.trailingAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont(name: "Avenir-Book", size: 12)
        descriptionLabel.textColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Update Cell UI Elements
    /// - Parameter vm: Generic Type
    func updateUI(_ model: CellViewModel) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.description
        model.image { self.newsImage.image = $0 }
    }
}
