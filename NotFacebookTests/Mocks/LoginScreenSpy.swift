//
//  LoginScreenSpy.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import NotFacebook

class LoginScreenSpy: LoginScreen {
  
  var calledLoginIfHasToken = false
  var calledSetupUI = false
  var calledPresentAlbumListScreen = false
  
  override func loginIfHasToken(animated: Bool) {
    calledLoginIfHasToken = true
  }
  
  override func setupUI() {
    calledSetupUI = true
  }
  
  override func presentAlbumsListScreen(animated: Bool) {
    calledPresentAlbumListScreen = true
  }
}
