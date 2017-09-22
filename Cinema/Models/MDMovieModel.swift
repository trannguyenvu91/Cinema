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
    let id: Int?
    let languges: [JSON]?
    let genres: [JSON]?
    
    
}

extension MDMovieModel {
    
    init(with json: JSON?) {
        id = json?["id"] as? Int
        title = json?["original_title"] as? String
        popularity = json?["popularity"] as? Double
        posterPath = json?["poster_path"] as? String
        overview = json?["overview"] as? String
        languges = json?["spoken_languages"] as? [JSON]
        genres = json?["genres"] as? [JSON]
    }
    
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
    
    func getGenersString() -> String? {
        return getDescription(json: genres)
    }
    
    func getLanguagesString() -> String? {
        return getDescription(json: languges)
    }
    
    func getDescription(json: [JSON]?) -> String? {
        guard let dict = json, dict.count > 0 else { return nil }
        var result = ""
        var count = dict.count
        for genre in dict {
            count -= 1
            if let text = genre["name"] as? String {
                result.append(text + (count == 0 ? "." : ", "))
            }
        }
        return result
    }
    
}
