//
//  Query+Extensions.swift
//  BigDataApp
//
//  Created by Main on 20.04.2024.
//

import FirebaseFirestore

extension Query {
    
    func getDocuments<T: Decodable>(_ type: T.Type) async throws -> [T] {
        return try await getDocuments().documents.compactMap { try $0.data(as: T.self) }
    }
    
    func getDocuments<T: Decodable>(_ type: T.Type) async throws -> (DocumentSnapshot?, [T]) {
        let snapshot = try await getDocuments()
        return (snapshot.documents.last, try snapshot.documents.compactMap { try $0.data(as: T.self) })
    }
}
