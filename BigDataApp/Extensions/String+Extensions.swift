//
//  String+Extensions.swift
//  BigDataApp
//
//  Created by Main on 22.04.2024.
//

import Foundation

extension String {
    
    func generateSequence() -> [String] {
        if count == 0 {
            return []
        }
        
        var sequence: [String] = []
        
        for index in 1...count {
            sequence.append(String(prefix(index)))
        }
        
        return sequence
    }
}
