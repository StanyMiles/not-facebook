//
//  PhotoTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 20.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class PhotoTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: Photo!
  var createdDate: Date!
  var urls: [PhotoURL]!
  var smallestURL: PhotoURL!
  var largestURL: PhotoURL!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    createdDate = Date()
    smallestURL = PhotoURL(width: 100, height: 100, source: "https://smallest-url.com")
    largestURL = PhotoURL(width: 200, height: 200, source: "https://largest-url.com")
    urls = [smallestURL, largestURL]
    sut = Photo(
      id: "",
      createdDate: createdDate,
      photoURLs: urls)
  }
  
  override func tearDown() {
    createdDate = nil
    smallestURL = nil
    largestURL = nil
    urls = nil
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_dateString_returnsCorrectValue() {
    // given
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .short
    let expectedDateString = formatter.string(from: createdDate)
    
    // then
    XCTAssertEqual(sut.dateString, expectedDateString)
  }
  
  func test_smallestPhotoURL_returnsCorrectPhotoURL() {
    XCTAssertEqual(sut.smallestPhotoURL?.absoluteString, smallestURL.source)
  }
  
  func test_largestPhotoURL_returnsCorrectPhotoURL() {
    XCTAssertEqual(sut.largestPhotoURL?.absoluteString, largestURL.source)
  }
}
