//
//  SceneDelegate.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 17.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import FacebookLogin

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var navigationDelegate: NavigationDelegate!

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    
    guard let _ = (scene as? UIWindowScene) else { return }
    guard let navController = window?.rootViewController as? UINavigationController else { return }
    
    navigationDelegate = NavigationDelegate()
    navController.delegate = navigationDelegate
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    guard AccessToken.current == nil else { return }
    let navController = window?.rootViewController as? UINavigationController
    navController?.popToRootViewController(animated: false)
  }

}
