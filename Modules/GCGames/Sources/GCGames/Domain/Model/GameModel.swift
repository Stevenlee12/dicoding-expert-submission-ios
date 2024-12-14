//
//  GameModel.swift
//  GCGames
//
//  Created by Steven Lie on 06/12/24.
//

import Foundation

public struct GenreModel: Equatable, Identifiable {
    public let id: Int?
    public let name: String?
    
    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

public struct ShortScreenshotModel: Equatable, Identifiable {
    public let id: Int?
    public let image: String?
    
    public init(id: Int?, image: String?) {
        self.id = id
        self.image = image
    }
}

public struct GameModel: Equatable, Identifiable {
    public let id: Int
    public let name: String?
    public let released: String?
    public let backgroundImage: String?
    public let rating: Double?
    public let ratingTop: Int?
    public let genres: [GenreModel]?
    public let shortScreenshots: [ShortScreenshotModel]?
    
    public init(id: Int, name: String?, released: String?, backgroundImage: String?, rating: Double?, ratingTop: Int?, genres: [GenreModel]?, shortScreenshots: [ShortScreenshotModel]?) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.ratingTop = ratingTop
        self.genres = genres
        self.shortScreenshots = shortScreenshots
    }
}
