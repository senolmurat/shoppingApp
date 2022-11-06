//
//  AppDelegate.swift
//  shoppingApp
//
//  Created by Murat ŞENOL on 31.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupFirebase()
        setupWindow()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    
        return true
    }
    
    private func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = LaunchViewController()
        window.rootViewController = viewController //navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        _ = Firestore.firestore()
    }

}

