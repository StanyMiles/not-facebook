//
//  MockURLSession.swift
//  StanislavKobiletskiTests
//
//  Created by Stanislav Kobiletski on 02.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {
  
  var queue: DispatchQueue? = nil
  
  func givenDispatchQueue() {
    queue = DispatchQueue(label: "com.PokemonWise.MockSession")
  }
  
  override func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    
    MockURLSessionDataTask(
      completionHandler: completionHandler,
      url: url,
      queue: queue)
  }
}
