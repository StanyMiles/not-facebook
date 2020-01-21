//
//  LoginScreenTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 19.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
import FacebookLogin
@testable import NotFacebook

class LoginScreenTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: LoginScreen!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    sut = LoginScreenSpy()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_viewDidLoad_callsSetupUI() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! LoginScreenSpy).calledSetupUI)
  }
  
  func test_viewDidLoad_callsLoginIfHasToken() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! LoginScreenSpy).calledLoginIfHasToken)
  }
  
}
