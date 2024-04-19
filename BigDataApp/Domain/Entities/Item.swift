//
//  BigDataModel.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import Foundation

protocol ItemInterface: Codable, Identifiable {
    
    var id: Int { get }
    var name: String { get }
    var number: Double { get }
}

struct Item: ItemInterface {
    
    let id: Int
    let name: String
    let number: Double
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
