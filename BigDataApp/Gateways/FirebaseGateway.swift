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
        
//        Task(priority: .userInitiated) {
//            await importDataToDatabase(fileName: Constants.topIncomeFilms)
//        }
    }
    
    static func setup() {
        FirebaseApp.configure()
    }
    
    func fetchItems() async throws {
        while FirebaseApp.app() == nil {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        
        let (snapshot, fetchedTtems) = try await getItemsByID(25, snapshot: lastSnapshot)
        items += fetchedTtems
        lastSnapshot = snapshot
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
    
    private func getItemsByID(_ count: Int, snapshot: DocumentSnapshot?) async throws -> (DocumentSnapshot?, [Item]) {
        if let snapshot = snapshot {
            let (snapshot, items) = try await moviesCollection
                .order(by: Item.CodingKeys.id.rawValue)
                .limit(to: count)
                .start(atDocument: snapshot)
                .getDocuments(Item.self)
            
            return (snapshot, items)
        } else {
            return try await moviesCollection
                .order(by: Item.CodingKeys.id.rawValue)
                .limit(to: count)
                .getDocuments(Item.self)
        }
    }
}
