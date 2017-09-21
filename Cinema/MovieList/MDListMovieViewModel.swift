//
//  MDListMovieViewModel.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit

class MDListMovieViewModel: NSObject {
    let movieProvider = MDListMovieProvider()
    var didFinishLoading: (() -> Void)? {
        didSet {
            movieProvider.didFinishLoading = didFinishLoading
        }
    }
    
    override init() {
        super.init()
    }
    
    func refreshMovies() {
        movieProvider.refresh()
    }
    
    func loadMore() {
        movieProvider.loadMore()
    }
    
    func getMovie(at indexPath: IndexPath) -> MDMovieModel? {
        return movieProvider.model(at: indexPath) as? MDMovieModel
    }
    
}
