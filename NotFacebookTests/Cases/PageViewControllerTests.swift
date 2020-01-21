//
//  PageViewControllerTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 19.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class PageViewControllerTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: PageViewController!
  var photos: [Photo]!
  var index: Int!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    photos = [Photo(id: "test-id", createdDate: Date(), photoURLs: [])]
    index = 0
    sut = PageViewControllerSpy()
  }
  
  override func tearDown() {
    photos = nil
    index = nil
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Given
  
  func givenInitializedSut() {
    sut = PageViewController.initializeController(
      with: photos,
      startIndex: index)
  }
  
  // MARK: - Tests
  
  // MARK: - viewDidLoad
  
  func test_viewDidLoad_callsCheckAssertions() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PageViewControllerSpy).calledCheckAssertions)
  }
  
  func test_viewDidLoad_callsSetupDataSourceAndDelegate() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PageViewControllerSpy).calledSetupDataSourceAndDelegate)
  }
  
  func test_viewDidLoad_callsSetFirstController() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PageViewControllerSpy).calledSetFirstController)
  }
  
  func test_viewDidLoad_callsSetupButtons() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PageViewControllerSpy).calledSetupButtons)
  }
  
  // MARK: - initializeController
  
  func test_initializeController_setsPhotos() {
    // given
    givenInitializedSut()
    
    // then
    XCTAssertEqual(sut.photos.count, photos.count)
    XCTAssertEqual(sut.photos.first?.id, photos.first?.id)
  }
  
  func test_initializeController_setsIndex() {
    // given
    givenInitializedSut()
    
    // then
    XCTAssertEqual(sut.startIndex, index)
  }
  
  // MARK: - setFirstController
  
  func test_setFirstController_setsFirstController() {
    // given
    givenInitializedSut()
    
    // when
    _ = sut.view
    
    // then
    XCTAssertEqual(sut.viewControllers?.count, 1)
  }
  
}
