//
//  Movie.swift
//  MovieSearch
//
//  Created by Devin Singh on 1/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

struct TopLevelObject: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let title: String?
    let imagePath: String?
    let overview: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case title
        case imagePath = "poster_path"
        case overview
        case rating = "vote_average"
    }
}
