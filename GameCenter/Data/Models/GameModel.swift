//
//  GameModel.swift
//  GameCenter
//
//  Created by Steven Lie on 18/08/21.
//

struct Games: Codable {
    let results: [GameModel]?
    let error: String?
}

struct GameModel: Codable {
    let id: Int
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let genres: [Genre]?
    let shortScreenshots: [ShortScreenshot]?

    enum CodingKeys: String, CodingKey {
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

struct ShortScreenshot: Codable {
    let id: Int?
    let image: String?
}
