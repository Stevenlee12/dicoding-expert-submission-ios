//
//  AddFavoriteGameModel.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

public struct AddFavoriteGameModel {
    public let id: Int
    public let name: String?
    public let released: String?
    public let backgroundImage: String?
    public let rating: Double
    public let genres: String?
    
    public init(id: Int, name: String?, released: String?, backgroundImage: String?, rating: Double, genres: String?) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.genres = genres
    }
}
