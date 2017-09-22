//
//  MDMovieViewModelTest.swift
//  CinemaTests
//
//  Created by VuVince on 9/22/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import XCTest
@testable import Cinema

class MDMovieViewModelTest: XCTestCase {
    private let services = MockServerService.share
    private var viewModel: MockMovieViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MockMovieViewModel(movie: nil, updateCompletion: nil)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetDetailSuccess() {
        var didCallCompletion = false
        viewModel.movie = nil
        viewModel.updateCompletion = {
            didCallCompletion = true
        }
        services.shouldRequestSuccess = true
        viewModel.getMovieInfo()
        XCTAssert(viewModel.movie != nil, "view model should update with new movie!")
        XCTAssert(didCallCompletion, "view model should call completion")
    }
    
    func testGetDetailFail() {
        viewModel.movie = nil
        services.shouldRequestSuccess = false
        viewModel.getMovieInfo()
        XCTAssert(viewModel.movie == nil, "view model should not update with new movie!")
    }
    
}

private final class MockMovieViewModel: MDMovieViewModel {
    override var services: MockServerService {
        return MockServerService.share
    }
}


private final class MockServerService: MDServerService {
    static let share = MockServerService()
    
    var patchMovieDetail: MDServerService.MDDetailResult!
    
    override func getMovieDetail(at movieID: Int, completion: @escaping MDServerService.MDDetailCompletion) {
        completion(patchMovieDetail)
    }
    
    var shouldRequestSuccess: Bool = true {
        didSet {
            if shouldRequestSuccess {
                patchMovieDetail = MockServerService.MDDetailResult.success(payload: MDMovieModel(title: nil, popularity: nil, posterPath: nil, overview: nil, id: 1, languges: nil, genres: nil))
            } else {
                patchMovieDetail = MockServerService.MDDetailResult.failure(MDFailureReason.notFound)
            }
        }
    }
    
}
