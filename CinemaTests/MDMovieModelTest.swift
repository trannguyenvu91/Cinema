//
//  MDMovieModelTest.swift
//  CinemaTests
//
//  Created by VuVince on 9/22/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import XCTest
@testable import Cinema

class MDMovieModelTest: XCTestCase {
    let services = MockServerService.mock
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        let json = services.getJSON(path: services.mockDetailJSONPath)
        let movie = MDMovieModel(with: json)
        XCTAssert(movie.id != nil, "This value should be not nil")
    }
    
}
