//
//  NetworkingFacade.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
import FacebookCore

struct NetworkingFacade {
  
  typealias CancelTaskClosure = () -> Void
  
  // MARK: - Properties
  
  let networkingClient: Networkable
  let networkingFBClient: FBNetworkable
  
  // MARK: - Initializer
  
  init(
    networkingClient: Networkable = NetworkingClient.shared,
    networkingFBClient: FBNetworkable = NetworkingFBClient()
  ) {
    self.networkingClient = networkingClient
    self.networkingFBClient = networkingFBClient
  }
  
  // MARK: - Funcs
  
  @discardableResult
  func getAlbums(
    limit: Int,
    after: String?,
    useFBClient: Bool = false,
    completion: @escaping (Result<([PhotoAlbum], Paging?), Error>) -> Void
  ) -> CancelTaskClosure? {
    
    if useFBClient {
      let connection = networkingFBClient.getAlbums(
        limit: limit,
        after: after,
        connection: GraphRequestConnection(),
        completion: completion)
      return connection.cancel
    }
    
    do {
      let task = try networkingClient.getAlbums(
        limit: limit,
        after: after,
        completion: completion)
      return task.cancel
      
    } catch {
      completion(.failure(error))
      return nil
    }
  }
  
  @discardableResult
  func getPhotos(
    fromAlbumWithId id: String,
    limit: Int,
    after: String?,
    useFBClient: Bool = false,
    completion: @escaping (Result<([Photo], Paging?), Error>) -> Void
  ) -> CancelTaskClosure? {
    
    if useFBClient {
      let connection = networkingFBClient.getPhotos(
        fromAlbumWithId: id,
        limit: limit,
        after: after,
        connection: GraphRequestConnection(),
        completion: completion)
      return connection.cancel
    }

    do {
      let task = try networkingClient.getPhotos(
        fromAlbumWithId: id,
        limit: limit,
        after: after,
        completion: completion)
      return task.cancel
      
    } catch {
      completion(.failure(error))
      return nil
    }
  }
  
  @discardableResult
  func getUserData(
    useFBClient: Bool = false,
    completion: @escaping (Result<UserData, Error>) -> Void
  ) -> CancelTaskClosure? {
    
    if useFBClient {
      let connection = networkingFBClient.getUserData(
        connection: GraphRequestConnection(),
        completion: completion)
      return connection.cancel
    }

    do {
      let task = try networkingClient.getUserData(
        completion: completion)
      return task.cancel
    } catch {
      completion(.failure(error))
      return nil
    }
  }
}
