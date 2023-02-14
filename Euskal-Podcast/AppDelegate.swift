//
//  AppDelegate.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 01/05/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var tabbarController: TabBar?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Start reciving remote control events so the users can control the music from the lock screen.
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        // Creates the Tabbar Controller.
        tabbarController = TabBar()
        
        // Create the window and add the Main Coordinator's navigation controller as the root view.
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        if let window = window {
            window.rootViewController = tabbarController
            window.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available (iOS 13, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available (iOS 13, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

