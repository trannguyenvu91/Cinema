//
//  MDListMovieProviderTest.swift
//  CinemaTests
//
//  Created by VuVince on 9/22/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import XCTest
@testable import Cinema

class MDListMovieProviderTest: XCTestCase {
    private let mockProvider = MockListMovieProvider()
    
    override func setUp() {
        super.setUp()
    }
    
    func testRefresh() {
        mockProvider.refresh()
        XCTAssert(mockProvider.numberOfItems(in: 0) == mockProvider.getMoreCount, "Data after refresh should be equal")
    }
    
    func testLoadMore() {
        mockProvider.shouldLoadMore = true
        let existMovieCount = mockProvider.numberOfItems(in: 0)
        mockProvider.loadMore()
        XCTAssert(mockProvider.numberOfItems(in: 0) == existMovieCount + mockProvider.getMoreCount, "Data after refresh should be added")
    }
    
    func testCantLoadMore() {
        mockProvider.shouldLoadMore = false
        let existMovieCount = mockProvider.numberOfItems(in: 0)
        mockProvider.loadMore()
        XCTAssert(mockProvider.numberOfItems(in: 0) == existMovieCount, "Data after refresh should not load more")
    }
    
    func testStates() {
        mockProvider.refresh()
        XCTAssert(mockProvider.state == .loaded, "State after refresh should be loaded")
        mockProvider.loadMore()
        XCTAssert(mockProvider.state == .loaded, "Data after load more should be loaded")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
}

private final class MockListMovieProvider: MDListMovieProvider {
    let getMoreCount = 2
    var shouldLoadMore = true
    
    override func getMovies(at pageIndex: Int, successBlock: @escaping (Int, Int, [MDMovieModel]) -> Void) {
        let moreMovies = [MDMovieModel](repeating: MDMovieModel(with: nil), count: getMoreCount)
        successBlock(pageIndex + 1, Int.max, moreMovies)
    }
    
    override var couldLoadMore: Bool {
        return shouldLoadMore
    }
    
}
