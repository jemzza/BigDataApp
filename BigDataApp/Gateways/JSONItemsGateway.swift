//
//  ItemsGateway.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import Foundation

final class JSONItemsGateway: ItemsFetchable {
    
    var itemsPublisher: Published<[Item]>.Publisher { $items }
    @Published private var items: [Item] = []
    
    func fetchItems() async throws {
        if let fileURL = Bundle.main.url(forResource: "MockItems", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: fileURL)
                let items = try JSONDecoder().decode([Item].self, from: jsonData)
                
                self.items = items
            } catch let error {
                print("Error when decoding: \(error.localizedDescription)")
                throw AppError.custom(info: "Error when decoding: \(error.localizedDescription)")
            }
        } else {
            throw AppError.custom(info: "JSON file not found")
        }
    }
}
