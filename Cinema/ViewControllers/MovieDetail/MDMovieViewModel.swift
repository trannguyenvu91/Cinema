//
//  MDMovieViewModel.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit

class MDMovieViewModel: NSObject {
    var movie: MDMovieModel?
    var updateCompletion: () -> Void
    
    init(movie: MDMovieModel?, updateCompletion: @escaping () -> Void) {
        self.movie = movie
        self.updateCompletion = updateCompletion
    }
    
    func getMovieInfo() {
        guard let movieID = movie?.id else {
            return;
        }
        MDServerService.share.getMovieDetail(at: movieID) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.movie = MDMovieModel(with: response)
                self?.updateCompletion()
            case .failure(let error):
                print(error.debugDescription)
            }
        }
    }
    
}
