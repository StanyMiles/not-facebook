//
//  PhotoListScreenTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 19.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class PhotoListScreenTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: PhotoListScreen!
  var album: PhotoAlbum!
  var networkingSpy: NetworkingClientSpy!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    sut = PhotoListScreenSpy()
  }
  
  override func tearDown() {
    sut = nil
    album = nil
    networkingSpy = nil
    super.tearDown()
  }
  
  // MARK: - Given
  
  func givenAlbum() {
    let pictureData = PhotoAlbum.PictureData(url: "")
    let picture = PhotoAlbum.CoverPicture(data: pictureData)
    album = PhotoAlbum(id: "", name: "Album", createdDate: Date(), picture: picture)
  }
  
  func givenInitializedSUTWithNetworkingSpy() -> PhotoListScreen {
    networkingSpy = NetworkingClientSpy()
    let facade = NetworkingFacade(
      networkingClient: networkingSpy)
    let sut = PhotoListScreen.initializeController(
      with: album,
      networking: facade)
    return sut
  }
  
  // MARK: - Tests
  
  // MARK: - viewDidLoad
  
  func test_viewDidLoad_callsCheckAssertions() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PhotoListScreenSpy).calledCheckAssertions)
  }
  
  func test_viewDidLoad_callsSetupUI() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PhotoListScreenSpy).calledSetupUI)
  }
  
  func test_viewDidLoad_callsLoadData() {
    // when
    sut.viewDidLoad()
    
    // then
    XCTAssertTrue((sut as! PhotoListScreenSpy).calledLoadData)
  }
  
  // MARK: - initializeController
  
  func test_initializeController_setsPhoto() {
    // given
    givenAlbum()
    sut = PhotoListScreen.initializeController(with: album)
    
    // then
    XCTAssertEqual(sut.album.name, album.name)
  }
  
  func test_initializeController_setsNetworkingFacade() {
    // given
    givenAlbum()
    sut = PhotoListScreen.initializeController(with: album)
    
    // then
    XCTAssertNotNil(sut.networking)
  }
  
  // MARK: - setupUI
  
  func test_setupUI_setsTitle() {
    // given
    givenAlbum()
    sut = givenInitializedSUTWithNetworkingSpy()
    let _ = UINavigationController(rootViewController: sut)

    // when
    _ = sut.view

    // then
    XCTAssertEqual(sut.navigationItem.title, album.name)
  }
}
