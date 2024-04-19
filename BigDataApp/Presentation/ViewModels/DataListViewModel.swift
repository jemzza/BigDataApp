//
//  ListViewModel.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import Combine
import Foundation

protocol DataListInputable: ObservableObject {
    
    var filteredItems: [Item] { get set }
    var searchName: String { get set }
    var sortOrder: [KeyPathComparator<Item>] { get set }
}

protocol DataListOutputable: ObservableObject {
    
    var allItems: [Item] { get }
    var error: Error? { get }
}

final class DataListViewModel: DataListOutputable, DataListInputable {
    
    @Published var allItems: [Item] = [] {
        didSet {
            filteredItems = allItems
        }
    }
    
    @Published var filteredItems: [Item] = []
    
    @Published var sortOrder: [KeyPathComparator<Item>] = [KeyPathComparator(\Item.name)]
    @Published var searchName: String = "" {
        willSet {
            filterItemsByName(with: newValue)
        }
    }
    
    @Published var error: Error? = nil
    
    private let itemsGateway: any ItemsFetchable
    
    private var currentPage = 0
    private let itemsPerPage = 10
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(itemsGateway: any ItemsFetchable) {
        self.itemsGateway = itemsGateway
        
        Task {
            do {
                try await itemsGateway.fetchItems()
            } catch let error {
                Task { @MainActor [weak self] in
                    self?.error = error
                }
            }
        }
        
        itemsGateway.itemsPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] in self?.allItems = $0 })
            .store(in: &subscriptions)
        
        $sortOrder
            .sink { [weak self] newOrder in
                self?.filteredItems.sort(using: newOrder)
            }
            .store(in: &subscriptions)
    }
    
    private func filterItemsByName(with text: String) {
        guard !text.isEmpty else {
            filteredItems = allItems
            
            return
        }
        
        filteredItems = allItems.filter { item in
            guard item.name.localizedStandardContains(text) else {
                return false
            }
            
            return true
        }
    }
}
