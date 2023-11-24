//
//  CleanArchitectureTests.swift
//  CleanArchitectureTests
//
//  Created by richa on 06/12/20.
//  Copyright © 2020 harsivo. All rights reserved.
//

import XCTest
@testable import CleanArchitecture

class CleanArchitectureTests: XCTestCase {

    override func setUp() {
       loadLocalData()
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

    /// Load data from Local JSON
    func loadLocalData()  {
        do {
            if let bundlePath = Bundle.main.path(forResource: "GalleryModel",
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                do {
                    let data = try JSONDecoder().decode(GalleryModel.self, from: jsonData)
                    print("Parsing Success\(data)")
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                }
                catch {
                    print("Parse error \(error.localizedDescription)")
                }
            }
        } catch {
        }
    }
}
