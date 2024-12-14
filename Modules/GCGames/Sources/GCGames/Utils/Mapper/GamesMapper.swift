//
//  GamesMapper.swift
//  GCGames
//
//  Created by Steven Lie on 06/12/24.
//

import Foundation
import GCCommon

final class GamesMapper {
    static func mapGameResponsesToDomains(input gameResponse: GamesResponse) -> [GameModel] {
        
        guard let results = gameResponse.results
        else { return [] }
        
        return results.map { result in
            return GameModel(
                id: result.id,
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                ratingTop: result.ratingTop,
                genres: result.genres?.map { genre in
                    return GenreModel(id: genre.id, name: genre.name) // Adjust according to GenreModel properties
                },
                shortScreenshots: result.shortScreenshots?.map { shortScreenshot in
                    return ShortScreenshotModel(id: shortScreenshot.id, image: shortScreenshot.image)
                })
        }
    }
    
    static func mapFavoriteGamesResponseToDomains(input gameResponse: [FavoriteGames]) -> [FavoriteGameModel] {
        return gameResponse.map { result in
            return FavoriteGameModel(
                id: Int(result.id),
                name: result.name,
                released: result.released,
                backgroundImage: result.backgroundImage,
                rating: result.rating,
                genres: result.genres)
        }
    }
}
