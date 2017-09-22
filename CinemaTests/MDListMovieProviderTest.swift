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
    private let services = MockServerService.mock
    
    override func setUp() {
        super.setUp()
    }
    
    func testRefresh() {
        services.mockGetMoviesListSuccess()
        mockProvider.refresh()
        XCTAssert(mockProvider.numberOfItems(in: 0) > 0, "Data after refresh should have items")
    }
    
    func testLoadMore() {
        services.mockGetMoviesListSuccess()
        let existMovieCount = mockProvider.numberOfItems(in: 0)
        mockProvider.loadMore()
        XCTAssert(mockProvider.numberOfItems(in: 0) > existMovieCount, "Data after refresh should be added")
    }
    
    func testCantLoadMore() {
        services.mockRequestFail()
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
    var shouldLoadMore = true
    
    override var services: MockServerService {
        return MockServerService.mock
    }
    
    override var couldLoadMore: Bool {
        return shouldLoadMore
    }
    
}
