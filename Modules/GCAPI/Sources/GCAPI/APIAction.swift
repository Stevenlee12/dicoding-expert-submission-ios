//
//  APIAction.swift
//  GCAPI
//
//  Created by Steven Lie on 03/12/24.
//

import Foundation

public struct API {
    static let baseURL = "https://api.rawg.io/api/"
    
    public static var apiKey: String {
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
}

protocol Endpoint {
    var url: String { get }
}

public enum Endpoints {
    public enum Get: Endpoint {
        case getGames
        case getGameById(id: Int)
        case searchGames(query: String?)
        
        public var url: String {
            var path = ""
            switch self {
            case .getGames:
                path = "games"
            case .getGameById(let id):
                path = "games/\(id)"
            case .searchGames(let query):
                if let query {
                    path = "games?search=\(query)"
                } else {
                    path = "games"
                }
            }
            
            return API.baseURL + path
        }
    }
}
