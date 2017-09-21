//
//  MDMoviePreviewCell.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit
import SDWebImage

class MDMoviePreviewCell: UICollectionViewCell, MDModelViewProtocol {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPopularity: UILabel!
    var movie: MDMovieModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
    
    func setup(with model: MDModelProtocol?) {
        if let movie = model as? MDMovieModel {
            self.movie = movie
            imageView.sd_setImage(with: movie.getPosterThumbURL(), completed: nil)
            labelTitle.text = movie.title
            labelPopularity.text = "\(movie.popularity ?? 0)"
        } else {
            self.movie = nil
        }
    }
    
}
