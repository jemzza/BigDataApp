//
//  Encodable+Extensions.swift
//  BigDataApp
//
//  Created by Main on 20.04.2024.
//

import Foundation

public extension Encodable {
    
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        
        guard
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else {
            throw NSError()
        }
        
        return dictionary
    }
}
