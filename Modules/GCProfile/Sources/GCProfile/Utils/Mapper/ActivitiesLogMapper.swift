//
//  ActivitiesLogMapper.swift
//  GCProfile
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation
import GCCommon

final class ActivitiesLogMapper {
    static func mapActivitiesLogResponseToDomains(input logResponse: [ActivitiesLog]) -> [ActivityLogModel] {
        return logResponse.map { result in
            return ActivityLogModel(
                id: Int(result.id),
                gameTitle: result.gameTitle,
                gameImage: result.gameImage,
                date: result.date,
                activityStatus: Int(result.activityStatus)
            )
        }
    }
}
