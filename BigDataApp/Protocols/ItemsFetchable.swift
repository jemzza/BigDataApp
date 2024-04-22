//
//  ItemsFetchable.swift
//  BigDataApp
//
//  Created by Main on 20.04.2024.
//

import Foundation
import Combine

protocol ItemsFetchable: ObservableObject {
    
    var itemsPublisher: Published<[Item]>.Publisher { get }
    
    func fetchItems(_ count: Int, searchText: String, filteredBy: Item.CodingKeys, order: SortOrder) async throws
    func clearItems()
}
