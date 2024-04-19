//
//  AppError.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import Foundation

enum AppError: Error, LocalizedError, Identifiable {
    
    var id: String { localizedDescription }
    
    case unknown
    case custom(info: String)
    case other(Error)
    
    var errorDescription: String? {
        
        switch self {
            case .unknown:
                return "Unknown"
            case .custom(let info):
                return info
            case .other(let error):
                return "Other error \(error.localizedDescription)"
        }
    }
}
