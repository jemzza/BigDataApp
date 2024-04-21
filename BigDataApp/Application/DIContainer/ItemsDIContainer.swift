//
//  ItemsDIContainer.swift
//  BigDataApp
//
//  Created by Main on 21.04.2024.
//

import SwiftUI

protocol ItemsFlowCoordinatorDependies {
    
    @ViewBuilder func makeDataListView() -> AnyView
    func makeDataListViewModel() -> DataListViewModel
}

final class ItemsDIContainer: ItemsFlowCoordinatorDependies {
    struct Dependencies {
        let networkService: any ItemsFetchable
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    @ViewBuilder func makeDataListView() -> AnyView {
        AnyView(
            DataListView(viewModel: makeDataListViewModel())
        )
    }
    
    func makeDataListViewModel() -> DataListViewModel {
        DataListViewModel(itemsGateway: dependencies.networkService)
    }
    
    func makeItemsFlowCoordinator() -> ItemsFlowCoordinator {
        return ItemsFlowCoordinator(
            dependencies: self
        )
    }
}
