//
//  Genre.swift
//  GameCenter
//
//  Created by Steven Lie on 12/09/22.
//

struct Genre: Codable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
