//
//  NewsViewModel.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

protocol TableViewRow: Equatable {
    associatedtype identifier: Equatable
    var id: identifier { get }
}

protocol TableViewSection: Equatable {
    associatedtype Row: TableViewRow
    associatedtype Identifier: Equatable
    
    var id: Identifier { get }
    var rows: [Row] { get }
}

final class NewsViewModel {
    private(set) var sections: [Section] = []
    var newsResponse: NewsSourcesResponse? {
        didSet {
            sections = [article].compactMap { $0 }
        }
    }
}

extension NewsViewModel {
    
    struct Section: TableViewSection {
        
        let id: String
        let rows: [Row]
        let category: Category
        
        enum Category: Equatable {
            case articles(HeaderViewModel)
        }
    }
    
    struct Row: TableViewRow {
        let id: String
        let category: Category
        
        enum Category: Equatable {
            
            case general(CellViewModel)
        }
    }
}

extension NewsViewModel {
    
    var article: Section? {
        
        guard let articles = newsResponse?.articles else {
            return nil
        }
        
        let newsRows = articles.compactMap { news -> Row? in
            guard let description = news.description else {
                return nil
            }
            let cellModel = CellViewModel(title: description)
            return Row(id: "1", category: .general(cellModel))
        }
        
        let headerModel = HeaderViewModel(title: "News")
        return Section(id: "1", rows: newsRows, category: .articles(headerModel))
    }
}
