//
//  NewsController.swift
//  NewsListApp
//
//  Created by Talish George on 29/11/21.
//

import Foundation

import UIKit

class NewsController: UITableViewController {
    
    let cellId = "cellId"
    private(set) var categories: [Category] = []
    private let viewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Tableview header
        tableView.initHeaderview()
        tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 0.0, height: .leastNormalMagnitude)))
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "NewsHeaderView")
        
        //Register Footer View
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "NewsFooterView")
        
        //Register Tableview cell
//        /tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellId)
        
        //Nav titile
        navigationItem.title = "Latest News"
        
        // Service call to fetch latest news
        ActivityIndicator.show("Please Wait...")
        fetchNews(by: ApiConstants.newsCategory)
    }
}

extension NewsController {
    
    /// Fetch News
    /// - Parameter category: String
    func fetchNews(by category: String) {
        let closureSelf = self
        NewsServices().getNews(category: category) { result in
            var categories = [Category]()
            switch result {
            case Result.success(let response):
                let category = Category(title: "General", articles: response.articles)
                categories.append(category)
                closureSelf.categories = categories
                DispatchQueue.main.async {
                    self.viewModel.newsResponse = response
                    self.tableView.reloadData()
                    ActivityIndicator.dismiss()
                }
            case Result.failure(let error):
                DispatchQueue.main.async {
                    self.showMessage( message: "API Error \(error)")
                    ActivityIndicator.dismiss()
                }
            }
        }
    }
}

//Table view data source
extension NewsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = viewModel.sections[indexPath.section].rows[indexPath.row]
        
        switch row.category {
        case .general(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
            cell.titleLabel.text = model.title
            cell.descriptionLabel.text = model.title
            return cell
        }
    }
}

//Table view delegate

extension NewsController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch viewModel.sections[section].category {
        case .articles(let model):
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "NewsHeaderView")
            headerView?.textLabel?.text = model.title
            return headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if case .articles = viewModel.sections[indexPath.section].category {
            //Present details Page 
        }
    }
}
