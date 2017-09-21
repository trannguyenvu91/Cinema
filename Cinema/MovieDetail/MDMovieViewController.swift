//
//  MDMovieViewController.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit

class MDMovieViewController: UIViewController {
    var movie: MDMovieModel?
    var viewModel: MDMovieViewModel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MDMovieViewModel(movie: movie, updateCompletion: updateUI)
        updateUI()
        viewModel.getMovieInfo()
    }
    
    func updateUI() {
        movie = viewModel.movie
        labelTitle.text = movie?.title
        imageView.sd_setImage(with: movie?.getPosterThumbURL(), completed: nil)
        labelOverview.text = movie?.overview
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
