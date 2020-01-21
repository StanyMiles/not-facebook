//
//  PhotoURLTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 20.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class PhotoURLTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: PhotoURL!
  var urlString: String!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    urlString = "https://example.com"
    sut = PhotoURL(width: 0, height: 0, source: urlString)
  }
  
  override func tearDown() {
    urlString = nil
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  func test_url_returnsCorrectValue() {
    // given
    let expectedUrl = URL(string: urlString)
    
    // then
    XCTAssertEqual(sut.url, expectedUrl)
  }
  
  func test_sorting() {
    // given
    let smallestURL = PhotoURL(width: 100, height: 100, source: "https://smallest-url.com")
    let largestURL = PhotoURL(width: 200, height: 200, source: "https://largest-url.com")
    var urls = [smallestURL, largestURL]
    
    // when
    urls.sort()
    
    // then
    XCTAssertEqual(urls.first?.source, largestURL.source)
  }
  
}
