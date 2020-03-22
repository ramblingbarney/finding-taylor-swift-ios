//
//  SceneDelegate.swift
//  FindingTaylorSwift
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }

        let defaults = UserDefaults.standard

        let seenHelpInformation = defaults.bool(forKey: SeenHelpInformation.seenHelp)

        if let tabBarController = self.window!.rootViewController as? UITabBarController {

            // Set the focus if the User has previously opened the app with focus on Information View Controller
            if seenHelpInformation {
                tabBarController.selectedIndex = 0
            } else {
                tabBarController.selectedIndex = 1
            }
        }

    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
