//
//  ActiveAlert.swift
//  BigDataApp
//
//  Created by Main on 20.04.2024.
//

import Foundation

enum ActiveAlert {
    
    case error(_ error: Error)
    case success(_ info: String)
    
    var id: Self {
        return self
    }
}
