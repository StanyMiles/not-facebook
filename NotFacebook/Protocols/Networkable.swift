//
//  Networkable.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

protocol Networkable {
  
  func getAlbums(
    limit: Int,
    after: String?,
    completion: @escaping (Result<([PhotoAlbum], Paging?), Error>) -> Void
  ) throws -> URLSessionDataTask
  
  func getPhotos(
    fromAlbumWithId albumId: String,
    limit: Int,
    after: String?,
    completion: @escaping (Result<([Photo], Paging?), Error>) -> Void
  ) throws -> URLSessionDataTask
  
  func getUserData(
    completion: @escaping (Result<UserData, Error>) -> Void
  ) throws -> URLSessionDataTask
}
