//
//  UserDefault.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import Foundation

enum UserDefault: String {
    case name
    case email
    
    func load() -> Any? {
        UserDefaults.standard.object(forKey: self.rawValue)
    }
    
    func save(value: Any?) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }
    
    func delete() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}
