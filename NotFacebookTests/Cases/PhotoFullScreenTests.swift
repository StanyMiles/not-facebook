//
//  PhotoFullScreenTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 19.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class PhotoFullScreenTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: PhotoFullScreen!
  var photo: Photo!
  var index: Int!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    photo = Photo(id: "test-id", createdDate: Date(), photoURLs: [])
    index = 666
    sut = PhotoFullScreenSpy()
  }
  
  override func tearDown() {
    sut = nil
    photo = nil
    index = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  // MARK: - viewDidLoad
  
  func test_viewDidLoad_callsCheckAssertions() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PhotoFullScreenSpy).calledCheckAssertions)
  }
  
  func test_viewDidLoad_callsLoadData() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PhotoFullScreenSpy).calledLoadData)
  }
  
  // MARK: - initializeController
  
  func test_initializeController_setsPhoto() {
    // given
    sut = PhotoFullScreen.initializeController(with: photo, index: index)
    
    // then
    XCTAssertEqual(sut.photo.id, photo.id)
  }
  
  func test_initializeController_setsIndex() {
    // given
    sut = PhotoFullScreen.initializeController(with: photo, index: index)
    
    // then
    XCTAssertEqual(sut.index, index)
  }
  
  func test_initializeController_setsImageClient() {
    // given
    sut = PhotoFullScreen.initializeController(with: photo, index: index)
    
    // then
    XCTAssertNotNil(sut.imageClient)
  }
  
}
