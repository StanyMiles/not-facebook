//
//  NetworkingClientSpy.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
@testable import NotFacebook

class NetworkingClientSpy: Networkable {
  
  var calledGetAlbums = false
  var calledGetPhotos = false
  var calledGetUserData = false
  
  func getAlbums(
    limit: Int,
    after: String?,
    completion: @escaping (Result<([PhotoAlbum], Paging?), Error>) -> Void
  ) throws -> URLSessionDataTask {
    
    calledGetAlbums = true
    
    return MockURLSessionDataTask(
      completionHandler: { _, _, _ in },
      url: URL(string: "https://example.com")!,
      queue: nil)
  }
  
  func getPhotos(
    fromAlbumWithId albumId: String,
    limit: Int,
    after: String?,
    completion: @escaping (Result<([Photo], Paging?), Error>) -> Void
  ) throws -> URLSessionDataTask {
    
    calledGetPhotos = true
    
    return MockURLSessionDataTask(
      completionHandler: { _, _, _ in },
      url: URL(string: "https://example.com")!,
      queue: nil)
  }
  
  func getUserData(
    completion: @escaping (Result<UserData, Error>) -> Void
  ) throws -> URLSessionDataTask {
    
    calledGetUserData = true
    
    return MockURLSessionDataTask(
      completionHandler: { _, _, _ in },
      url: URL(string: "https://example.com")!,
      queue: nil)
  }
}
