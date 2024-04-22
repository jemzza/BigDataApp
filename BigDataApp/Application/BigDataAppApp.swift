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
    
    var body: some Scene {
        
        WindowGroup {
            delegate.appFlowCoordinator?.start()
        }
    }
}
