//
//  ItemInterface.swift
//  BigDataApp
//
//  Created by Main on 20.04.2024.
//

import Foundation

protocol ItemInterface: Codable, Identifiable {
    
    var id: Int { get }
    var name: String { get }
    var number: Double { get }
    var searchKeywords: [String]? { get }
}
