//
//  NetworkingClient.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
import FacebookLogin

struct NetworkingClient {

  // MARK: - Properties
  
  let baseURL: URL
  let session: URLSession
  let responseQueue: DispatchQueue?
  let accessToken: AccessToken?
  
  static let shared = NetworkingClient(
    baseURL: URL(string: "https://graph.facebook.com/")!,
    session: .shared,
    responseQueue: .main,
    accessToken: .current)
  
  // MARK: - Funcs
  
  @discardableResult
  func getAlbums(
    limit: Int,
    after: String?,
    completion: @escaping (Result<([PhotoAlbum], Paging?), Error>) -> Void
  ) throws -> URLSessionDataTask {
    
    let url = try makeURLForAlbums(limit: limit, after: after)
    
    let task = session.dataTask(
      with: url
    ) { data, response, error in
      
      guard let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
          self.dispatchResult(
            .failure(NetworkingError.badResponse),
            completion: completion)
          return
      }
      
      if let error = error {
        self.dispatchResult(
          .failure(error),
          completion: completion)
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(NetworkingError.noData),
          completion: completion)
        return
      }
      
      do {
        let response: AlbumsResponse = try self.decode(data: data)
        let albums = response.data
        let paging = response.paging
        
        self.dispatchResult(
          .success((albums, paging)),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(error),
          completion: completion)
      }
    }
    
    task.resume()
    return task
  }
  
  @discardableResult
  func getPhotos(
    fromAlbumWithId albumId: String,
    limit: Int,
    after: String?,
    completion: @escaping (Result<([Photo], Paging?), Error>) -> Void
  ) throws -> URLSessionDataTask {

    let url = try makeURLForPhotos(
      albumId: albumId,
      limit: limit,
      after: after)
    
    let task = session.dataTask(
      with: url
    ) { data, response, error in
      
      guard let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
          self.dispatchResult(
            .failure(NetworkingError.badResponse),
            completion: completion)
          return
      }
      
      if let error = error {
        self.dispatchResult(
          .failure(error),
          completion: completion)
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(NetworkingError.noData),
          completion: completion)
        return
      }
      
      do {
        let response: PhotosResponse = try self.decode(data: data)
        let albums = response.data
        let paging = response.paging
        
        self.dispatchResult(
          .success((albums, paging)),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(error),
          completion: completion)
      }
    }
    
    task.resume()
    return task
  }

  @discardableResult
  func getUserData(
    completion: @escaping (Result<UserData, Error>) -> Void
  ) throws -> URLSessionDataTask {

    let url = try makeURLForUserData()
    
    let task = session.dataTask(
      with: url
    ) { data, response, error in
      
      guard let response = response as? HTTPURLResponse,
        response.statusCode == 200 else {
          self.dispatchResult(
            .failure(NetworkingError.badResponse),
            completion: completion)
          return
      }
      
      if let error = error {
        self.dispatchResult(
          .failure(error),
          completion: completion)
        return
      }
      
      guard let data = data else {
        self.dispatchResult(
          .failure(NetworkingError.noData),
          completion: completion)
        return
      }
      
      do {
        let userData: UserData = try self.decode(data: data)
        
        self.dispatchResult(
          .success(userData),
          completion: completion)
        
      } catch {
        self.dispatchResult(
          .failure(error),
          completion: completion)
      }
    }
    
    task.resume()
    return task
  }
  
  func makeURLForAlbums(
    limit: Int,
    after: String?
  ) throws -> URL {
    
    guard let userId = accessToken?.userID,
      let token = accessToken?.tokenString else {
        throw NetworkingError.unauthenticated
    }
    
    let baseUrl = baseURL
      .appendingPathComponent(userId)
      .appendingPathComponent("/albums")
    
    var comps = URLComponents(
      url: baseUrl,
      resolvingAgainstBaseURL: false)
    
    var queryItems = [
      URLQueryItem(name: QueryItemName.token, value: token),
      URLQueryItem(name: QueryItemName.fields, value: "id,name,created_time,picture"),
      URLQueryItem(name: QueryItemName.limit, value: "\(limit)")
    ]
    
    if let after = after {
      queryItems.append(URLQueryItem(name: QueryItemName.after, value: after))
    }
    
    comps?.queryItems = queryItems
    
    guard let url = comps?.url else {
      throw NetworkingError.internalError
    }
    
    return url
  }
  
  func makeURLForPhotos(
    albumId: String,
    limit: Int,
    after: String?
  ) throws -> URL {
    
    guard let token = accessToken?.tokenString else {
      throw NetworkingError.unauthenticated
    }
    
    let baseUrl = baseURL
      .appendingPathComponent(albumId)
      .appendingPathComponent("/photos")
    
    var comps = URLComponents(
      url: baseUrl,
      resolvingAgainstBaseURL: false)
    
    var queryItems = [
      URLQueryItem(name: QueryItemName.token, value: token),
      URLQueryItem(name: QueryItemName.fields, value: "id,created_time,images"),
      URLQueryItem(name: QueryItemName.limit, value: "\(limit)")
    ]
    
    if let after = after {
      queryItems.append(URLQueryItem(name: QueryItemName.after, value: after))
    }
    
    comps?.queryItems = queryItems
    
    guard let url = comps?.url else {
      throw NetworkingError.internalError
    }
    
    return url
  }
  
  func makeURLForUserData() throws -> URL {
    
    guard let userId = accessToken?.userID,
      let token = accessToken?.tokenString else {
      throw NetworkingError.unauthenticated
    }
    
    let baseUrl = baseURL
      .appendingPathComponent(userId)
    
    var comps = URLComponents(
      url: baseUrl,
      resolvingAgainstBaseURL: false)
    
    comps?.queryItems = [
      URLQueryItem(name: QueryItemName.token, value: token),
      URLQueryItem(name: QueryItemName.fields, value: "first_name,picture")
    ]
    
    guard let url = comps?.url else {
      throw NetworkingError.internalError
    }
    
    return url
  }
  
  // MARK: - Helpers
  
  private func dispatchResult<Type>(
    _ result: Result<Type, Swift.Error>,
    completion: @escaping (Result<Type, Swift.Error>) -> Void
  ) {
    
    guard let responseQueue = self.responseQueue else {
      completion(result)
      return
    }
    responseQueue.async {
      completion(result)
    }
  }
  
  private func decode<T: Decodable>(
    data: Data
  ) throws -> T {
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let result = try decoder.decode(
      T.self,
      from: data)
    
    return result
  }
  
  struct AlbumsResponse: Decodable {
    let data: [PhotoAlbum]
    let paging: Paging?
  }
  
  struct PhotosResponse: Decodable {
    let data: [Photo]
    let paging: Paging?
  }
  
  enum QueryItemName {
    static let limit  = "limit"
    static let fields = "fields"
    static let after  = "after"
    static let token  = "access_token"
  }
}

// MARK: - Networkable

extension NetworkingClient: Networkable {}
