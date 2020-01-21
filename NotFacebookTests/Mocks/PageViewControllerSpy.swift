//
//  PageViewControllerSpy.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import NotFacebook

class PageViewControllerSpy: PageViewController {
  
  var calledCheckAssertions = false
  var calledSetupDataSourceAndDelegate = false
  var calledSetFirstController = false
  var calledSetupButtons = false
  
  override func checkAssertions() {
    calledCheckAssertions = true
  }
  
  override func setupDataSourceAndDelegate() {
    calledSetupDataSourceAndDelegate = true
  }
  
  override func setFirstController() {
    calledSetFirstController = true
  }
  
  override func setupButtons() {
    calledSetupButtons = true
  }
}
