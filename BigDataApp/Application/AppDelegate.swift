//
//  AppDelegate.swift
//  BigDataApp
//
//  Created by Main on 20.04.2024.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseGateway.setup()
        
        appFlowCoordinator = AppFlowCoordinator(appDIContainer: appDIContainer)
        
        return true
    }
}
