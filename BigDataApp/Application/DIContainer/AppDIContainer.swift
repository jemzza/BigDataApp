//
//  AppDIContainer.swift
//  BigDataApp
//
//  Created by Main on 21.04.2024.
//

import Foundation

final class AppDIContainer {
    
    lazy var networkService: any ItemsFetchable = {
        return FirebaseGateway()
    }()
    
    func makeItemsDIContainer() -> ItemsDIContainer {
        let dependencies = ItemsDIContainer.Dependencies(networkService: networkService)
        
        return ItemsDIContainer(dependencies: dependencies)
    }
}
