//
//  GraphRequestConnectionMock.swift
//  NotFacebookTests
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation
import FacebookCore

class GraphRequestConnectionMock: GraphRequestConnection {
  
  typealias GraphRequestBlock = (GraphRequestConnection?, Any?, Error?) -> Void
  
  var calledStart = false
  var calledCancel = false
  
  var request: GraphRequest?
  var data: Any?
  var error: Error?
  
  override func add(
    _ request: GraphRequest,
    completionHandler handler: @escaping GraphRequestBlock
  ) {
    self.request = request
    handler(nil, data, error)
  }
  
  override func start() {
    calledStart = true
  }
  
  override func cancel() {
    calledCancel = true
  }
}
