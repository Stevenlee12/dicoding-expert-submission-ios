//
//  DetailGameModel.swift
//  GameCenter
//
//  Created by Steven Lie on 15/09/22.
//

struct DetailGameModel: Codable {
    let id: Int
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let ratings: [Rating]?
    let genres: [Genre]?
    let backgroundImageAdditional: String?
    let description: String?
    let publishers: [Publisher]?
    let error: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case ratings
        case genres
        case backgroundImageAdditional = "background_image_additional"
        case description = "description_raw"
        case publishers
        case error
    }
}

struct Publisher: Codable {
    let id: Int?
    let name: String?
}

struct Rating: Codable {
    let id: Int?
    let count: Int?
}
