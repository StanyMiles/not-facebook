//
//  DrawerControllerSpy.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import NotFacebook

class DrawerControllerSpy: DrawerController {
  
  var calledCheckAssertions = false
  var calledSetupLogoutButton = false
  var calledSetupUserData = false
  var calledPrepareViews = false
  var calledClose = false
  
  override func checkAssertions() {
    calledCheckAssertions = true
  }
  
  override func setupLogoutButton() {
    calledSetupLogoutButton = true
  }
  
  override func setupUserData() {
    calledSetupUserData = true
  }
  
  override func prepareViews() {
    calledPrepareViews = true
  }
  
  override func close(completion: ((Bool) -> Void)? = nil) {
    calledClose = true
  }
}
