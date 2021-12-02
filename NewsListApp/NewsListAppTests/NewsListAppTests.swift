//
//  NewsListAppTests.swift
//  NewsListAppTests
//
//  Created by Talish George on 29/11/21.
//

import XCTest
@testable import NewsListApp

class NewsListAppTests: XCTestCase {
    
    private let viewModel = CategoryListViewModel()
    var urlSession: URLSession!
    
    override func setUp() {
        var categories: [Category] = []
        categories = loadLocalData()
        viewModel.categories = categories
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        urlSession = URLSession(configuration: .default)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        urlSession = nil
        try super.tearDownWithError()
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNewsListNumberOfSections() {
        var numberOfSections = 0
        if !viewModel.categories.isEmpty {
            numberOfSections = viewModel.numberOfSections
        }
        XCTAssertGreaterThan(numberOfSections, 0, "Categories count should be 1 or above")
        XCTAssertTrue((numberOfSections != 0), "Sections Count is \(numberOfSections)")
    }
    
    func testCategoryAtIndex() {
        var categoryVM: CategoryViewModel?
        if !viewModel.categories.isEmpty {
            categoryVM = viewModel.categoryAtIndex(index: 0)
        }
        XCTAssertNotNil(categoryVM, "Category should not be empty")
    }
    
    
    func testNewsListNumberOfRowsInSections() {
        var numberOfRows = 0
        if !viewModel.categories.isEmpty {
            numberOfRows = viewModel.numberOfRowsInSection(0)
        }
        XCTAssertGreaterThan(numberOfRows, 0, "Categories count should be 1 or above")
        XCTAssertTrue((numberOfRows != 0), "Sections Count is \(numberOfRows)")
    }
    
    func testLocalJsonResponseParsing() {
        var categories: [Category] = []
        categories = loadLocalData()
        XCTAssertNotNil(categories, "News API response loaded")
        XCTAssertGreaterThan(categories.count, 0, "Categories count should be 1 or above")
    }
    
    func testOfflineData() {
        viewModel.showOfflineData()
        XCTAssertGreaterThan(viewModel.categories.count, 0, "Categories count should be 1 or above")
    }
    
    func testupdateUI() {
        let cellModel = CellViewModel(title: "Jeffrey Epstein introduced me to Trump at 14, Ghislaine Maxwell accuser says - NBC News", description: "Jeffrey Epstein introduced me to Trump at 14, Ghislaine Maxwell accuser says - NBC News", imageUrl: "https://media-cldnry.s-nbcnews.com/image/upload/t_nbcnews-fp-1200-630,f_auto,q_auto:best/rockcms/2021-12/211201-Ghislaine-Maxwell-trial-al-1214-e65c9a.jpg")
        let newsImage : UIImageView = Factories().imageView
        let title = cellModel.title
        let description = cellModel.description
        
        XCTAssertTrue(!title.isEmpty)
        XCTAssertTrue(!description.isEmpty)
        
        let promise = expectation(description: "Image Download")
        cellModel.image { newsImage.image = $0 }
        
        let url = URL(string: cellModel.imageUrl!)!
        let dataTask = urlSession.dataTask(with: url) { _, response, error in
            
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 50)
    }
    
    func testNewsAPICallCompletes() throws {
        // given
        let urlString = "https://newsapi.org/v2/top-headlines?category=General&country=us&pageSize=20&apiKey=6a3ce0a5c952460fb0ea2fd9163d9ddf"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = urlSession.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        
        dataTask.resume()
        wait(for: [promise], timeout: 50)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testFetchNewsAPI() throws {
        let promise = expectation(description: "Completion handler invoked")
        viewModel.fetchNews(by: ApiConstants.newsCategory, offset: 0,
                            limit: 20, shouldAppend: false) { success, dataCount in
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 50)
    }
    
    /// Load data from Local JSON
    func loadLocalData() -> [Category] {
        var categories = [Category]()
        do {
            if let bundlePath = Bundle.main.path(forResource: ApiConstants.article,
                                                 ofType: ApiConstants.decodingType),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                do {
                    let data = try JSONDecoder().decode(NewsSourcesResponse.self, from: jsonData).articles
                    let category = Category(title: ApiConstants.newsCategory, articles: data)
                    categories.append(category)
                } catch _ {
                }
            }
        } catch {
        }
        return categories
    }
}
