//
//  ImageClient.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 17.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class ImageClient {
  
  // MARK: - Properties
  
  static let shared = ImageClient(
    session: .shared,
    responseQueue: .main)
  
  let session: URLSession
  let responseQueue: DispatchQueue?
  
  var cachedImageForURL: [URL: UIImage]
  var cachedTaskForImageView: [UIImageView: URLSessionDataTask]
  
  // MARK: - Initializer
  
  init(
    session: URLSession,
    responseQueue: DispatchQueue?
  ) {
    self.session = session
    self.responseQueue = responseQueue
    self.cachedImageForURL = [:]
    self.cachedTaskForImageView = [:]
  }
  
  // MARK: - Funcs
  
  func downloadImage(
    fromURL url: URL,
    completion: @escaping (Result<UIImage, Error>) -> Void
  ) -> URLSessionDataTask? {
    
    if let image = cachedImageForURL[url] {
      completion(.success(image))
      return nil
    }
    
    let task = session.dataTask(
      with: url
    ) { [weak self] data, _, error in
      
      guard let self = self else { return }
      
      if let data = data, let image = UIImage(data: data) {
        self.cachedImageForURL[url] = image
        self.dispatch(.success(image), completion: completion)
      } else if let error = error {
        self.dispatch(.failure(error), completion: completion)
      }
    }
    
    task.resume()
    
    return task
  }
  
  func setImage(
    on imageView: UIImageView,
    fromURL url: URL,
    withPlaceholder placeholder: UIImage? = nil,
    activityIndicator: UIActivityIndicatorView? = nil
  ) {
    
    cachedTaskForImageView[imageView]?.cancel()
    
    imageView.alpha = 0
    imageView.image = placeholder
    
    cachedTaskForImageView[imageView] = downloadImage(
      fromURL: url
    ) { [weak self] result in
      
      activityIndicator?.stopAnimating()
      
      guard let self = self else { return }
      
      self.cachedTaskForImageView[imageView] = nil
      
      switch result {
      case .success(let image):
        imageView.image = image
        
        UIView.animate(withDuration: 0.3) {
          imageView.alpha = 1
        }
        
      case .failure(let error):
        #if DEBUG
        print("Set Image failed with error:", String(describing: error))
        #endif
      }
    }
  }
  
  // MARK: - Helpers
  
  private func dispatch(
    _ result: Result<UIImage, Error>,
    completion: @escaping (Result<UIImage, Error>) -> Void
  ) {
    
    guard let responseQueue = responseQueue else {
      completion(result)
      return
    }
    
    responseQueue.async {
      completion(result)
    }
  }
}
