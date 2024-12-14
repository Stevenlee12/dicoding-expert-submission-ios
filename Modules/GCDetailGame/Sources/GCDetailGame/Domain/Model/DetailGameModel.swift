//
//  DetailGameModel.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import Foundation

public struct DetailGameModel: Codable {
    public let id: Int
    public let name: String?
    public let released: String?
    public let backgroundImage: String?
    public let rating: Double?
    public let ratingTop: Int?
    public let ratings: [RatingModel]?
    public let genres: [GenreModel]?
    public let backgroundImageAdditional: String?
    public let description: String?
    public let publishers: [PublisherModel]?
    public let error: String?
    
    public init(
        id: Int,
        name: String?,
        released: String?,
        backgroundImage: String?,
        rating: Double?,
        ratingTop: Int?,
        ratings: [RatingModel]?,
        genres: [GenreModel]?,
        backgroundImageAdditional: String?,
        description: String?,
        publishers: [PublisherModel]?,
        error: String?
    ) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingTop = ratingTop
        self.ratings = ratings
        self.genres = genres
        self.backgroundImageAdditional = backgroundImageAdditional
        self.description = description
        self.publishers = publishers
        self.error = error
    }
}

public struct PublisherModel: Codable {
    public let id: Int?
    public let name: String?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

public struct GenreModel: Codable {
    public let id: Int?
    public let name: String?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

public struct RatingModel: Codable {
    public let id: Int?
    public let count: Int?
    
    public init(id: Int?, count: Int?) {
        self.id = id
        self.count = count
    }
}
