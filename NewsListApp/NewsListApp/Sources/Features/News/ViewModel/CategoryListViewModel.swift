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
    func categoryListViewModel(_ viewModel: CategoryListViewModel, didFinishWithError error: Error?, success: Bool?, dataCount: Int?)
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

// MARK: - Internal members and properties for tableview databinding

extension CategoryListViewModel {
    
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

// MARK: - Internal methods

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
    
    /// Return Category ViewModel
    /// - Parameter index: Int Value
    func categoryAtIndex(index: Int) -> CategoryViewModel {
        CategoryViewModel(name: categories[index].title, articles: categories[index].articles)
    }
    
    /// Fetch News
    /// - Parameter category: String
    func fetchNews(by category: String, offset: Int, limit: Int, shouldAppend: Bool, completion: @escaping(Bool, Int) -> Void) {
        let page = offset / limit
        print("page: \(page+1), per-page=\(limit)")
        webService.getNews(page: page, perPage: limit, category: category) { [weak self]  result in
            guard let self = self else { return }
            var categories = [Category]()
            switch result {
            case Result.success(let response):
                let category = Category(title: "General", articles: response.articles)
                categories.append(category)
                self.categories = categories
                DispatchQueue.main.async {
                    completion(true, categories[0].articles.count)
                }
            case Result.failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.categoryListViewModel(self, didFinishWithError: error, success: false, dataCount: 0)
                    completion(false, 0)
                }
            }
        }
    }
    
    /// Show offline data
    func showOfflineData() {
        categories = Category.loadLocalData()
    }
}

/// Category view model
struct CategoryViewModel {
    let name: String
    let articles: [Article]
}
