//
//  PhotoAlbumTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 20.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class PhotoAlbumTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: PhotoAlbum!
  var createdDate: Date!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    createdDate = Date()
    let data = PhotoAlbum.PictureData(url: "")
    let cover = PhotoAlbum.CoverPicture(data: data)
    sut = PhotoAlbum(
      id: "",
      name: "",
      createdDate: createdDate,
      picture: cover)
  }
  
  override func tearDown() {
    createdDate = nil
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
  
}
