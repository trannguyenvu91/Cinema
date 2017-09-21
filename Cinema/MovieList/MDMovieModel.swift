//
//  MDMovieModel.swift
//  Cinema
//
//  Created by VuVince on 9/21/17.
//  Copyright © 2017 VuVince. All rights reserved.
//

import UIKit

struct MDMovieModel: MDModelProtocol {
    let title: String?
    let popularity: Double?
    let posterPath: String?
    let overview: String?
    let id: Int!
    
    init(with json: JSON) {
        title = json["original_title"] as? String
        popularity = json["popularity"] as? Double
        posterPath = json["poster_path"] as? String
        overview = json["overview"] as? String
        id = json["id"] as! Int
    }
    
}

extension MDMovieModel {
    
    func getPosterPreviewURL() -> URL? {
        return getPosterURL(size: "w500")
    }
    
    func getPosterThumbURL() -> URL? {
        return getPosterURL(size: "w300")
    }
    
    func getPosterURL(size: String) -> URL? {
        if let path = posterPath {
            return URL(string: MDConstant.imageBaseURL + "/\(size)" + path)
        }
        return nil
    }
    
}
