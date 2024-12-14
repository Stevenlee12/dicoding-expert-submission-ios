//
//  GameResponse.swift
//  GCGames
//
//  Created by Steven Lie on 06/12/24.
//

import Foundation

public struct GamesResponse: Codable {
    let results: [Game]?
    let error: String?
}

public struct Game: Codable {
    let id: Int
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let genres: [Genre]?
    let shortScreenshots: [ShortScreenshot]?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case genres
        case shortScreenshots = "short_screenshots"
    }
}

public struct Genre: Codable {
    let id: Int?
    let name: String?
}

public struct ShortScreenshot: Codable {
    let id: Int?
    let image: String?
}
