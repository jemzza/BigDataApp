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
                return R.string.errors.unknown()
            case .custom(let info):
                return info
            case .other(let error):
                return R.string.errors.other("\(error.localizedDescription)")
        }
    }
}
