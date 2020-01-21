//
//  DrawerController.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 19.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit
import FacebookLogin

class DrawerController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profilImageView: UIImageView!
  @IBOutlet weak var holderView: UIView!
  @IBOutlet weak var coverView: UIView!
  @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
  
  // MARK: - Properties
  
  var networking: NetworkingFacade!
  var imageClient: ImageClient!
  
  var isOpen = true
  
  var drawerWidth: CGFloat {
    view.frame.width * 0.7
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkAssertions()
    setupLogoutButton()
    setupUserData()
    prepareViews()
  }
  
  // MARK: - IBActions
  
  @IBAction func dismissController(_ sender: Any) {
    close()
  }
  
  // MARK: - Funcs
  
  class func initializeController(
    networking: NetworkingFacade = NetworkingFacade(),
    imageClient: ImageClient = .shared
  ) -> DrawerController {
    
    let controller = DrawerController.instantiate()
    controller.networking = networking
    controller.imageClient = imageClient
    return controller
  }
  
  func prepareViews() {
    isOpen = false
    trailingConstraint.constant = -drawerWidth
    view.layoutIfNeeded()
    coverView.alpha = 0
    profilImageView.layer.cornerRadius = profilImageView.frame.width / 2
    
    let panGesture = UIPanGestureRecognizer(
      target: self,
      action: #selector(handlePan))
    holderView.addGestureRecognizer(panGesture)
  }
  
  func open() {
    isOpen = true
    trailingConstraint.constant = 0
    performAnimations()
  }
  
  func close(completion: ((Bool) -> Void)? = nil) {
    isOpen = false
    trailingConstraint.constant = -drawerWidth
    performAnimations(completion: completion)
  }
  
  private func performAnimations(completion: ((Bool) -> Void)? = nil) {
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      usingSpringWithDamping: 1,
      initialSpringVelocity: 1,
      options: .curveEaseOut,
      animations: {
        self.view.layoutIfNeeded()
        self.coverView.alpha = self.isOpen ? 1 : 0
        
    }) { success in
      if !self.isOpen {
        self.removeFromParentController()
      }
      completion?(success)
    }
  }
  
  func setupLogoutButton() {
    let loginButton = FBLoginButton(
      permissions: [.publicProfile, .userPhotos])
    loginButton.delegate = self
    
    holderView.addSubview(loginButton)
    loginButton.anchor(
      leading: holderView.leadingAnchor,
      bottom: holderView.bottomAnchor,
      trailing: holderView.trailingAnchor,
      padding: .init(top: 0, left: 40, bottom: 50, right: 40))
  }
  
  @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: holderView)
    var x = translation.x
    x = min(drawerWidth, x)
    x = max(0, x)
    x = -x
    
    trailingConstraint.constant = x
    
    let alpha = (x / drawerWidth) + 1
    coverView.alpha = alpha
    
    if gesture.state == .ended {
      handleEnded(gesture)
    }
  }
  
  private func handleEnded(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: holderView)
    let velocity = gesture.velocity(in: holderView)
    let velocityThreshold: CGFloat = 500
    
    if velocity.x > velocityThreshold {
      close()
    } else if abs(translation.x) < drawerWidth / 2 {
      open()
    } else if translation.x > 0 {
      close()
    }
  }
  
  func setupUserData() {
    nameLabel.text = nil
    
    _ = networking.getUserData { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let userData):
        
        self.nameLabel.text = """
        Hello
        \(userData.firstName)!
        """
        
        guard let url = userData.profileImageURL else { return }
        self.imageClient.setImage(
          on: self.profilImageView,
          fromURL: url)
        
      case .failure(let error):
        #if DEBUG
        print("Failed to get userData:", error)
        #endif
      }
    }
  }
  
  func checkAssertions() {
    assert(networking != nil)
    assert(imageClient != nil)
  }
  
}

// MARK: - Storyboarded

extension DrawerController: Storyboarded {}

// MARK: - LoginButtonDelegate

extension DrawerController: LoginButtonDelegate {
  
  func loginButton(
    _ loginButton: FBLoginButton,
    didCompleteWith result: LoginManagerLoginResult?,
    error: Error?
  ) {
    // NOP
  }
  
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    close() { _ in
      let navController = UIApplication
        .shared
        .windows
        .first?
        .rootViewController as? UINavigationController

      navController?.popToRootViewController(animated: true)
    }
  }
}
