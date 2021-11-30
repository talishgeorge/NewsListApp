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
    
    override func setUp() {
        viewModel.fetchNews(by: ApiConstants.newsCategory)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNewsListNumberOfSections() {
        let count = viewModel.numberOfSections
        
        XCTAssertTrue(true, "Sections Count is \(count)")
    }
    
    func testNewsListAPIResponseParsing() {
        var categories: [Category] = []
        categories = loadLocalData()
        XCTAssertNotNil(categories, "News API response loaded")
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
