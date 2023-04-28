//
//  SceneDelegate.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/19.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windoScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windoScene)
        window.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
        
        let hostingViewController = UIHostingController(rootView: ContentView())
        
        let viewController = ViewController()
        
        let favoriteViewController = UINavigationController(rootViewController: viewController)
        
        tabBarController.setViewControllers([hostingViewController,favoriteViewController], animated: true)
        
        viewController.tabBarItem = UITabBarItem(title: "UIKit-Favorite", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        hostingViewController.tabBarItem = UITabBarItem(title: "SwiftUI", image: UIImage(systemName: "swift"), selectedImage: UIImage(systemName: "swift"))
        
        tabBarController.tabBar.tintColor = .orange
        tabBarController.tabBar.unselectedItemTintColor = .gray
        tabBarController.tabBar.backgroundColor = .systemGray
        
        window.rootViewController = tabBarController
        
        self.window = window
    }
}

