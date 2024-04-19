//
//  ItemKey.swift
//  BigDataApp
//
//  Created by Main on 19.04.2024.
//

import Foundation

enum ItemKey: CaseIterable, Identifiable {
    
    var id: String { description }
    
    case id
    case name
    case number
    
    var keyPathComparator: KeyPathComparator<Item> {
        switch self {
            case .id:
                return KeyPathComparator(\Item.id)
            case .name:
                return KeyPathComparator(\Item.name)
            case .number:
                return KeyPathComparator(\Item.number)
        }
    }
    
    var description: String {
        switch self {
            case .id:
                return "ID"
            case .name:
                return "Name"
            case .number:
                return "Number"
                
        }
    }
}
