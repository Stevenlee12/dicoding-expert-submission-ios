//
//  String+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import UIKit

extension String {
///  A URI is represented as a sequence of characters, not as a sequence of octets.
///  That is because URI might be "transported" by means that are not through a computer network, e.g.,
///  printed on paper, read over the radio, etc.

///  For original character sequences that contain non-ASCII characters, however, the situation is more difficult.
///  Internet protocols that transmit octet sequences intended to represent character sequences are expected to provide some way of
///  identifying the charset used, if there might be more than one [RFC2277].
///  However, there is currently no provision within the generic URI syntax to accomplish this identification.
///  An individual URI scheme may require a single charset, define a default charset, or provide a way to indicate the charset used.
///
///  In the IOS SDK we have the following:

///  User: URLUserAllowedCharacterSet
///  Password: URLPasswordAllowedCharacterSet
///  Host: URLHostAllowedCharacterSet
///  Path: URLPathAllowedCharacterSet
///  Fragment: URLFragmentAllowedCharacterSet
///  Query: URLQueryAllowedCharacterSet
///  You can use addingPercentEncoding(withAllowedCharacters:) to encode a string correctly.

    func getCleanedURL() -> URL? {
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
