//
//  String+Extension.swift
//  GCCommon
//
//  Created by Steven Lie on 05/12/24.
//

import Foundation

extension String {
    func localized() -> String {
        return Bundle.module.localizedString(forKey: self, value: nil, table: nil)
    }
    
    public func getCleanedURL() -> URL? {
       guard self.isEmpty == false else {
           return nil
       }
       if let url = URL(string: self) {
           return url
       } else {
           if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let escapedURL = URL(string: urlEscapedString) {
               return escapedURL
           }
       }
       return nil
    }
}
