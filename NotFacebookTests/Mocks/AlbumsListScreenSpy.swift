//
//  AlbumsListScreenSpy.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import NotFacebook

class AlbumsListScreenSpy: AlbumsListScreen {
  
  var calledLoadData = false
  var calledSetupUI = false
  var calledCheckAssertions = false
  
  override func loadData(limit: Int) {
    calledLoadData = true
  }
  
  override func setupUI() {
    calledSetupUI = true
  }
  
  override func checkAssertions() {
    calledCheckAssertions = true
  }
}
