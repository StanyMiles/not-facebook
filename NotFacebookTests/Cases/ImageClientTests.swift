//
//  ImageClientTests.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 06.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import XCTest
@testable import NotFacebook

class ImageClientTests: XCTestCase {
  
  // MARK: - Properties
  
  var sut: ImageClient!
  var mockSession: MockURLSession!
  var url: URL!
  var imageView: UIImageView!
  var expectedImage: UIImage!
  var expectedError: NSError!
  var receivedDataTask: MockURLSessionDataTask!
  var receivedImage: UIImage!
  var receivedError: Error!
  
  // MARK: - Lyfecycle
  
  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    sut = ImageClient(
      session: mockSession,
      responseQueue: nil)
    url = URL(string: "https://example.com/download-image")!
    imageView = UIImageView()
  }
  
  override func tearDown() {
    sut = nil
    mockSession = nil
    url = nil
    imageView = nil
    expectedImage = nil
    expectedError = nil
    receivedImage = nil
    receivedError = nil
    super.tearDown()
  }
  
  // MARK: - Given
  
  func givenExpectedImage() {
    expectedImage = UIImage(named: "facebook-logo")!
  }
  
  func givenExpectedError() {
    expectedError = NSError(domain: "com.example",
                            code: 42)
  }
  
  // MARK: - When
  
  func whenDownloadImage(
    image: UIImage? = nil,
    error: Error? = nil
  ) {
    receivedDataTask = sut.downloadImage(
      fromURL: url
    ) { result in
      
      switch result {
      case .success(let image):
        self.receivedImage = image
      case .failure(let error):
        self.receivedError = error
      }
      
      } as? MockURLSessionDataTask
    
    if let receivedDataTask = receivedDataTask {
      if let image = image {
        receivedDataTask.completionHandler(image.pngData(), nil, nil)
      } else if let error = error {
        receivedDataTask.completionHandler(nil, nil, error)
      }
    }
  }

  func whenSetImage() {
    givenExpectedImage()
    sut.setImage(
      on: imageView,
      fromURL: url,
      withPlaceholder: nil)
    receivedDataTask = sut.cachedTaskForImageView[imageView] as? MockURLSessionDataTask
    receivedDataTask.completionHandler(expectedImage.pngData(), nil, nil)
  }
  
  // MARK: - Then
  
  func verifyDownloadImageDispatched(
    image: UIImage? = nil,
    error: Error? = nil,
    line: UInt = #line
  ) {

    mockSession.givenDispatchQueue()
    sut = ImageClient(
      session: mockSession,
      responseQueue: .main)

    var receivedThread: Thread!
    let exp = expectation(description: "Completion wasn't called")

    // when
    let dataTask = sut.downloadImage(fromURL: url) { _ in
      receivedThread = Thread.current
      exp.fulfill()
      } as! MockURLSessionDataTask
    dataTask.completionHandler(image?.pngData(), nil, error)

    // then
    waitForExpectations(timeout: 0.2)
    XCTAssertTrue(receivedThread.isMainThread, line: line)
  }
  
  // MARK: - Tests
  
  func test_shared_setsResponseQueue() {
    XCTAssertEqual(ImageClient.shared.responseQueue, .main)
  }
  
  func test_shared_setsSession() {
    XCTAssertEqual(ImageClient.shared.session, .shared)
  }
  
  func test_init_setsCachedImageForURL() {
    XCTAssertEqual(sut.cachedImageForURL, [:])
  }

  func test_init_setsCachedTaskForImageView() {
    XCTAssertEqual(sut.cachedTaskForImageView, [:])
  }
  
  func test_init_setsSession() {
    XCTAssertEqual(sut.session, mockSession)
  }
  
  func test_init_setsReqponseQueue() {
    XCTAssertEqual(sut.responseQueue, nil)
  }
  
  func test_downloadImage_createsExpectedDataTask() {
    // when
    whenDownloadImage()
    
    // then
    XCTAssertEqual(receivedDataTask.url, url)
  }
  
  func test_downloadImage_callsResumeOnDataTask() {
    // when
    whenDownloadImage()
    
    // then
    XCTAssertTrue(receivedDataTask.calledResume)
  }
  
  func test_downloadImage_givenImage_callsCompletionWithImage() {
    // given
    givenExpectedImage()
    
    // when
    whenDownloadImage(image: expectedImage)
    
    // then
    XCTAssertEqual(expectedImage.pngData(), receivedImage.pngData())
  }
  
  func test_downloadImage_givenError_callsCompletionWithError() {
    // given
    givenExpectedError()

    // when
    whenDownloadImage(error: expectedError)

    // then
    XCTAssertEqual(receivedError as NSError, expectedError)
  }

  func test_downloadImage_givenImage_dispatchesToResponseQueue() {
    // given
    givenExpectedImage()
    // then
    verifyDownloadImageDispatched(image: expectedImage)
  }

  func test_downloadImage_givenError_dispatchesToResponseQueue() {
    // given
    givenExpectedError()

    // then
    verifyDownloadImageDispatched(error: expectedError)
  }

  func test_downloadImage_givenImage_cachesImage() {
    // given
    givenExpectedImage()

    // when
    whenDownloadImage(image: expectedImage)

    // then
    XCTAssertEqual(sut.cachedImageForURL[url]?.pngData(), expectedImage.pngData())
  }

  func test_downloadImage_givenCacheImage_returnsNilDataTask() {
    // given
    givenExpectedImage()

    // when
    whenDownloadImage(image: expectedImage)
    whenDownloadImage(image: expectedImage)

    // then
    XCTAssertNil(receivedDataTask)
  }

  func test_downloadImage_givenCachedImage_callsCompletionWithImage() {
    // given
    givenExpectedImage()

    // when
    whenDownloadImage(image: expectedImage)
    receivedImage = nil

    whenDownloadImage()

    // then
    XCTAssertEqual(receivedImage.pngData(), expectedImage.pngData())
  }

  func test_setImageOnImageView_cancelsExistingDataTask() {
    // given
    let dataTask = MockURLSessionDataTask(
      completionHandler: { _, _, _ in },
      url: url,
      queue: nil)
    sut.cachedTaskForImageView[imageView] = dataTask

    // when
    sut.setImage(
      on: imageView,
      fromURL: url,
      withPlaceholder: nil)

    // then
    XCTAssertTrue(dataTask.calledCancel)
  }

  func test_setImageOnImageView_setsPlaceholderOnImageView() {
    // given
    givenExpectedImage()

    // when
    sut.setImage(
      on: imageView,
      fromURL: url,
      withPlaceholder: expectedImage)

    // then
    XCTAssertEqual(imageView.image?.pngData(), expectedImage.pngData())
  }

  func test_setImageOnImageView_cachesDownloadTask() {
    // when
    sut.setImage(
      on: imageView,
      fromURL: url,
      withPlaceholder: nil)

    // then
    receivedDataTask = sut.cachedTaskForImageView[imageView] as? MockURLSessionDataTask
    XCTAssertEqual(receivedDataTask?.url, url)
  }

  func test_setImageOnImageView_onCompletionRemovesCachedTask() {
    // when
    whenSetImage()

    // then
    XCTAssertNil(sut.cachedTaskForImageView[imageView])
  }

  func test_setImageOnImageView_onCompletionSetsImage() {
    // when
    whenSetImage()

    // then
    XCTAssertEqual(imageView.image?.pngData(), expectedImage.pngData())
  }

  func test_setImageOnImageView_givenError_doesntSetImage() {
    // given
    givenExpectedImage()
    givenExpectedError()

    // when
    sut.setImage(
      on: imageView,
      fromURL: url,
      withPlaceholder: expectedImage)
    receivedDataTask = sut.cachedTaskForImageView[imageView] as? MockURLSessionDataTask
    receivedDataTask.completionHandler(nil, nil, expectedError)

    // then
    XCTAssertEqual(imageView.image?.pngData(), expectedImage.pngData())
  }
}
