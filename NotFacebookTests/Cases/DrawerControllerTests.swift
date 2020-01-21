//
//  DrawerControllerTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 20.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class DrawerControllerTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: DrawerController!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    sut = DrawerControllerSpy()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_viewDidLoad_callsCheckAssertions() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! DrawerControllerSpy).calledCheckAssertions)
  }
  
  func test_viewDidLoad_callsSetupLogoutButton() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! DrawerControllerSpy).calledSetupLogoutButton)
  }
  
  func test_viewDidLoad_callsSetupUserData() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! DrawerControllerSpy).calledSetupUserData)
  }
  
  func test_viewDidLoad_callsPrepareViews() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! DrawerControllerSpy).calledPrepareViews)
  }
  
  // MARK: - dismissController
  
  func test_dismissController_callsClose() {
    // when
    sut.dismissController(1)
    
    // then
    XCTAssertTrue((sut as! DrawerControllerSpy).calledClose)
  }
  
  // MARK: - initializeController
  
  
  func test_initializeController_setsNetworkingFacade() {
    // given
    sut = DrawerController.initializeController()
    
    // then
    XCTAssertNotNil(sut.networking)
  }
  
  func test_initializeController_setsImageClient() {
    // given
    sut = DrawerController.initializeController()
    
    // then
    XCTAssertNotNil(sut.imageClient)
  }
  
  // MARK: - prepareViews
  
  func test_prepareViews_setsIsOpenToFalse() {
    // given
    sut = DrawerController.initializeController()
    
    // when
    _ = sut.view
    
    // then
    XCTAssertFalse(sut.isOpen)
  }
  
  func test_prepareViews_setsTrailingConstraintConstant() {
    // given
    sut = DrawerController.initializeController()
    
    // when
    _ = sut.view
    
    // then
    XCTAssertEqual(sut.trailingConstraint.constant, -sut.drawerWidth)
  }
  
  func test_prepareViews_setsCoverViewAlphaToZero() {
    // given
    sut = DrawerController.initializeController()
    
    // when
    _ = sut.view
    
    // then
    XCTAssertEqual(sut.coverView.alpha, 0)
  }
  
  func test_prepareViews_setsProfileImageViewCornerRadius() {
    // given
    sut = DrawerController.initializeController()
    
    // when
    _ = sut.view
    
    // then
    XCTAssertEqual(sut.profilImageView.layer.cornerRadius, sut.profilImageView.frame.width / 2)
  }
  
  func test_prepareViews_setsPanGestureToHolderView() {
    // given
    sut = DrawerController.initializeController()
    
    // when
    _ = sut.view
    
    // then
    XCTAssertNotNil(sut.holderView.gestureRecognizers)
    XCTAssertEqual(sut.holderView.gestureRecognizers?.count, 1)
    XCTAssert(sut.holderView.gestureRecognizers?.first is UIPanGestureRecognizer)
  }
  
  // MARK: - open
  
  func test_open_setsIsOpenToTrue() {
    // given
    sut = DrawerController.initializeController()
    _ = sut.view
    
    // when
    sut.open()
    
    // then
    XCTAssertTrue(sut.isOpen)
  }
  
  func test_open_setsTrailingConstraintConstantToZero() {
    // given
    sut = DrawerController.initializeController()
    _ = sut.view
    
    // when
    sut.open()
    
    // then
    XCTAssertEqual(sut.trailingConstraint.constant, 0)
  }
  
  // MARK: - close
  
  func test_close_setsIsOpenToFalse() {
    // given
    sut = DrawerController.initializeController()
    _ = sut.view
    
    // when
    sut.close()
    
    // then
    XCTAssertFalse(sut.isOpen)
  }
  
  func test_close_setsCorrectTrailingConstraintConstant() {
    // given
    sut = DrawerController.initializeController()
    _ = sut.view
    
    // when
    sut.close()
    
    // then
    XCTAssertEqual(sut.trailingConstraint.constant, -sut.drawerWidth)
  }
}
