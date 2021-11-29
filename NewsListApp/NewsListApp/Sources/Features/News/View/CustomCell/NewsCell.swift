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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(newsImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        newsImage.anchor(top: topAnchor, left: leftAnchor,
                         bottom: bottomAnchor, right: nil, paddingTop: 5,
                         paddingLeft: 5, paddingBottom: 5, paddingRight: 0,
                         width: 90, height: 100, enableInsets: false)
        titleLabel.anchor(top: topAnchor, left: newsImage.rightAnchor,
                          bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10,
                          paddingBottom: 0, paddingRight: 0, width: frame.size.width,
                          height: 0, enableInsets: false)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor,
                                left: newsImage.rightAnchor, bottom: nil, right: nil,
                                paddingTop: 0, paddingLeft: 10, paddingBottom: 0,
                                paddingRight: 0, width: frame.size.width,
                                height: 0, enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
