//
//  ListViewModel.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import Combine
import Foundation

typealias DataListViewModelInterface = DataListInputable & DataListOutputable

protocol DataListInputable: ObservableObject {
    
    var searchName: String { get set }
    var sortOrder: [KeyPathComparator<Item>] { get set }
    
    func viewWillAppear()
    func refreshItems()
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

final class DataListViewModel: DataListViewModelInterface {
    
    @Published var allItems: [Item] = [] {
        didSet {
            filteredItems = allItems
        }
    }
    
    @Published var filteredItems: [Item] = []
    
    @Published var sortOrder: [KeyPathComparator<Item>] = [KeyPathComparator(\Item.id)]
    @Published var searchName: String = "" {
        didSet {
            searchNameSubject.send(searchName)
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
    private var searchNameSubject = PassthroughSubject<String, Never>()
    
    private let itemsPerRequest = 25
    private let debounceDelay = 1.0
    
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
        
        searchNameSubject
            .debounce(for: .seconds(debounceDelay), scheduler: DispatchQueue.global())
            .share()
            .sink { [weak self] text in
                self?.itemsGateway.clearItems()
                self?.updateItems(with: text)
            }
            .store(in: &subscriptions)
    }
    
    func viewWillAppear() {
        updateItems()
    }
    
    func refreshItems() {
        updateItems(with: searchName)
    }
    
    private func updateItems(with text: String = "") {
        Task(priority: .userInitiated) {
            do {
                let filter: Item.CodingKeys
                
                if let comparator = sortOrder.last {
                    switch comparator {
                        case KeyPathComparator(\Item.id), KeyPathComparator(\Item.id, order: .reverse):
                            filter = .id
                        case KeyPathComparator(\Item.name), KeyPathComparator(\Item.name, order: .reverse):
                            filter = .name
                        case KeyPathComparator(\Item.number), KeyPathComparator(\Item.number, order: .reverse):
                            filter = .number
                        default:
                            filter = .id
                    }
                } else {
                    filter = .id
                }
                
                try await itemsGateway.fetchItems(
                    itemsPerRequest,
                    searchText: text,
                    filteredBy: filter,
                    order: sortOrder.last?.order ?? sortOrder[0].order
                )
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
        
        itemsGateway.clearItems()
        updateItems(with: searchName)
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
