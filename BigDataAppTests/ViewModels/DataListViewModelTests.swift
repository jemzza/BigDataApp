//
//  DataListViewModel.swift
//  BigDataAppTests
//
//  Created by Main on 18.04.2024.
//

import XCTest
@testable import BigDataApp
import Combine

final class MockItemsGateway: ItemsFetchable {
    
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

final class DataListViewModelTest: XCTestCase {
    
    var sut: DataListViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DataListViewModel(itemsGateway: JSONItemsGateway())
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testFilterNames_whenSearchTextAvengers() throws {
        let searchText = "Avengers"
        sut.searchName = searchText
        
        let searchItems = sut.filteredItems
        
        let isAllContainsAvengers = searchItems.map { $0.name }.allSatisfy { $0.contains(searchText) }
        XCTAssert(isAllContainsAvengers, "All items name contains \(searchText)")
    }
}
