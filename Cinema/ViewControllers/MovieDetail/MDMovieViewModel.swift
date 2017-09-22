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
    var updateCompletion: (() -> Void)?
    var services: MDServerService {
        return MDServerService.shareInstance()
    }
    
    
    init(movie: MDMovieModel?, updateCompletion: (() -> Void)?) {
        self.movie = movie
        self.updateCompletion = updateCompletion
    }
    
    func getMovieInfo() {
        services.getMovieDetail(at: movie?.id ?? 0) { [weak self] (result) in
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.updateCompletion?()
            case .failure(let error):
                print(error.debugDescription)
            }
        }
    }
    
}
