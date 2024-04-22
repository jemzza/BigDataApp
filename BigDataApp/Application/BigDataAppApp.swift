//
//  BigDataAppApp.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import SwiftUI

@main
struct BigDataAppApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject var viewModel = DataListViewModel(itemsGateway: FirebaseGateway())
    
    var body: some Scene {
        
        WindowGroup {
//            DataListView(viewModel: viewModel)
            delegate.appFlowCoordinator?.start()
        }
    }
}
