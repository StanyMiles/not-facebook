//
//  NetworkingFacadeTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class NetworkingFacadeTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: NetworkingFacade!
  var networkingClientSpy: NetworkingClientSpy!
  var networkingFBClientSpy: NetworkingFBClientSpy!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    networkingClientSpy = NetworkingClientSpy()
    networkingFBClientSpy = NetworkingFBClientSpy()
    sut = NetworkingFacade(
      networkingClient: networkingClientSpy,
      networkingFBClient: networkingFBClientSpy)
  }
  
  override func tearDown() {
    sut = nil
    networkingClientSpy = nil
    networkingFBClientSpy = nil
    super.tearDown()
  }
  
  // MARK: - When
  
  func whenGetAlbums(useFBClient: Bool) {
    sut.getAlbums(limit: 0, after: nil, useFBClient: useFBClient) { _ in }
  }
  
  func whenGetPhotos(useFBClient: Bool) {
    sut.getPhotos(
      fromAlbumWithId: "",
      limit: 0,
      after: nil,
      useFBClient: useFBClient
    ) { _ in }
  }
  
  func whenGetUserData(useFBClient: Bool) {
    sut.getUserData(
      useFBClient: useFBClient
    ) { _ in }
  }
  
  // MARK: - Tests
  
  // MARK: - getAlbums
  
  func test_getAlbums_FBClientCallsGetAlbums() {
    // when
    whenGetAlbums(useFBClient: true)
    
    // then
    XCTAssertTrue(networkingFBClientSpy.calledGetAlbums)
  }
  
  func test_getAlbums_networkingClientCallsGetAlbums() {
    // when
    whenGetAlbums(useFBClient: false)
    
    // then
    XCTAssertTrue(networkingClientSpy.calledGetAlbums)
  }
  
  // MARK: - getPhotos
  
  func test_getPhotos_FBClientCallsGetAlbums() {
    // when
    whenGetPhotos(useFBClient: true)
    
    // then
    XCTAssertTrue(networkingFBClientSpy.calledGetPhotos)
  }
  
  func test_getPhotos_networkingClientCallsGetAlbums() {
    // when
    whenGetPhotos(useFBClient: false)
    
    // then
    XCTAssertTrue(networkingClientSpy.calledGetPhotos)
  }
  
  // MARK: - getUserData
  
  func test_getUserData_FBClientCallsGetAlbums() {
    // when
    whenGetUserData(useFBClient: true)
    
    // then
    XCTAssertTrue(networkingFBClientSpy.calledGetUserData)
  }
  
  func test_getUserData_networkingClientCallsGetAlbums() {
    // when
    whenGetUserData(useFBClient: false)
    
    // then
    XCTAssertTrue(networkingClientSpy.calledGetUserData)
  }
}
