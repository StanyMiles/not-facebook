//
//  NetworkingFBClientSpy.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
import FacebookCore
@testable import NotFacebook

class NetworkingFBClientSpy: FBNetworkable {
  
  var calledGetAlbums = false
  var calledGetPhotos = false
  var calledGetUserData = false
  
  func getAlbums(
    limit: Int,
    after: String?,
    connection: GraphRequestConnection = GraphRequestConnection(),
    completion: @escaping (Result<([PhotoAlbum], Paging?), Error>) -> Void
  ) -> GraphRequestConnection {
    
    calledGetAlbums = true
    return connection
  }
  
  func getPhotos(
    fromAlbumWithId id: String,
    limit: Int,
    after: String?,
    connection: GraphRequestConnection = GraphRequestConnection(),
    completion: @escaping (Result<([Photo], Paging?), Error>) -> Void
  ) -> GraphRequestConnection {
    
    calledGetPhotos = true
    return connection
  }
  
  func getUserData(
    connection: GraphRequestConnection = GraphRequestConnection(),
    completion: @escaping (Result<UserData, Error>) -> Void
  ) -> GraphRequestConnection {
    
    calledGetUserData = true
    return connection
  }
}
