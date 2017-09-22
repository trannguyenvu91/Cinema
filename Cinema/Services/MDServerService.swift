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
    private static let share = MDServerService()
    
    class func shareInstance() -> MDServerService {
        return MDServerService.share
    }
    
    // MARK: - GetMovies
    typealias MDGetMoviesTuple = (page:Int, pagesCount: Int, movies: [MDMovieModel])
    typealias MDGetMoviesResult = Result<MDGetMoviesTuple, MDFailureReason>
    typealias MDGetMoviesCompletion = (MDGetMoviesResult) -> Void
    
    func getMovies(at pageIndex: Int, completion: @escaping MDGetMoviesCompletion) {
        let moviesPath = "\(MDConstant.serverBaseURL)/discover/movie?api_key=\(MDConstant.serverAPIKey)&sort_by=release_date.desc&page=\(pageIndex)"
        return requestAPI(path: moviesPath, requestCompletion: { (requestResult) in
            switch requestResult {
            case .success(let json):
                let page = json["page"] as! Int
                let pagesCount = json["total_pages"] as! Int
                let movieInfos = json["results"] as! [JSON]
                let movies = movieInfos.flatMap{MDMovieModel(with: $0)}
                let tuple = MDGetMoviesTuple(page, pagesCount, movies)
                completion(MDServerService.MDGetMoviesResult.success(payload: tuple))
            case .failure(let error):
                completion(MDServerService.MDGetMoviesResult.failure(error))
            }
        })
    }
    
    //MARK: Movie detail
    typealias MDDetailResult = Result<MDMovieModel, MDFailureReason>
    typealias MDDetailCompletion = (MDDetailResult) -> Void
    
    func getMovieDetail(at movieID: Int, completion: @escaping MDDetailCompletion) {
        let detailPath = "\(MDConstant.serverBaseURL)/movie/\(movieID)?api_key=\(MDConstant.serverAPIKey)"
        
        return requestAPI(path: detailPath, requestCompletion: { (requestResult) in
            switch requestResult {
            case .success(let json):
                let movie = MDMovieModel(with: json)
                completion(MDServerService.MDDetailResult.success(payload: movie))
            case .failure(let error):
                completion(MDServerService.MDDetailResult.failure(error))
            }
        })
    }
    
    //MARK: Generic request
    typealias MDResponseResult = Result<JSON, MDFailureReason>
    typealias MDRequestCompletion = (MDResponseResult) -> Void
    
    func requestAPI(path: String, requestCompletion: @escaping MDRequestCompletion) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(path)
            .validate()
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success:
                    guard let pageInfo = response.result.value as? JSON else {
                        requestCompletion(.failure(nil))
                        return
                    }
                    requestCompletion(.success(payload: pageInfo))
                case .failure(let error):
                    print(error.localizedDescription)
                    if let statusCode = response.response?.statusCode,
                        let reason = MDFailureReason(rawValue: statusCode) {
                        requestCompletion(.failure(reason))
                    }
                    requestCompletion(.failure(nil))
                }
        }
    }
    
}
