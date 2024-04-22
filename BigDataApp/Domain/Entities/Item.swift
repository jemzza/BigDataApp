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
    let searchKeywords: [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case number
        case searchKeywords
    }
    
    init(id: Int, name: String, number: Double) {
        self.id = id
        self.name = name
        self.number = number
        self.searchKeywords = name.generateSequence()
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.number, forKey: .number)
        try container.encodeIfPresent(self.searchKeywords, forKey: .searchKeywords)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.number = try container.decode(Double.self, forKey: .number)
        self.searchKeywords = name.generateSequence()
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
