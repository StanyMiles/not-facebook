//
//  FBNetworkable.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
import FacebookCore

protocol FBNetworkable {
  
  func getAlbums(
    limit: Int,
    after: String?,
    connection: GraphRequestConnection,
    completion: @escaping (Result<([PhotoAlbum], Paging?), Error>) -> Void
  ) -> GraphRequestConnection
  
  func getPhotos(
    fromAlbumWithId id: String,
    limit: Int,
    after: String?,
    connection: GraphRequestConnection,
    completion: @escaping (Result<([Photo], Paging?), Error>) -> Void
  ) -> GraphRequestConnection
  
  func getUserData(
    connection: GraphRequestConnection,
    completion: @escaping (Result<UserData, Error>) -> Void
  ) -> GraphRequestConnection
}
