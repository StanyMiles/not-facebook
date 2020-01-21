//
//  NavigationDelegate.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class NavigationDelegate: NSObject { }

// MARK: - UINavigationControllerDelegate

extension NavigationDelegate: UINavigationControllerDelegate {
  
  /// Hides navigationBar only when LoginScreen is presented
  func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool
  ) {
    
    let isHidden = viewController is LoginScreen
    navigationController.navigationBar.isHidden = isHidden
  }
}
