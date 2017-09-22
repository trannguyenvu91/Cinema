//
//  MDServerService.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit
import Alamofire

typealias JSON = Dictionary<String, Any>

enum Result<T, U> where U: Error {
    case success(payload: T)
    case failure(U?)
}

enum MDFailureReason: Int, Error {
    case unAuthorized = 401
    case notFound = 404
}

class MDServerService: NSObject {
    static let share = MDServerService()
    
    // MARK: - GetMovies
    func getMovies(at pageIndex: Int, completion: @escaping MDRequestCompletion) {
        let moviesPath = "\(MDConstant.serverBaseURL)/discover/movie?api_key=\(MDConstant.serverAPIKey)&sort_by=release_date.desc&page=\(pageIndex)"
        return requestAPI(path: moviesPath, completion: completion)
    }
    
    //MARK: Movie detail
    func getMovieDetail(at movieID: Int, completion: @escaping MDRequestCompletion) {
        let detailPath = "\(MDConstant.serverBaseURL)/movie/\(movieID)?api_key=\(MDConstant.serverAPIKey)"
        return requestAPI(path: detailPath, completion: completion)
    }
    
    //MARK: Generic request
    typealias MDResponseResult = Result<JSON, MDFailureReason>
    typealias MDRequestCompletion = (MDResponseResult) -> Void
    func requestAPI(path: String, completion: @escaping MDRequestCompletion) {
        Alamofire.request(path)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let pageInfo = response.result.value as? JSON else {
                        completion(.failure(nil))
                        return
                    }
                    completion(.success(payload: pageInfo))
                case .failure(let error):
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode,
                        let reason = MDFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
}
