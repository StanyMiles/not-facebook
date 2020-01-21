//
//  NetworkingFBClientTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 17.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook
import FacebookCore

class NetworkingFBClientTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: NetworkingFBClient!
  var connection: GraphRequestConnectionMock!
  var graphRequest: GraphRequest!
  var id: String!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    connection = GraphRequestConnectionMock()
    graphRequest = GraphRequest(graphPath: "test/path")
    id = "test-id"
    sut = NetworkingFBClient()
  }
  
  override func tearDown() {
    connection = nil
    graphRequest = nil
    id = nil
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Given
  func givenData(fileName: String) throws {
    let data = try Data.fromJSON(fileName: fileName)
    let any = try data.toAny()
    connection.data = any
  }
  
  // MARK: - Tests
  
  // MARK: - getData
  
  func test_getData_callsStart() {
    // when
    _ = sut.getData(request: graphRequest, connection: connection) { _ in }
    
    // then
    XCTAssertTrue(connection.calledStart)
  }
  
  func test_getData_usesCorrectGraphRequest() {
    // when
    _ = sut.getData(request: graphRequest, connection: connection) { _ in }
    
    // then
    XCTAssertEqual(connection.request, graphRequest)
  }
  
  func test_getData_givenData_returnsData() {
    // given
    let providedData = ["test": "data"]
    connection.data = providedData
    var expectedData: [String: Any]?
    
    // when
    _ = sut.getData(request: graphRequest, connection: connection) { result in
      if case .success(let data) = result {
        expectedData = data
      }
    }
    
    // then
    XCTAssertNotNil(expectedData)
  }
  
  func test_getData_givenError_returnsError() {
    // given
    let providedError = NSError(domain: "com.example", code: 42)
    connection.error = providedError
    var expectedError: Error?
    
    // when
    _ = sut.getData(request: graphRequest, connection: connection) { result in
      if case .failure(let error) = result {
        expectedError = error
      }
    }
    
    // then
    XCTAssertNotNil(expectedError)
    XCTAssertEqual(expectedError as NSError?, providedError)
  }
  
  // MARK: - getAlbums
  
  func test_getAlbums_givenLimit_usesCorrectPath() {
    // given
    let limit = 20
    let expectedGraphPath = "me/albums?fields=id,name,created_time,picture&limit=\(limit)"
    
    // when
    sut.getAlbums(limit: limit, connection: connection) { _ in }
    
    // then
    XCTAssertEqual(connection.request?.graphPath, expectedGraphPath)
  }
  
  func test_getAlbums_givenPagingAfter_usesCorrectPath() {
    // given
    let limit = 20
    let after = "test-after-key"
    let expectedGraphPath = "me/albums?fields=id,name,created_time,picture&limit=\(limit)&after=\(after)"
    
    // when
    sut.getAlbums(
      limit: limit,
      after: after,
      connection: connection) { _ in }
    
    // then
    XCTAssertEqual(connection.request?.graphPath, expectedGraphPath)
  }
  
  func test_getAlbums_givenData_returnsPhotoAlbums() throws {
    // given
    try givenData(fileName: "albums-response")
    var expectedAlbums: [PhotoAlbum]?
    
    // when
    sut.getAlbums(limit: 0, connection: connection) { result in
      if case .success(let albums, _) = result {
        expectedAlbums = albums
      }
    }
    
    // then
    XCTAssertNotNil(expectedAlbums)
    XCTAssertEqual(expectedAlbums?.count, 5)
  }
  
  func test_getAlbums_givenData_returnsPaging() throws {
    // given
    try givenData(fileName: "albums-response")
    var expectedPaging: Paging?
    
    // when
    sut.getAlbums(limit: 0, connection: connection) { result in
      if case .success(_, let paging) = result {
        expectedPaging = paging
      }
    }
    
    // then
    XCTAssertNotNil(expectedPaging)
    XCTAssertEqual(expectedPaging?.cursors.after, "MTQyMDQzMDk1ODM0MjQ4")
  }
  
  func test_getAlbums_givenCorruptData_returnsError() throws {
    // given
    try givenData(fileName: "albums-response-damaged")
    var expectedError: Error?
    
    // when
    sut.getAlbums(limit: 0, connection: connection) { result in
      if case .failure(let error) = result {
        expectedError = error
      }
    }
    
    // then
    XCTAssertEqual(expectedError as? NetworkingError, NetworkingError.noData)
  }
  
  // MARK: - getPhotos
  
  func test_getPhotos_givenLimit_usesCorrectPath() {
    // given
    let limit = 20
    let expectedGraphPath = "\(id!)/photos?fields=id,created_time,images&limit=\(limit)"
    
    // when
    sut.getPhotos(
    fromAlbumWithId: id,
    limit: limit,
    connection: connection) { _ in }
    
    // then
    XCTAssertEqual(connection.request?.graphPath, expectedGraphPath)
  }
  
  func test_getPhotos_givenPagingAfter_usesCorrectPath() {
    // given
    let limit = 20
    let after = "test-after-key"
    let expectedGraphPath = "\(id!)/photos?fields=id,created_time,images&limit=\(limit)&after=\(after)"
    
    // when
    sut.getPhotos(
      fromAlbumWithId: id,
      limit: limit,
      after: after,
      connection: connection) { _ in }
    
    // then
    XCTAssertEqual(connection.request?.graphPath, expectedGraphPath)
  }
  
  func test_getPhotos_givenData_returnsPhotos() throws {
    // given
    try givenData(fileName: "photos-response")
    var expectedPhotos: [Photo]?

    // when
    sut.getPhotos(fromAlbumWithId: id, limit: 0, connection: connection) { result in
      if case .success(let photos, _) = result {
        expectedPhotos = photos
      }
    }

    // then
    XCTAssertNotNil(expectedPhotos)
    XCTAssertEqual(expectedPhotos?.count, 1)
  }
  
  func test_getPhotos_givenData_returnsPaging() throws {
    // given
    try givenData(fileName: "photos-response")
    var expectedPaging: Paging?
    
    // when
    sut.getPhotos(fromAlbumWithId: id, limit: 0, connection: connection) { result in
      if case .success(_, let paging) = result {
        expectedPaging = paging
      }
    }
    
    // then
    XCTAssertNotNil(expectedPaging)
    XCTAssertEqual(expectedPaging?.cursors.after, "MjI1NTU0NzA2NzgxNzE2MwZDZD")
  }

  func test_getPhotos_givenCorruptData_returnsError() throws {
    // given
    try givenData(fileName: "photos-response-damaged")
    var expectedError: Error?

    // when
    sut.getPhotos(fromAlbumWithId: id, limit: 0, connection: connection) { result in
      if case .failure(let error) = result {
        expectedError = error
      }
    }

    // then
    XCTAssertEqual(expectedError as? NetworkingError, NetworkingError.noData)
  }
  
  // MARK: - getUserData
  
  func test_getUserData_usesCorrectPath() {
    // given
    let expectedGraphPath = "me?fields=first_name,picture"
    
    // when
    sut.getUserData(connection: connection) { _ in }
    
    // then
    XCTAssertEqual(connection.request?.graphPath, expectedGraphPath)
  }
  
  func test_getUserData_givenData_returnsUserData() throws {
    // given
    try givenData(fileName: "userdata-response")
    var expectedUserData: UserData?
    
    // when
    sut.getUserData(connection: connection) { result in
      if case .success(let userData) = result {
        expectedUserData = userData
      }
    }
    
    // then
    XCTAssertNotNil(expectedUserData)
    XCTAssertEqual(expectedUserData?.firstName, "Stanislav")
  }
  
  func test_getUserData_givenCorruptData_returnsError() throws {
    // given
    try givenData(fileName: "userdata-response-damaged")
    var expectedError: Error?
    
    // when
    sut.getUserData(connection: connection) { result in
      if case .failure(let error) = result {
        expectedError = error
      }
    }
    
    // then
    XCTAssertNotNil(expectedError)
  }
  
}
