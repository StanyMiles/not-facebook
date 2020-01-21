//
//  UIView+Ext.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

//MARK:- Autolayout

extension UIView {
  
  func anchor(
    top: NSLayoutYAxisAnchor? = nil,
    leading: NSLayoutXAxisAnchor? = nil,
    bottom: NSLayoutYAxisAnchor? = nil,
    trailing: NSLayoutXAxisAnchor? = nil,
    centerX: NSLayoutXAxisAnchor? = nil,
    centerY: NSLayoutYAxisAnchor? = nil,
    padding: UIEdgeInsets = .zero,
    size: CGSize = .zero
  ) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      topAnchor.constraint(
        equalTo: top,
        constant: padding.top).isActive = true
    }
    
    if let leading = leading {
      leadingAnchor.constraint(
        equalTo: leading,
        constant: padding.left).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(
        equalTo: bottom,
        constant: -padding.bottom).isActive = true
    }
    
    if let trailing = trailing {
      trailingAnchor.constraint(
        equalTo: trailing,
        constant: -padding.right).isActive = true
    }
    
    if let xAnchor = centerX {
      centerXAnchor.constraint(
        equalTo: xAnchor).isActive = true
    }
    
    if let yAnchor = centerY {
      centerYAnchor.constraint(
        equalTo: yAnchor).isActive = true
    }
    
    if size.width != 0 {
      widthAnchor.constraint(
        equalToConstant: size.width).isActive = true
    }
    
    if size.height != 0 {
      heightAnchor.constraint(
        equalToConstant: size.height).isActive = true
    }
    
  }
  
  func fillSuperview(padding: UIEdgeInsets = .zero) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let superviewTopAnchor = superview?.topAnchor {
      topAnchor.constraint(
        equalTo: superviewTopAnchor,
        constant: padding.top).isActive = true
    }
    
    if let superviewBottomAnchor = superview?.bottomAnchor {
      bottomAnchor.constraint(
        equalTo: superviewBottomAnchor,
        constant: -padding.bottom).isActive = true
    }
    
    if let superviewLeadingAnchor = superview?.leadingAnchor {
      leadingAnchor.constraint(
        equalTo: superviewLeadingAnchor,
        constant: padding.left).isActive = true
    }
    
    if let superviewTrailingAnchor = superview?.trailingAnchor {
      trailingAnchor.constraint(
        equalTo: superviewTrailingAnchor,
        constant: -padding.right).isActive = true
    }
  }
  
}
