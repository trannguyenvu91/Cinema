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
        updateCompletion()
    }
    
}
