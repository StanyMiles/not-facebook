//
//  LoginScreen.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 17.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginScreen: UIViewController {
  
  // MARK: - Properties
  
  var accessToken = AccessToken.current
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    loginIfHasToken(animated: false)
  }
  
  // MARK: - Funcs
  
  func loginIfHasToken(animated: Bool) {
    guard accessToken != nil else { return }
    presentAlbumsListScreen(animated: animated)
  }
  
  func setupUI() {
    let loginButton = FBLoginButton(
      permissions: [.publicProfile, .userPhotos])
    loginButton.delegate = self
    loginButton.center = view.center
    view.addSubview(loginButton)
  }
  
  func presentAlbumsListScreen(animated: Bool) {
    let vc = AlbumsListScreen.initializeController()
    navigationController?.pushViewController(vc, animated: animated)
  }
  
}

// MARK: - LoginButtonDelegate

extension LoginScreen: LoginButtonDelegate {
  
  func loginButton(
    _ loginButton: FBLoginButton,
    didCompleteWith result: LoginManagerLoginResult?,
    error: Error?
  ) {
  
    guard ((result?.token) != nil) && error == nil else {
      return
    }
    
    presentAlbumsListScreen(animated: true)
  }
  
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    // NOP
  }
}
