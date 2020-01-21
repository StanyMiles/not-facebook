//
//  NetworkingClientTests.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
import FacebookLogin
@testable import NotFacebook

class NetworkingClientTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: NetworkingClient!
  var userId: String!
  var token: String!
  var baseURL: URL!
  var mockSession: MockURLSession!
  var accessToken: AccessToken!
  var limit: Int!
  var after: String!
  var albumId: String!
  
  // MARK: - Lifecycle
  
  override func setUp() {
    super.setUp()
    userId = "userId"
    token = "token"
    baseURL = URL(string: "https://example.com")!
    mockSession = MockURLSession()
    limit = 20
    after = "test-after-key"
    albumId = "album-id"
    accessToken = AccessToken(
      tokenString: token,
      permissions: [],
      declinedPermissions: [],
      expiredPermissions: [],
      appID: "",
      userID: userId,
      expirationDate: nil,
      refreshDate: nil,
      dataAccessExpirationDate: nil)
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: nil,
      accessToken: accessToken)
  }
  
  override func tearDown() {
    sut = nil
    userId = nil
    token = nil
    baseURL = nil
    mockSession = nil
    limit = nil
    after = nil
    albumId = nil
    super.tearDown()
  }
  
  // MARK: - Given
  
  func givenSutWithNoToken() {
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: nil,
      accessToken: nil)
  }
  
  var expectedAlbumsURL: URL {
    let baseUrl = baseURL
      .appendingPathComponent(userId)
      .appendingPathComponent("/albums")
    var comps = URLComponents(
      url: baseUrl,
      resolvingAgainstBaseURL: false)
    var queryItems = [
      URLQueryItem(
        name: NetworkingClient.QueryItemName.token,
        value: token),
      URLQueryItem(
        name: NetworkingClient.QueryItemName.fields,
        value: "id,name,created_time,picture"),
      URLQueryItem(
        name: NetworkingClient.QueryItemName.limit,
        value: "\(limit!)")
    ]
    if let after = after {
      queryItems.append(URLQueryItem(
        name: NetworkingClient.QueryItemName.after,
        value: after))
    }
    comps?.queryItems = queryItems
    return comps!.url!
  }
  
  var expectedPhotosURL: URL {
    let baseUrl = baseURL
      .appendingPathComponent(albumId)
      .appendingPathComponent("/photos")
    var comps = URLComponents(
      url: baseUrl,
      resolvingAgainstBaseURL: false)
    var queryItems = [
      URLQueryItem(
        name: NetworkingClient.QueryItemName.token,
        value: token),
      URLQueryItem(
        name: NetworkingClient.QueryItemName.fields,
        value: "id,created_time,images"),
      URLQueryItem(
        name: NetworkingClient.QueryItemName.limit,
        value: "\(limit!)")
    ]
    if let after = after {
      queryItems.append(URLQueryItem(
        name: NetworkingClient.QueryItemName.after,
        value: after))
    }
    comps?.queryItems = queryItems
    return comps!.url!
  }
  
  var expectedUserDataURL: URL {
    let baseUrl = baseURL
      .appendingPathComponent(userId)
    var comps = URLComponents(
      url: baseUrl,
      resolvingAgainstBaseURL: false)
    comps?.queryItems = [
      URLQueryItem(
        name: NetworkingClient.QueryItemName.token,
        value: token),
      URLQueryItem(
        name: NetworkingClient.QueryItemName.fields,
        value: "first_name,picture")
    ]
    return comps!.url!
  }
  
  // MARK: - When
  
  func whenGetAlbums() throws -> MockURLSessionDataTask {
    let mockTask = try sut.getAlbums(
      limit: limit,
      after: after
    ) { _ in } as! MockURLSessionDataTask
    return mockTask
  }
  
  func whenGetAlbums(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil
  ) throws -> (
    calledCompletion: Bool,
    albums: [PhotoAlbum]?,
    paging: Paging?,
    error: Error?) {
      
      let url = try sut.makeURLForAlbums(
        limit: limit,
        after: after)
      
      let response = HTTPURLResponse(
        url: url,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil)
      
      var calledCompletion = false
      var receivedAlbums: [PhotoAlbum]?
      var receivedPaging: Paging?
      var receivedError: Error?
      
      let mockTask = try sut.getAlbums(
        limit: limit,
        after: after
      ) { result in
        
        calledCompletion = true
        
        switch result {
        case .success(let albums, let paging):
          receivedAlbums = albums
          receivedPaging = paging
        case .failure(let error):
          receivedError = error
        }
        
        } as! MockURLSessionDataTask
      
      mockTask.completionHandler(data, response, error)
      
      return (calledCompletion, receivedAlbums, receivedPaging, receivedError)
  }

  func verifyGetAlbumsDispatchedToMain(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil,
    line: UInt = #line
  ) throws {

    mockSession.givenDispatchQueue()
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: .main,
      accessToken: accessToken)

    let exp = expectation(description: "Completion wasn't called")

    // when
    var thread: Thread!
    let mockTask = try sut.getAlbums(
      limit: limit,
      after: after
    ) { _ in

      thread = Thread.current
      exp.fulfill()

      } as! MockURLSessionDataTask
    
    let url = try sut.makeURLForAlbums(
      limit: limit,
      after: after)

    let response = HTTPURLResponse(
      url: url,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil)

    mockTask.completionHandler(data, response, error)

    // then
    waitForExpectations(timeout: 0.2) { _ in
      XCTAssertTrue(thread.isMainThread, line: line)
    }
  }
  
  func whenGetPhotos() throws -> MockURLSessionDataTask {
    let mockTask = try sut.getPhotos(
      fromAlbumWithId: albumId,
      limit: limit,
      after: after
    ) { _ in } as! MockURLSessionDataTask
    return mockTask
  }
  
  func whenGetPhotos(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil
  ) throws -> (
    calledCompletion: Bool,
    photos: [Photo]?,
    paging: Paging?,
    error: Error?) {
      
      let url = try sut.makeURLForPhotos(
        albumId: albumId,
        limit: limit,
        after: after)
      
      let response = HTTPURLResponse(
        url: url,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil)
      
      var calledCompletion = false
      var receivedPhotos: [Photo]?
      var receivedPaging: Paging?
      var receivedError: Error?
      
      let mockTask = try sut.getPhotos(
        fromAlbumWithId: albumId,
        limit: limit,
        after: after
      ) { result in
        
        calledCompletion = true
        
        switch result {
        case .success(let photos, let paging):
          receivedPhotos = photos
          receivedPaging = paging
        case .failure(let error):
          receivedError = error
        }
        
        } as! MockURLSessionDataTask
      
      mockTask.completionHandler(data, response, error)
      
      return (calledCompletion, receivedPhotos, receivedPaging, receivedError)
  }
  
  func verifyGetPhotosDispatchedToMain(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil,
    line: UInt = #line
  ) throws {
    
    mockSession.givenDispatchQueue()
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: .main,
      accessToken: accessToken)
    
    let exp = expectation(description: "Completion wasn't called")
    
    // when
    var thread: Thread!
    let mockTask = try sut.getPhotos(
      fromAlbumWithId: albumId,
      limit: limit,
      after: after
    ) { _ in
      
      thread = Thread.current
      exp.fulfill()
      
      } as! MockURLSessionDataTask
    
    let url = try sut.makeURLForPhotos(
      albumId: albumId,
      limit: limit,
      after: after)
    
    let response = HTTPURLResponse(
      url: url,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil)
    
    mockTask.completionHandler(data, response, error)
    
    // then
    waitForExpectations(timeout: 0.2) { _ in
      XCTAssertTrue(thread.isMainThread, line: line)
    }
  }
  
  func whenGetUserData() throws -> MockURLSessionDataTask {
    let mockTask = try sut.getUserData() { _ in } as! MockURLSessionDataTask
    return mockTask
  }
  
  func whenGetUserData(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil
  ) throws -> (
    calledCompletion: Bool,
    userData: UserData?,
    error: Error?) {
      
      let url = try sut.makeURLForUserData()
      
      let response = HTTPURLResponse(
        url: url,
        statusCode: statusCode,
        httpVersion: nil,
        headerFields: nil)
      
      var calledCompletion = false
      var receivedUserData: UserData?
      var receivedError: Error?
      
      let mockTask = try sut.getUserData() { result in
        
        calledCompletion = true
        
        switch result {
        case .success(let userData):
          receivedUserData = userData
        case .failure(let error):
          receivedError = error
        }
        
        } as! MockURLSessionDataTask
      
      mockTask.completionHandler(data, response, error)
      
      return (calledCompletion, receivedUserData, receivedError)
  }
  
  func verifyGetUserDataDispatchedToMain(
    data: Data? = nil,
    statusCode: Int = 200,
    error: Error? = nil,
    line: UInt = #line
  ) throws {
    
    mockSession.givenDispatchQueue()
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: .main,
      accessToken: accessToken)
    
    let exp = expectation(description: "Completion wasn't called")
    
    // when
    var thread: Thread!
    let mockTask = try sut.getUserData { _ in
      
      thread = Thread.current
      exp.fulfill()
      
      } as! MockURLSessionDataTask
    
    let url = try sut.makeURLForUserData()
    
    let response = HTTPURLResponse(
      url: url,
      statusCode: statusCode,
      httpVersion: nil,
      headerFields: nil)
    
    mockTask.completionHandler(data, response, error)
    
    // then
    waitForExpectations(timeout: 0.2) { _ in
      XCTAssertTrue(thread.isMainThread, line: line)
    }
  }
  
  // MARK: - Tests
  
  // MARK: - shared
  
  func test_shared_setsBaseURL() {
    // given
    let baseURL = URL(string: "https://graph.facebook.com/")!
    
    // then
    XCTAssertEqual(NetworkingClient.shared.baseURL, baseURL)
  }
  
  func test_shared_setsSession() {
    XCTAssertEqual(NetworkingClient.shared.session, .shared)
  }
  
  func test_shared_setsResponseQueue() {
    XCTAssertEqual(NetworkingClient.shared.responseQueue, .main)
  }
  
  func test_shared_setsAccessToken() {
    XCTAssertEqual(NetworkingClient.shared.accessToken, .current)
  }
  
  // MARK: - init
  
  func test_init_setsBaseURL() {
    XCTAssertEqual(sut.baseURL, baseURL)
  }
  
  func test_init_setsSession() {
    XCTAssertEqual(sut.session, mockSession)
  }
  
  func test_init_setsResponseQueue() {
    // given
    sut = NetworkingClient(
      baseURL: baseURL,
      session: mockSession,
      responseQueue: .main,
      accessToken: nil)
    
    XCTAssertEqual(sut.responseQueue, .main)
  }
  
  func test_init_setsAccessToken() {
    XCTAssertEqual(sut.accessToken?.tokenString, accessToken.tokenString)
  }
  
  func test_init_givenNoAccessToken_doesntSetAccessToken() {
    // given
    givenSutWithNoToken()
    
    // then
    XCTAssertNil(sut.accessToken)
  }
  
  // MARK: - getAlbums
  
  func test_getAlbums_callsResumeOnTask() throws {
    // when
    let mockTask = try whenGetAlbums()
    
    // then
    XCTAssertTrue(mockTask.calledResume)
  }
  
  func test_getAlbums_callsExpectedURL() throws {
    // given
    let expectedURL = try sut.makeURLForAlbums(
      limit: limit,
      after: after)
    
    // when
    let mockTask = try whenGetAlbums()
    
    // then
    XCTAssertEqual(mockTask.url, expectedURL)
  }
  
  func test_getAlbums_givenResponseStatusCode500_callcCompletionWithError() throws {
    // given
    let expectedError = NetworkingError.badResponse
    
    // when
    let result = try whenGetAlbums(statusCode: 500)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.albums)
    let actualError = try XCTUnwrap(result.error as? NetworkingError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getAlbums_givenError_callsCompletionWithError() throws {
    // given
    let expectedError = NSError(domain: "com.example", code: 42)
    
    // when
    let result = try whenGetAlbums(error: expectedError)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.albums)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getAlbums_givenValidJson_callsCompletionWithAlbums() throws {
    // given
    let data = try Data.fromJSON(fileName: "albums-response")
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let apiResponse = try decoder.decode(
      NetworkingClient.AlbumsResponse.self,
      from: data)
    
    // when
    let result = try whenGetAlbums(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.error)
    XCTAssertNotNil(result.paging)
    XCTAssertEqual(result.albums?.count, apiResponse.data.count)
  }
  
  func test_getAlbums_givenInvalidJson_callsCompletionWithAlbums() throws {
    // given
    let data = try Data.fromJSON(fileName: "albums-response-damaged")
    
    var expectedError: NSError!
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    do {
      _ = try decoder.decode(
        NetworkingClient.AlbumsResponse.self,
        from: data)
    } catch {
      expectedError = error as NSError
    }
    
    // when
    let result = try whenGetAlbums(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.albums)
    XCTAssertNil(result.paging)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError.domain, expectedError.domain)
    XCTAssertEqual(actualError.code, expectedError.code)
  }
  
  func test_getAlbums_givenNoData_callsCompletionWithError() throws {
    // given
    let expectedError = NetworkingError.noData
    
    // when
    let result = try whenGetAlbums(statusCode: 200)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.albums)
    
    let actualError = try XCTUnwrap(result.error as? NetworkingError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getAlbums_givenHTTPStatusError_dispatchesToResponseQueue() throws {
    try verifyGetAlbumsDispatchedToMain(statusCode: 500)
  }
  
  func test_getAlbums_givenError_dispatchesToResponseQueue() throws {
    // given
    let error = NSError(domain: "com.example", code: 42)
    
    // then
    try verifyGetAlbumsDispatchedToMain(error: error)
  }
  
  func test_getAlbums_givenGoodResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "albums-response")
    
    // then
    try verifyGetAlbumsDispatchedToMain(data: data)
  }
  
  func test_getAlbums_givenInvalidResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "albums-response-damaged")
    
    // then
    try verifyGetAlbumsDispatchedToMain(data: data)
  }
  
  func test_getAlbums_givenNoData_dispatchesToResponseQueue() throws {
    try verifyGetAlbumsDispatchedToMain(statusCode: 200)
  }
  
  // MARK: - getPhotos
  
  func test_getPhotos_callsResumeOnTask() throws {
    // when
    let mockTask = try whenGetPhotos()
    
    // then
    XCTAssertTrue(mockTask.calledResume)
  }
  
  func test_getPhotos_callsExpectedURL() throws {
    // given
    let expectedURL = try sut.makeURLForPhotos(
      albumId: albumId,
      limit: limit,
      after: after)
    
    // when
    let mockTask = try whenGetPhotos()
    
    // then
    XCTAssertEqual(mockTask.url, expectedURL)
  }
  
  func test_getPhotos_givenResponseStatusCode500_callcCompletionWithError() throws {
    // given
    let expectedError = NetworkingError.badResponse
    
    // when
    let result = try whenGetPhotos(statusCode: 500)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.photos)
    let actualError = try XCTUnwrap(result.error as? NetworkingError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getPhotos_givenError_callsCompletionWithError() throws {
    // given
    let expectedError = NSError(domain: "com.example", code: 42)
    
    // when
    let result = try whenGetPhotos(error: expectedError)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.photos)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getPhotos_givenValidJson_callsCompletionWithPhotos() throws {
    // given
    let data = try Data.fromJSON(fileName: "photos-response")
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let apiResponse = try decoder.decode(
      NetworkingClient.PhotosResponse.self,
      from: data)
    
    // when
    let result = try whenGetPhotos(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.error)
    XCTAssertNotNil(result.paging)
    XCTAssertEqual(result.photos?.count, apiResponse.data.count)
  }
  
  func test_getPhotos_givenInvalidJson_callsCompletionWithError() throws {
    // given
    let data = try Data.fromJSON(fileName: "photos-response-damaged")
    
    var expectedError: NSError!
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    do {
      _ = try decoder.decode(
        NetworkingClient.PhotosResponse.self,
        from: data)
    } catch {
      expectedError = error as NSError
    }
    
    // when
    let result = try whenGetPhotos(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.photos)
    XCTAssertNil(result.paging)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError.domain, expectedError.domain)
    XCTAssertEqual(actualError.code, expectedError.code)
  }
  
  func test_getPhotos_givenNoData_callsCompletionWithError() throws {
    // given
    let expectedError = NetworkingError.noData
    
    // when
    let result = try whenGetPhotos(statusCode: 200)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.photos)
    
    let actualError = try XCTUnwrap(result.error as? NetworkingError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getPhotos_givenHTTPStatusError_dispatchesToResponseQueue() throws {
    try verifyGetPhotosDispatchedToMain(statusCode: 500)
  }
  
  func test_getPhotos_givenError_dispatchesToResponseQueue() throws {
    // given
    let error = NSError(domain: "com.example", code: 42)
    
    // then
    try verifyGetPhotosDispatchedToMain(error: error)
  }
  
  func test_getPhotos_givenGoodResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "photos-response")
    
    // then
    try verifyGetPhotosDispatchedToMain(data: data)
  }
  
  func test_getPhotos_givenInvalidResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "photos-response-damaged")
    
    // then
    try verifyGetPhotosDispatchedToMain(data: data)
  }
  
  func test_getPhotos_givenNoData_dispatchesToResponseQueue() throws {
    try verifyGetPhotosDispatchedToMain(statusCode: 200)
  }
  
  // MARK: - getUserData
  
  func test_getUserData_callsResumeOnTask() throws {
    // when
    let mockTask = try whenGetUserData()
    
    // then
    XCTAssertTrue(mockTask.calledResume)
  }
  
  func test_getUserData_callsExpectedURL() throws {
    // given
    let expectedURL = try sut.makeURLForUserData()
    
    // when
    let mockTask = try whenGetUserData()
    
    // then
    XCTAssertEqual(mockTask.url, expectedURL)
  }
  
  func test_getUserData_givenResponseStatusCode500_callcCompletionWithError() throws {
    // given
    let expectedError = NetworkingError.badResponse
    
    // when
    let result = try whenGetUserData(statusCode: 500)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.userData)
    let actualError = try XCTUnwrap(result.error as? NetworkingError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getUserData_givenError_callsCompletionWithError() throws {
    // given
    let expectedError = NSError(domain: "com.example", code: 42)
    
    // when
    let result = try whenGetUserData(error: expectedError)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.userData)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getUserData_givenValidJson_callsCompletionWithUserData() throws {
    // given
    let data = try Data.fromJSON(fileName: "userdata-response")
    
    let decoder = JSONDecoder()
    let apiResponse = try decoder.decode(
      UserData.self,
      from: data)
    
    // when
    let result = try whenGetUserData(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.error)
    XCTAssertEqual(result.userData?.firstName, apiResponse.firstName)
  }
  
  func test_getUserData_givenInvalidJson_callsCompletionWithError() throws {
    // given
    let data = try Data.fromJSON(fileName: "userdata-response-damaged")
    
    var expectedError: NSError!
    let decoder = JSONDecoder()
    do {
      _ = try decoder.decode(
        UserData.self,
        from: data)
    } catch {
      expectedError = error as NSError
    }
    
    // when
    let result = try whenGetUserData(data: data)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.userData)
    
    let actualError = try XCTUnwrap(result.error as NSError?)
    XCTAssertEqual(actualError.domain, expectedError.domain)
    XCTAssertEqual(actualError.code, expectedError.code)
  }
  
  func test_getUserData_givenNoData_callsCompletionWithError() throws {
    // given
    let expectedError = NetworkingError.noData
    
    // when
    let result = try whenGetUserData(statusCode: 200)
    
    // then
    XCTAssertTrue(result.calledCompletion)
    XCTAssertNil(result.userData)
    
    let actualError = try XCTUnwrap(result.error as? NetworkingError?)
    XCTAssertEqual(actualError, expectedError)
  }
  
  func test_getUserData_givenHTTPStatusError_dispatchesToResponseQueue() throws {
    try verifyGetUserDataDispatchedToMain(statusCode: 500)
  }
  
  func test_getUserData_givenError_dispatchesToResponseQueue() throws {
    // given
    let error = NSError(domain: "com.example", code: 42)
    
    // then
    try verifyGetUserDataDispatchedToMain(error: error)
  }
  
  func test_getUserData_givenGoodResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "userdata-response")
    
    // then
    try verifyGetUserDataDispatchedToMain(data: data)
  }
  
  func test_getUserData_givenInvalidResponse_dispatchesToResponseQueue() throws {
    // given
    let data = try Data.fromJSON(fileName: "userdata-response-damaged")
    
    // then
    try verifyGetUserDataDispatchedToMain(data: data)
  }
  
  func test_getUserData_givenNoData_dispatchesToResponseQueue() throws {
    try verifyGetUserDataDispatchedToMain(statusCode: 200)
  }
  
  // MARK: - makeURLForAlbums
  
  func test_makeURLForAlbums_givenAccessToken_returnsCorrectURL() throws {
    // when
    let url = try sut.makeURLForAlbums(limit: limit, after: after)
    
    // then
    XCTAssertEqual(url, expectedAlbumsURL)
  }
  
  func test_makeURLForAlbums_givenNoAccessToken_throwsError() {
    // given
    givenSutWithNoToken()
    var expectedError: NetworkingError?
    
    // when
    do {
      _ = try sut.makeURLForAlbums(limit: limit, after: after)
    } catch {
      expectedError = error as? NetworkingError
    }
    
    // then
    XCTAssertEqual(expectedError, .unauthenticated)
  }
  
  // MARK: - makeURLForPhotos
  
  func test_makeURLForPhotos_givenAccessToken_returnsCorrectURL() throws {
    // when
    let url = try sut.makeURLForPhotos(
      albumId: albumId,
      limit: limit,
      after: after)
    
    // then
    XCTAssertEqual(url, expectedPhotosURL)
  }
  
  func test_makeURLForPhotos_givenNoAccessToken_throwsError() {
    // given
    givenSutWithNoToken()
    var expectedError: NetworkingError?
    
    // when
    do {
      _ = try sut.makeURLForPhotos(
        albumId: albumId,
        limit: limit,
        after: after)
    } catch {
      expectedError = error as? NetworkingError
    }
    
    // then
    XCTAssertEqual(expectedError, .unauthenticated)
  }
  
  // MARK: - makeURLForUserData
  
  func test_makeURLForUserData_givenAccessToken_returnsCorrectURL() throws {
    // when
    let url = try sut.makeURLForUserData()
    
    // then
    XCTAssertEqual(url, expectedUserDataURL)
  }
  
  func test_makeURLForUserData_givenNoAccessToken_throwsError() {
    // given
    givenSutWithNoToken()
    var expectedError: NetworkingError?
    
    // when
    do {
      _ = try sut.makeURLForUserData()
    } catch {
      expectedError = error as? NetworkingError
    }
    
    // then
    XCTAssertEqual(expectedError, .unauthenticated)
  }
  
}
