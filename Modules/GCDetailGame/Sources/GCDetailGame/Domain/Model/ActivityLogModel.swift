//
//  ActivityLogModel.swift
//  GCDetailGame
//
//  Created by Steven Lie on 16/12/24.
//

import Foundation

public struct ActivityLogModel {
    public let id: Int
    public let gameImage: String?
    public let activityStatus: Int
    public let gameTitle: String?
    public let date: Date?
    
    public init(id: Int, gameImage: String?, activityStatus: Int, gameTitle: String?, date: Date?) {
        self.id = id
        self.gameImage = gameImage
        self.activityStatus = activityStatus
        self.gameTitle = gameTitle
        self.date = date
    }
}
