//
//  PhotoFullScreenSpy.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import NotFacebook

class PhotoFullScreenSpy: PhotoFullScreen {
  
  var calledCheckAssertions = false
  var calledLoadData = false
  
  override func checkAssertions() {
    calledCheckAssertions = true
  }
  
  override func loadData() {
    calledLoadData = true
  }
}
