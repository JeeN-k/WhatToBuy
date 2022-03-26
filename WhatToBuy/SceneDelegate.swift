//
//  SceneDelegate.swift
//  WhatToBuy
//
//  Created by Oleg Stepanov on 21.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let navVC = UINavigationController()
        let coordinator = MainCoordinator(navVC)
        window?.rootViewController = navVC
        window?.tintColor = .systemIndigo
        window?.makeKeyAndVisible()
        coordinator.start()
    }
}
