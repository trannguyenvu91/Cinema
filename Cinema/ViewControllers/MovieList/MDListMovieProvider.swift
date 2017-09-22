//
//  MDListMovieProvider.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit

enum MDProviderState {
    case initial
    case loading
    case loaded
    case empty
    case error
}

class MDListMovieProvider: NSObject, MDListProviderProtocol {
    
    var reloadNotification: (() -> Void)?
    var updatesNotification: (([IndexPath], [IndexPath], [IndexPath]) -> Void)?
    var didFinishLoading: (() -> Void)?
    var state = MDProviderState.initial
    var movies = [MDMovieModel]()
    var currentPageIndex = 1
    var totalPage = Int.max
    
    func model(at indexPath: IndexPath) -> MDModelProtocol? {
        return movies[indexPath.row]
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return movies.count
    }
    
    func getMovies(at pageIndex: Int, successBlock: @escaping (_ page:Int, _ pagesCount: Int, _ movies: [MDMovieModel]) -> Void) {
        services.getMovies(at: pageIndex) { [weak self] (result) in
            switch result {
            case .success(let tuple):
                successBlock(tuple.page, tuple.pagesCount, tuple.movies)
            case .failure(let error):
                print(error.debugDescription)
                self?.didFinishLoading?()
            }
        }
    }
    
    var couldLoadMore: Bool {
        return state != .loading && currentPageIndex < totalPage
    }
    
    var services: MDServerService {
        return MDServerService.shareInstance()
    }
    
}

//MARK: server intergration
extension MDListMovieProvider {
    func refresh() {
        state = .loading
        currentPageIndex = 1
        getMovies(at: currentPageIndex) {[weak self] (pageIndex, pageCount, nextMovies) in
            self?.currentPageIndex = pageIndex
            self?.totalPage = pageCount
            self?.movies.removeAll()
            self?.movies.append(contentsOf: nextMovies)
            self?.reloadNotification?()
            self?.finishLoading()
        }
    }
    
    func loadMore() {
        guard couldLoadMore else {
            return
        }
        state = .loading
        getMovies(at: currentPageIndex + 1) {[weak self] (pageIndex, pageCount, nextMovies) in
            self?.currentPageIndex = pageIndex
            self?.totalPage = pageCount
            self?.movies.append(contentsOf: nextMovies)
            var insertIndexPaths = [IndexPath]()
            for i in ((self?.movies.count)! - nextMovies.count)...((self?.movies.count)! - 1) {
                insertIndexPaths.append(IndexPath(item: i, section: 0))
            }
            self?.updatesNotification?([], insertIndexPaths, [])
            self?.finishLoading()
        }
    }
    
    func finishLoading() {
        state = movies.count > 0 ? .loaded : .empty
        didFinishLoading?()
    }
    
}
