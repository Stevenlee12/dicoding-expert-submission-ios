//
//  APIAction.swift
//  GameCenter
//
//  Created by Steven Lie on 12/09/22.
//

import Foundation
import Alamofire

enum APIAction {
    case getGames(id: Int?, searchQuery: String? = nil)
}

extension APIAction: APIRouter {
    var method: HTTPMethod {
        switch self {
        case .getGames:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getGames(let id, _):
            var path = "games"
            if let id = id {
                path = "games/\(id)"
            }
            return path
        }
    }
    
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String
        else {
          fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
        
        return value
    }

    var actionParameters: [String: Any] {
        switch self {
        case .getGames(_, let searchQuery):
            var param: [String: Any] = [:]
            param["key"] = apiKey
            
            if let searchQuery = searchQuery {
                param["search"] = searchQuery
            }
            return param
        }
    }

    var baseURL: String {
        return "https://api.rawg.io/api/"
    }

    var authHeader: HTTPHeaders? {
        switch self {
        default:
            return [:]
        }
    }
}
