//
//  MDServerServiceTest.swift
//  CinemaTests
//
//  Created by VuVince on 9/22/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import XCTest
@testable import Cinema

class MDServerServiceTest: XCTestCase {
    private let services = MockServerService()
    let mockDetailJSONPath = "MockMovieDetail"
    let mockListJSONPath = "MockMoviesList"
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetMoviesListFail() {
        services.result = MDServerService.MDResponseResult.failure(MDFailureReason.notFound)
        services.getMovies(at: 1) { (result) in
            switch result {
            case Result.success(payload: _):
                XCTAssert(false, "Should fail")
            default:
                break
            }
        }
    }
    
    func testGetMoviesListSuccess() {
        guard let json = services.getJSON(path: mockListJSONPath)  else {
            return
        }
        services.result = MDServerService.MDResponseResult.success(payload: json)
        services.getMovies(at: 1) { (result) in
            switch result {
            case Result.success(let tuple):
                XCTAssert(tuple.movies.count > 0, "Should fail")
                XCTAssert(tuple.page > 0, "Should fail")
                XCTAssert(tuple.pagesCount > 0, "Should fail")
            default:
                XCTAssert(false, "Should fail")
                break
            }
        }
    }
    
    
    func testGetMoviesDetailFail() {
        services.result = MDServerService.MDResponseResult.failure(MDFailureReason.notFound)
        services.getMovieDetail(at: 1){ (result) in
            switch result {
            case Result.success(payload: _):
                XCTAssert(false, "Should fail")
            default:
                break
            }
        }
    }
    
    func testGetMoviesDetailSuccess() {
        guard let json = services.getJSON(path: mockDetailJSONPath)  else {
            return
        }
        services.result = MDServerService.MDResponseResult.success(payload: json)
        services.getMovieDetail(at: 1){ (result) in
            switch result {
            case Result.success(let movie):
                XCTAssert(movie.id != nil, "Movie should not be nil")
            default:
                XCTAssert(false, "Should fail")
                break
            }
        }
    }
    
}

//MARK: MockServerService
private final class MockServerService: MDServerService {
    var result: MDServerService.MDResponseResult!
    
    override func requestAPI(path: String, requestCompletion: @escaping MDServerService.MDRequestCompletion) {
        requestCompletion(result)
    }
    
    func getJSON(path: String) -> JSON? {
        let bundle = Bundle(for: self.classForCoder)
        guard let jsonURL = bundle.url(forResource: path, withExtension: "json"),
            let data = try? Data(contentsOf: jsonURL),
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON else {
            return nil
        }
        return json
    }
    
    
}
