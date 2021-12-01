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
    private var tableviewPaginator: TableviewPaginator?
    private let limit = 20
    
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
        tableView.register(LoadMoreCell.self, forCellReuseIdentifier: "LoadMoreCell")
        //Nav titile
        navigationItem.title = "Latest News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Service call to fetch latest news
        ActivityIndicator.show("Please Wait...")
        
        tableviewPaginator = TableviewPaginator.init(paginatorUI: self, delegate: self)
        tableviewPaginator?.initialSetup()
    }
}

//Table view data source
extension NewsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        viewModel.numberOfRowsInSection(section) + (tableviewPaginator?.rowsIn(section: section) ?? 0)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableviewPaginator?.cellForLoadMore(at: indexPath) {
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? NewsCell else {
            return UITableViewCell.init()
        }
        if viewModel.sections[indexPath.section].rows.count > indexPath.row {
            let newsData = viewModel.sections[indexPath.section].rows[indexPath.row]
            switch newsData.category {
            case .general(let model):
                cell.updateUI(model)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = tableviewPaginator?.heightForLoadMore(cell: indexPath) {
            return height
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableviewPaginator?.scrollViewDidScroll(scrollView)
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
}

extension NewsController: CategoryListViewModelDelegate {
    
    /// Refresh UI
    func categoryListViewModelDidStartRefresh(_ viewModel: CategoryListViewModel, success: Bool?, dataCount: Int?) {
        if success! {
            tableviewPaginator?.incrementOffsetBy(delta: dataCount!)
        }
        
        tableviewPaginator?.partialDataFetchingDone()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
        ActivityIndicator.dismiss()
    }
    
    /// Show Error
    func categoryListViewModel(_ viewModel: CategoryListViewModel, didFinishWithError error: Error?, success: Bool?, dataCount: Int?) {
        if success! {
            tableviewPaginator?.incrementOffsetBy(delta: dataCount!)
        }
        tableviewPaginator?.partialDataFetchingDone()
        guard let errorDescription = error?.localizedDescription, !errorDescription.isEmpty else {
            return
        }
        self.showMessage( message: "API Error please try pull to refresh")
        ActivityIndicator.dismiss()
        self.refreshControl?.endRefreshing()
        viewModel.showOfflineData()
    }
}

extension NewsController: TableviewPaginatorUIProtocol {
    func getTableview(paginator: TableviewPaginator) -> UITableView {
        return tableView
    }
    
    func shouldAddRefreshControl(paginator: TableviewPaginator) -> Bool {
        return true
    }
    
    func getPaginatedLoadMoreCellHeight(paginator: TableviewPaginator) -> CGFloat {
        return 44
    }
    
    func getPaginatedLoadMoreCell(paginator: TableviewPaginator) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell") as? LoadMoreCell {
            cell.loadMoreActivityIndicatorView.startAnimating()
            cell.loadMoreActivityIndicatorView.isHidden = false
            return cell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func getRefreshControlTintColor(paginator: TableviewPaginator) -> UIColor {
        return UIColor.tintColor
    }
}

extension NewsController: TableviewPaginatorProtocol {
    func loadPaginatedData(offset: Int, shouldAppend: Bool, paginator: TableviewPaginator) {
        viewModel.fetchNews(by: ApiConstants.newsCategory, offset: offset, limit: limit, shouldAppend: shouldAppend)
    }
}
