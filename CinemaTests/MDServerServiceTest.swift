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
    private let services = MockServerService.mock
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetMoviesListFail() {
        services.mockRequestFail()
        services.getMovies(at: 1) { (result) in
            switch result {
            case Result.success(payload: _):
                XCTAssert(false, "this request should return fail")
            default:
                break
            }
        }
    }
    
    func testGetMoviesListSuccess() {
        services.mockGetMoviesListSuccess()
        services.getMovies(at: 1) { (result) in
            switch result {
            case Result.success(let tuple):
                XCTAssert(tuple.movies.count > 0, "Should have movies")
                XCTAssert(tuple.page > 0, "Should have positive page index")
                XCTAssert(tuple.pagesCount > 0, "Should have more pages")
            default:
                XCTAssert(false, "this request should return success")
                break
            }
        }
    }
    
    func testGetMoviesDetailFail() {
        services.mockRequestFail()
        services.getMovieDetail(at: 1){ (result) in
            switch result {
            case Result.success(payload: _):
                XCTAssert(false, "this request should return fail")
            default:
                break
            }
        }
    }
    
    func testGetMoviesDetailSuccess() {
        services.mockGetDetaiSuccess()
        services.getMovieDetail(at: 1){ (result) in
            switch result {
            case Result.success(let movie):
                XCTAssert(movie.id != nil, "Movie should not be nil")
            default:
                XCTAssert(false, "this request should return success")
                break
            }
        }
    }
    
}

//MARK: MockServerService
final class MockServerService: MDServerService {
    let mockDetailJSONPath = "MockMovieDetail"
    let mockListJSONPath = "MockMoviesList"
    static let mock = MockServerService()
    var mockResponse: JSON?
    
    func getJSON(path: String) -> JSON? {
        let bundle = Bundle(for: self.classForCoder)
        guard let jsonURL = bundle.url(forResource: path, withExtension: "json"),
            let data = try? Data(contentsOf: jsonURL),
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? JSON else {
            return nil
        }
        return json
    }
    
    func mockGetMoviesListSuccess() {
        mockRequestSuccess(jsonPath: mockListJSONPath)
    }

    func mockGetDetaiSuccess() {
        mockRequestSuccess(jsonPath: mockDetailJSONPath)
    }
    
    override func requestAPI(resource: MDResource, requestCompletion: @escaping MDServerService.MDRequestCompletion) {
        guard let json = mockResponse else {
            requestCompletion(MDServerService.MDResponseResult.failure(nil))
            return
        }
        let result = resource.parseResponse(json)
        requestCompletion(MDServerService.MDResponseResult.success(payload: result))
    }
    
    func mockRequestFail() {
        mockResponse = nil
    }
    
    private func mockRequestSuccess(jsonPath: String) {
        guard let json = getJSON(path: jsonPath)  else {
            return
        }
        mockResponse = json
    }
    
}
