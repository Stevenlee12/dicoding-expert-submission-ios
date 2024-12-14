//
//  DetailGameResponse.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import Foundation

public struct DetailGameResponse: Codable {
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

public struct Publisher: Codable {
    let id: Int?
    let name: String?
}

public struct Genre: Codable {
    let id: Int?
    let name: String?
}

public struct Rating: Codable {
    let id: Int?
    let count: Int?
}
