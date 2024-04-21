//
//  ItemsFlowCoorinator.swift
//  BigDataApp
//
//  Created by Main on 21.04.2024.
//

import SwiftUI

final class ItemsFlowCoordinator {
    
    private let dependencies: ItemsFlowCoordinatorDependies
    
    init(dependencies: ItemsFlowCoordinatorDependies) {
        self.dependencies = dependencies
    }
    
    func start() -> AnyView {
        dependencies.makeDataListView()
    }
}
