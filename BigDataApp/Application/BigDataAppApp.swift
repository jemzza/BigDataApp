//
//  BigDataAppApp.swift
//  BigDataApp
//
//  Created by Main on 18.04.2024.
//

import SwiftUI

@main
struct BigDataAppApp: App {
    @StateObject var dataListViewModel = DataListViewModel(itemsGateway: JSONItemsGateway())
    
    var body: some Scene {
        WindowGroup {
            DataListView(viewModel: dataListViewModel)
        }
    }
}
