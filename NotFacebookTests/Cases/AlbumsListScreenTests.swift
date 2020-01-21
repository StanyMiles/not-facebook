//
//  AlbumsListScreenTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 19.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class AlbumsListScreenTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: AlbumsListScreen!
  var networkingSpy: NetworkingClientSpy!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    sut = AlbumsListScreenSpy()
  }
  
  override func tearDown() {
    sut = nil
    networkingSpy = nil
    super.tearDown()
  }
  
  // MARK: - Given
  
  func givenInitializedSUTWithNetworkingSpy() -> AlbumsListScreen {
    networkingSpy = NetworkingClientSpy()
    let facade = NetworkingFacade(
      networkingClient: networkingSpy)
    let sut = AlbumsListScreen.initializeController(
      networking: facade)
    return sut
  }
  
  // MARK: - Tests
  
  // MARK: - viewDidLoad
  
  func test_viewDidLoad_callsCheckAssertions() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! AlbumsListScreenSpy).calledCheckAssertions)
  }
  
  func test_viewDidLoad_callsSetupUI() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! AlbumsListScreenSpy).calledSetupUI)
  }
  
  func test_viewDidLoad_callsLoadData() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! AlbumsListScreenSpy).calledLoadData)
  }
  
  // MARK: - setupUI
  
  func test_setupUI_setsTitle() {
    sut = givenInitializedSUTWithNetworkingSpy()
    let _ = UINavigationController(rootViewController: sut)
    
    // when
    sut.setupUI()

    // then
    XCTAssertEqual(sut.navigationItem.title, "My Albums")
  }
  
  // MARK: - initializeController
  
  func test_initializeController_setsNetworkingFacade() {
    // given
    sut = givenInitializedSUTWithNetworkingSpy()
    
    // then
    XCTAssertNotNil(sut.networking)
  }
  
}
