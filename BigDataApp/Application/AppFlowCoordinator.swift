//
//  AppFlowCoordinator.swift
//  BigDataApp
//
//  Created by Main on 21.04.2024.
//

import SwiftUI

final class AppFlowCoordinator {
    
    private let appDIContainer: AppDIContainer
    
    init(
        appDIContainer: AppDIContainer
    ) {
        self.appDIContainer = appDIContainer
    }
    
    func start() -> AnyView {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let itemsDIContainer = appDIContainer.makeItemsDIContainer()
        let flow = itemsDIContainer.makeItemsFlowCoordinator()
        return flow.start()
    }
}
