//
//  UIButton+Ext.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

extension UIButton {
  
  static func makeBackButton(
    target: UIViewController,
    action: Selector
  ) -> UIButton {
    
    let image = UIImage(systemName: "xmark")
    
    let button = UIButton(type: .system)
    button.setImage(image, for: .normal)
    button.addTarget(
      target,
      action: action,
      for: .touchUpInside)
    button.tintColor = .white
    button.layer.shadowOffset = .zero
    button.layer.shadowRadius = 2
    button.layer.shadowOpacity = 0.8
    return button
  }
  
  static func makeArrowButton(
    direction: Direction,
    target: UIViewController,
    action: Selector
  ) -> UIButton {
    
    let image = direction == .left ?
      UIImage(systemName: "arrow.left.circle.fill") :
      UIImage(systemName: "arrow.right.circle.fill")
    
    let button = UIButton(type: .system)
    button.setImage(image, for: .normal)
    button.addTarget(
      target,
      action: action,
      for: .touchUpInside)
    button.tintColor = .white
    button.layer.shadowOffset = .zero
    button.layer.shadowRadius = 4
    button.layer.shadowOpacity = 0.7
    return button
  }
  
  enum Direction {
    case left, right
  }
}
