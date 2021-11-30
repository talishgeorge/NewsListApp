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
    private let viewModel = CategoryListViewModel()
    private var pullControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        //Register Tableview header
        tableView.register(NewsHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: CellIdentifiers.newsHeaderCell)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        //Register Tableview cell
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellId)
        
        //Nav titile
        navigationItem.title = "Latest News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Service call to fetch latest news
        ActivityIndicator.show("Please Wait...")
        fetchNews(by: ApiConstants.newsCategory)
        
        pullControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        pullControl.addTarget(self, action: #selector(refreshListData(_:)), for: .valueChanged)
        pullControl.tintColor = UIColor.red
        if #available(iOS 10.0, *) {
            tableView.refreshControl = pullControl
            tableView.addSubview(pullControl)
        } else {
            tableView.addSubview(pullControl)
        }
    }
}

extension NewsController {
    
    /// Fetch News
    /// - Parameter category: String
    func fetchNews(by category: String) {
        viewModel.fetchNews(by: ApiConstants.newsCategory)
    }
}

//Table view data source
extension NewsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let newsData = viewModel.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
        switch newsData.category {
        case .general(let model):
            cell.updateUI(model)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//Table view delegate

extension NewsController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellIdentifiers.newsHeaderCell) as? NewsHeaderView
        else {
            return UITableViewHeaderFooterView()
        }
        
        let headerName = viewModel.categoryAtIndex(index: section).name
        headerCell.updateUI(value: headerName)
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard tableView.indexPathForSelectedRow != nil else {
            fatalError("Unable to get the selected row")
        }
    }
    
    @objc func refreshListData(_ sender: Any) {
        fetchNews(by: ApiConstants.newsCategory)
    }
}

extension NewsController: CategoryListViewModelDelegate {
    
    /// Refresh UI
    func categoryListViewModelDidStartRefresh(_ viewModel: CategoryListViewModel) {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        ActivityIndicator.dismiss()
    }
    
    /// Show Error
    func categoryListViewModel(_ viewModel: CategoryListViewModel, didFinishWithError error: Error?) {
        guard let errorDescription = error?.localizedDescription, !errorDescription.isEmpty else {
            return
        }
        self.showMessage( message: "API Error please try pull to refresh")
        ActivityIndicator.dismiss()
        self.refreshControl?.endRefreshing()
        viewModel.showOfflineData()
    }
}

