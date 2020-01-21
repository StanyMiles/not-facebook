//
//  UIViewController+Ext.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 19.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

@nonobjc extension UIViewController {
  
  func add(childController: UIViewController, frame: CGRect? = nil) {
    
    addChild(childController)
    
    if let frame = frame {
      childController.view.frame = frame
    }
    view.addSubview(childController.view)
    
    childController.didMove(toParent: self)
  }
  
  func removeFromParentController() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .actionSheet)
    
    let ok = UIAlertAction(title: "OK", style: .default)
    alert.addAction(ok)
    
    present(alert, animated: true)
  }
}
