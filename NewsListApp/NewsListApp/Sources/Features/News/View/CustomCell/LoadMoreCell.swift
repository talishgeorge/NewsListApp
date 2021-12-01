//
//  LoadMoreDateCell.swift
//  NewsListApp
//
//  Created by Talish George on 1/12/21.
//

import UIKit

class LoadMoreCell: UITableViewCell {

    let loadMoreActivityIndicatorView = UIActivityIndicatorView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        loadMoreActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadMoreActivityIndicatorView)
        loadMoreActivityIndicatorView.center(inView: self)
    }
}
