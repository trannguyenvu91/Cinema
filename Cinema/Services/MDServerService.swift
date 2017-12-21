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

struct MDResource<T> {
    let urlPath: String!
    let parseResponse:(JSON) -> T
    
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
        let resource = MDResource(urlPath: moviesPath) { (response) -> Any in
            let page = response["page"] as! Int
            let pagesCount = response["total_pages"] as! Int
            let movieInfos = response["results"] as! [JSON]
            let movies = movieInfos.flatMap{MDMovieModel(with: $0)}
            let tuple = MDGetMoviesTuple(page, pagesCount, movies)
            return tuple
        }
        
        return requestAPI(resource: resource, requestCompletion: { (requestResult) in
            switch requestResult {
            case .success(let tuple):
                completion(.success(payload: tuple as! MDServerService.MDGetMoviesTuple))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    //MARK: Movie detail
    typealias MDDetailResult = Result<MDMovieModel, MDFailureReason>
    typealias MDDetailCompletion = (MDDetailResult) -> Void
    
    func getMovieDetail(at movieID: Int, completion: @escaping MDDetailCompletion) {
        let detailPath = "\(MDConstant.serverBaseURL)/movie/\(movieID)?api_key=\(MDConstant.serverAPIKey)"
        let resource = MDResource(urlPath: detailPath) { (response) -> Any in
            return MDMovieModel(with: response)
        }
        
        return requestAPI(resource: resource, requestCompletion: { (requestResult) in
            switch requestResult {
            case .success(let movie):
                completion(.success(payload: movie as! MDMovieModel))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    //MARK: Generic request
    typealias MDResponseResult = Result<Any, MDFailureReason>
    typealias MDRequestCompletion = (MDResponseResult) -> Void
    
    func requestAPI(resource: MDResource<Any>, requestCompletion: @escaping MDRequestCompletion) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(resource.urlPath)
            .validate()
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success:
                    guard let dataDict = response.result.value as? JSON else {
                        requestCompletion(.failure(nil))
                        return
                    }
                    let result = resource.parseResponse(dataDict)
                    requestCompletion(.success(payload: result))
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
