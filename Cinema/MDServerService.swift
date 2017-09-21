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

class MDServerService: NSObject {
    static let share = MDServerService()
    
    // MARK: - GetMovies
    enum GetMoviesFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
    
    typealias GetMoviesResult = Result<JSON, GetMoviesFailureReason>
    typealias GetMoviesCompletion = (GetMoviesResult) -> Void
    func getMovies(at pageIndex: Int, completion: @escaping GetMoviesCompletion) {
        Alamofire.request("\(MDConstant.serverBaseURL)/discover/movie?api_key=\(MDConstant.serverAPIKey)&sort_by=release_date.desc&page=\(pageIndex)")
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
                        let reason = GetMoviesFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
}
