//
//  UserDefault.swift
//  GCCommon
//
//  Created by Steven Lie on 13/12/24.
//

import Foundation

public enum UserDefault: String {
    case name
    case email
    
    public func load() -> Any? {
        UserDefaults.standard.object(forKey: self.rawValue)
    }
    
    public func save(value: Any?) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }
    
    public func delete() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}
