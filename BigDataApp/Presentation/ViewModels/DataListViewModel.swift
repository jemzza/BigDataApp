//
//  ListViewModel.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import Combine
import Foundation

protocol DataListInputable: ObservableObject {
    
    var searchName: String { get set }
    var sortOrder: [KeyPathComparator<Item>] { get set }
    
    func viewWillAppear()
    func updateItems()
    func changeSortOrder(with itemKey: ItemKey)
    func clearAlerts()
}

protocol DataListOutputable: ObservableObject {
    
    var allItems: [Item] { get }
    var filteredItems: [Item] { get set }
    var isFailureAlertShowing: Bool { get set }
    var isSuccessAlertShowing: Bool { get set }
    var activeAlert: ActiveAlert? { get }
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
    
    @Published var isFailureAlertShowing = false
    @Published var isSuccessAlertShowing = false
    
    @Published var activeAlert: ActiveAlert? = nil {
        willSet {
            switch newValue {
                case .none:
                    isFailureAlertShowing = false
                    isSuccessAlertShowing = false
                case .error(_):
                    isFailureAlertShowing = true
                case .success(_):
                    isSuccessAlertShowing = true
            }
        }
    }
    
    private let itemsGateway: any ItemsFetchable
    
    private var currentPage = 0
    private let itemsPerPage = 10
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(itemsGateway: any ItemsFetchable) {
        self.itemsGateway = itemsGateway
        
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
    
    func viewWillAppear() {
        updateItems()
    }
    
    func updateItems() {
        Task(priority: .userInitiated) {
            do {
                try await itemsGateway.fetchItems()
            } catch let error {
                Task { @MainActor [weak self] in
                    self?.activeAlert = .error(error)
                }
            }
        }
    }
    
    func clearAlerts() {
        activeAlert = nil
    }
    
    func changeSortOrder(with itemKey: ItemKey) {
        var keyPathComparator = itemKey.keyPathComparator
        
        if keyPathComparator.keyPath == sortOrder[0].keyPath {
            let order: SortOrder = sortOrder[0].order == .forward ? .reverse : .forward
            keyPathComparator.order = order
        }
        
        sortOrder = [keyPathComparator]
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
