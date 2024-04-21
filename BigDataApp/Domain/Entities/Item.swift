//
//  BigDataModel.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import Foundation

struct Item: ItemInterface {
    
    let id: Int
    let name: String
    let number: Double
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case number
    }
}

extension Item: Equatable {
    
    static func ==(_ lhs: Self, _ rhs: Self) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.number == rhs.number
    }
}

extension Item {
    
    static var testItems: [Item] {
        var items: [Self] = []
        
        for index in 1...400 {
            let item = Item(id: index, name: "Data \(index)", number: Double.random(in: 0...Double.greatestFiniteMagnitude))
            items.append(item)
        }
        
        return items
    }
}
