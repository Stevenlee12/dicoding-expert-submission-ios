//
//  DetailGameMapper.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import Foundation

final class DetailGameMapper {
    static func mapDetailGameResponseToDomains(input response: DetailGameResponse) -> DetailGameModel {
        return DetailGameModel(
            id: response.id,
            name: response.name,
            released: response.released,
            backgroundImage: response.backgroundImage,
            rating: response.rating,
            ratingTop: response.ratingTop,
            ratings: response.ratings?.map { rating in
                return RatingModel(id: rating.id, count: rating.count)
            },
            genres: response.genres?.map { genre in
                return GenreModel(id: genre.id, name: genre.name)
            },
            backgroundImageAdditional: response.backgroundImageAdditional,
            description: response.description,
            publishers: response.publishers?.map { publisher in
                return PublisherModel(id: publisher.id, name: publisher.name)
            },
            error: response.error
        )
    }
}
