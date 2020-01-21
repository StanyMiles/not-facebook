//
//  PhotoListScreenSpy.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import NotFacebook

class PhotoListScreenSpy: PhotoListScreen {
  
  var calledCheckAssertions = false
  var calledSetupUI = false
  var calledLoadData = false
  
  override func checkAssertions() {
    calledCheckAssertions = true
  }
  
  override func setupUI() {
    calledSetupUI = true
  }
  
  override func loadData(limit: Int) {
    calledLoadData = true
  }
}
