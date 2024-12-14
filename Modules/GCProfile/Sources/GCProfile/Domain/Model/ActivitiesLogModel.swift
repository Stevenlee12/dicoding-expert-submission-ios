//
//  File.swift
//  GCProfile
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation

public struct ActivityLogModel: Equatable, Identifiable {
    public let id: Int
    public let gameTitle: String?
    public let gameImage: String?
    public let date: Date?
    public let activityStatus: Int?
    
    public init(id: Int, gameTitle: String?, gameImage: String?, date: Date?, activityStatus: Int?) {
        self.id = id
        self.gameTitle = gameTitle
        self.gameImage = gameImage
        self.date = date
        self.activityStatus = activityStatus
    }
}
