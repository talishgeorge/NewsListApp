//
//  CategoryListViewModel.swift
//  NewsListApp
//
//  Created by Talish George on 30/11/21.
//

import Foundation
import UIKit

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

/// Category List Model
/// Protocol
protocol CategoryListViewModelDelegate: class {
    func categoryListViewModelDidStartRefresh(_ viewModel: CategoryListViewModel)
    func categoryListViewModel(_ viewModel: CategoryListViewModel, didFinishWithError error: Error?)
}

final class CategoryListViewModel: BaseViewModel {
    
    weak var delegate: CategoryListViewModelDelegate?
    private(set) var sections: [Section] = []
    
    var categories: [Category] = [] {
        didSet {
            sections = [article].compactMap { $0 }
        }
    }
}

// MARK: - Internal Methods for TableView

extension CategoryListViewModel {
    
    /// Return Number of Sections for UITableView
    var numberOfSections: Int {
        categories.count
    }
    
    /// Return Number of Rows in Sections for UITableView
    /// - Parameter section: Int Value
    func numberOfRowsInSection(_ section: Int) -> Int {
        categories[section].articles.count
    }
    
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
    
    var article: Section? {
        
        if categories.isEmpty {
            return nil
        }
        
        let newsRows = categories[0].articles.compactMap { news -> Row? in
            guard let title = news.title else {
                return nil
            }
            guard let description = news.description else {
                return nil
            }

            guard let imageUrl = news.imageURL else {
                return nil
            }
            
            let cellModel = CellViewModel(title: title, description: description, imageUrl: imageUrl)
            return Row(id: "1", category: .general(cellModel))
        }
        
        let headerModel = HeaderViewModel(title: "News")
        return Section(id: "1", rows: newsRows, category: .articles(headerModel))
    }
}

// MARK: - Internal Methods

extension CategoryListViewModel {
    
    /// Return Category ViewModel
    /// - Parameter index: Int Value
    func categoryAtIndex(index: Int) -> CategoryViewModel {
        CategoryViewModel(name: categories[index].title, articles: categories[index].articles)
    }
    
    /// Return Article For Section
    /// - Parameters:
    ///   - section: Int Value
    ///   - index: Int Value
    func articleForSectionAtIndex(section: Int, index: Int) -> ArticleViewModel {
        categoryAtIndex(index: section).articleAtIndex(index)
    }
    
    /// Fetch News
    /// - Parameter category: String
    func fetchNews(by category: String) {
        let closureSelf = self
        webService.getNews(category: category) { result in
            var categories = [Category]()
            switch result {
            case Result.success(let response):
                let category = Category(title: "General", articles: response.articles)
                categories.append(category)
                closureSelf.categories = categories
                DispatchQueue.main.async {
                    closureSelf.delegate?.categoryListViewModelDidStartRefresh(self)
                }
            case Result.failure(let error):
                DispatchQueue.main.async {
                    closureSelf.delegate?.categoryListViewModel(self, didFinishWithError: error)
                }
            }
        }
    }
    
    /// Show offline data
    func showOfflineData() {
        categories = Category.loadLocalData()
        self.delegate?.categoryListViewModelDidStartRefresh(self)
    }
}

/// Category view model
struct CategoryViewModel {
    let name: String
    let articles: [Article]
}

extension CategoryViewModel {
    
    /// Return Article View Model
    /// - Parameter index:Int Value
    func articleAtIndex(_ index: Int) -> ArticleViewModel {
        let article = self.articles[index]
        return ArticleViewModel(article)
    }
}
