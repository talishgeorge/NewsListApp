//
//  Factories.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import UIKit

class Factories {
    
    // MARK: - Labels
    
    var titleLabel : UILabel = {
        let lbl = PaddingLabel(withInsets: 5, 5, 10, 5)
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    var descriptionLabel : UILabel = {
        let lbl = PaddingLabel(withInsets: 5, 5, 10, 5)
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var imageView : UIImageView = {
        let imgView = UIImageView(image: #imageLiteral(resourceName: "placeholder_image_icon"))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    func makeLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // important!
        label.backgroundColor = .yellow
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        
        return label
    }
    
    func makeLabel(withText text: String, size: CGFloat) -> UILabel {
        let label = makeLabel(withText: text)
        label.font = UIFont.systemFont(ofSize: size)
        
        return label
    }
    
    func makeLabel(withText text: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = makeLabel(withText: text, size: size)
        label.backgroundColor = color
        
        return label
    }
}
