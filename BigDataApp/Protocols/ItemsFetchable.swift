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
    
    func fetchItems() async throws
}
