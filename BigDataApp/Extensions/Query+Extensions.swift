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
    
    /*
    func getDocuments<T: Decodable>(_ type: T.Type) async throws -> (QueryDocumentSnapshot?, [T]) {
//        let snapshot = try await getDocuments(source: .default)
//        return (snapshot.documents.last, try snapshot.documents.compactMap { try $0.data(as: T.self) })

        
        try await withCheckedThrowingContinuation { continuation in
            getDocuments { querySnapshot, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    continuation.resume(returning: (nil, []))
                    return
                }
                
                let items = documents.compactMap { try? $0.data(as: T.self) }
                print(items)
                
                continuation.resume(returning: (documents.last, items))
            }
        }
    }
    */
}
