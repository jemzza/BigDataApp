//
//  FirebaseGateway.swift
//  BigDataApp
//
//  Created by Main on 20.04.2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class FirebaseGateway: ItemsFetchable {
    
    private enum Constants {
        
        static let topIncomeFilms = "TopIncomeFilms"
        static let json = "json"
        static let moviesCollection = "movies"
    }
    
    var itemsPublisher: Published<[Item]>.Publisher { $items }
    @Published private var items: [Item] = []
    
    private var database: Firestore!
    private var lastSnapshot: DocumentSnapshot?
    
    private var moviesCollection: CollectionReference {
        database.collection(Constants.moviesCollection)
    }
    
    init() {
        database = Firestore.firestore()
    }
    
    static func setup() {
        FirebaseApp.configure()
    }
    
    func fetchItems(_ count: Int, searchText: String, filteredBy: Item.CodingKeys, order: SortOrder) async throws {
        while FirebaseApp.app() == nil {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        
        let (snapshot, fetchedItems) = try await getItems(
            count,
            searchText: searchText,
            filteredBy: filteredBy.rawValue,
            order: order,
            snapshot: lastSnapshot
        )
        
        items.append(contentsOf: items.isEmpty ? fetchedItems[0...] : fetchedItems[1...])
        
        lastSnapshot = snapshot
    }
    
    func clearItems() {
        items.removeAll()
        lastSnapshot = nil
    }
    
    private func importDataToDatabase(fileName file: String) async {
        do {
            guard let fileURL = Bundle.main.url(forResource: file, withExtension: Constants.json) else {
                throw AppError.custom(info: "JSON file not found")
            }
            
            let jsonData = try Data(contentsOf: fileURL)
            let items = try JSONDecoder().decode([Item].self, from: jsonData)
            
            for item in items {
                try await database.collection(Constants.moviesCollection).addDocument(data: item.toDictionary())
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func getItems(
        _ count: Int,
        searchText: String,
        filteredBy: String = Item.CodingKeys.id.rawValue,
        order: SortOrder,
        snapshot: DocumentSnapshot?
    ) async throws -> (DocumentSnapshot?, [Item]) {
        var query: Query
        
        if searchText.isEmpty {
            query = getItemsQuery()
        } else {
            query = getItemsSearchQuery(searchText)
        }
        
        if let snapshot = snapshot {
            let (snapshot, items) = try await query
                .order(by: filteredBy, descending: order == .reverse)
                .limit(to: count)
                .start(atDocument: snapshot)
                .getDocuments(Item.self)
            
            return (snapshot, items)
        } else {
            return try await query
                .order(by: filteredBy, descending: order == .reverse)
                .limit(to: count)
                .getDocuments(Item.self)
        }
    }
    
    private func getItemsSearchQuery(_ text: String) -> Query {
        return moviesCollection
            .whereField("name", isGreaterThanOrEqualTo: text)
            .whereField("name", isLessThanOrEqualTo: text + "\u{F7FF}")
    }
    
    private func getItemsQuery() -> Query {
        return moviesCollection
    }
}
