//
//  SceneDelegate.swift
//  Euskal-Podcast
//
//  Created by Aitor Zubizarreta Perez on 01/05/2021.
//

import UIKit

@available (iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var tabbarController: TabBar?
    
    var playerBarWindow: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Creates the Tabbar Controller.
        tabbarController = TabBar()
        
        // Create the window and add the Main Coordinator's navigation controller as the root view.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = tabbarController
        window?.makeKeyAndVisible()
        
        // Player Bar ViewController.
//        playerBarWindow = UIWindow(windowScene: windowScene)
//        playerBarWindow?.frame = CGRect(x: 0,
//                                        y: UIScreen.main.bounds.height - 130,
//                                        width: UIScreen.main.bounds.size.width,
//                                        height: 130)
//        playerBarWindow?.rootViewController = PlayerBarViewController()
//        playerBarWindow?.isHidden = false
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

