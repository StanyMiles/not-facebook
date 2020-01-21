//
//  NetworkingError.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 21.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
  case noData
  case badResponse
  case unauthenticated
  case internalError
}
