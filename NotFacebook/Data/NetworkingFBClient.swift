//
//  NetworkingFBClient.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 17.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
import FacebookCore

struct NetworkingFBClient {
  
  @discardableResult
  func getAlbums(
    limit: Int,
    after: String? = nil,
    connection: GraphRequestConnection = GraphRequestConnection(),
    completion: @escaping (Result<([PhotoAlbum], Paging?), Error>) -> Void
  ) -> GraphRequestConnection {
    
    var graphPath = "me/albums?fields=id,name,created_time,picture&limit=\(limit)"
    
    if let after = after {
      graphPath += "&after=\(after)"
    }
    
    let request = GraphRequest(graphPath: graphPath)
    
    getData(request: request, connection: connection) { result in
      
      switch result {
      case .success(let data):
        
        do {
          let albums: [PhotoAlbum] = try self.decode(from: data, key: "data")
          let paging: Paging? = try? self.decode(from: data, key: "paging")
          completion(.success((albums, paging)))
        } catch {
          completion(.failure(error))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    return connection
  }
  
  @discardableResult
  func getPhotos(
    fromAlbumWithId id: String,
    limit: Int,
    after: String? = nil,
    connection: GraphRequestConnection = GraphRequestConnection(),
    completion: @escaping (Result<([Photo], Paging?), Error>) -> Void
  ) -> GraphRequestConnection {
    
    var graphPath = "\(id)/photos?fields=id,created_time,images&limit=\(limit)"
    
    if let after = after {
      graphPath += "&after=\(after)"
    }
    
    let request = GraphRequest(graphPath: graphPath)
    
    getData(request: request, connection: connection) { result in
      
      switch result {
      case .success(let data):
        
        do {
          let photos: [Photo] = try self.decode(from: data, key: "data")
          let paging: Paging? = try? self.decode(from: data, key: "paging")
          completion(.success((photos, paging)))
        } catch {
          completion(.failure(error))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    return connection
  }
  
  @discardableResult
  func getUserData(
    connection: GraphRequestConnection = GraphRequestConnection(),
    completion: @escaping (Result<UserData, Error>) -> Void
  ) -> GraphRequestConnection {
    
    let request = GraphRequest(graphPath: "me?fields=first_name,picture")
    
    getData(request: request, connection: connection) { result in
      
      switch result {
      case .success(let data):
        
        do {
          let userData: UserData = try self.decode(from: data)
          completion(.success(userData))
        } catch {
          completion(.failure(error))
        }
        
      case .failure(let error):
        completion(.failure(error))
      }
    }
    
    return connection
  }
  
  /// Requests Data from Server for provided GraphRequest
  func getData(
    request: GraphRequest,
    connection: GraphRequestConnection,
    completion: @escaping (Result<[String: Any], Error>) -> Void
  ) {
    
    connection.add(
      request
    ) { _, response, error in
      
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let data = response as? [String: Any] else {
        completion(.failure(NetworkingError.noData))
        return
      }
      completion(.success(data))
    }
    
    connection.start()
  }
  
  // MARK: - Helpers
  
  /// Decodes data from provided dictionary
  /// - Parameters:
  ///   - data: dictionary to decode
  ///   - key: key to acces value from dictionary
  private func decode<T: Decodable>(from data: [String: Any], key: String? = nil) throws -> T {
    
    let jsonData: Data
    
    if let key = key {
      if let dictionary = data[key] as? [[String: Any]] {
        jsonData = try JSONSerialization.data(
          withJSONObject: dictionary,
          options: .prettyPrinted)
        
      } else if let dictionary = data[key] as? [String: Any] {
        jsonData = try JSONSerialization.data(
          withJSONObject: dictionary,
          options: .prettyPrinted)
        
      } else {
        throw NetworkingError.noData
      }
      
    } else {
      
      jsonData = try JSONSerialization.data(
        withJSONObject: data,
        options: .prettyPrinted)
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let result = try decoder.decode(T.self, from: jsonData)
    return result
  }
  
}

// MARK: - FBNetworkable

extension NetworkingFBClient: FBNetworkable {}
