//
//  NewsListPresenterTests.swift
//  KeywordNewsTests
//
//  Created by kmjmarine on 2022/05/30.
//

import XCTest

@testable import KeywordNews

class NewsListPresenterTests: XCTestCase {
    var sut: NewsListPresenter!
    
    var viewController: MockNewsListViewController!
    var newsSearchManager: MockSearchManager!
    
    override func setUp() {
        super.setUp()
        
        viewController = MockNewsListViewController()
        newsSearchManager = MockSearchManager()
        
        sut = NewsListPresenter(viewController: viewController, newsSearchManager: newsSearchManager)
    }
    
    override func tearDown() {
        sut = nil
        newsSearchManager = nil
        viewController = nil
        
        super.tearDown()
    }
    
    func test_viewDidLoad() {
        sut.viewDidLoad()
        
        XCTAssertTrue(viewController.isCalledSetupNavigationBar)
        XCTAssertTrue(viewController.isCalledSetupLayout)
    }
    
    func test_didCalledRefresh_fail() {
        newsSearchManager.error = NSError() as Error
        
        sut.didCalledRefresh()
        
        XCTAssertFalse(viewController.isCalledReloadTableView)
        XCTAssertFalse(viewController.isCalledEndRefreshing)
    }
    
    func test_didCalledRefresh_success() {
        newsSearchManager.error = nil
        
        sut.didCalledRefresh()
        
        XCTAssertTrue(viewController.isCalledReloadTableView)
        XCTAssertTrue(viewController.isCalledEndRefreshing)
    }
}


