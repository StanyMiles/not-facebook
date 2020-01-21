//
//  MockURLSessionDataTask.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 02.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
  
  var completionHandler: (Data?, URLResponse?, Error?) -> Void
  var url: URL
  
  init(
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void,
    url: URL,
    queue: DispatchQueue?
  ) {
    
    if let queue = queue {
      self.completionHandler = { data, response, error in
        queue.async {
          completionHandler(data, response, error)
        }
      }
    } else {
      self.completionHandler = completionHandler
    }
    
    self.url = url
    super.init()
  }
  
  var calledResume = false
  override func resume() {
    calledResume = true
  }
  
  var calledCancel = false
  override func cancel() {
    calledCancel = true
  }
}
