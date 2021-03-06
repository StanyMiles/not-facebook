//
//  Storyboarded.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 17.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

protocol Storyboarded {
  static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
  
  static func instantiate() -> Self {
    
    let fullName = NSStringFromClass(self)
    let className = fullName.components(separatedBy: ".")[1]
    let storyboard = UIStoryboard(name: "Main", bundle: .main)
    
    return storyboard.instantiateViewController(withIdentifier: className) as! Self
  }
}
