//
//  PhotoURL.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct PhotoURL {
  let width: Int
  let height: Int
  let source: String
  
  var url: URL? {
    URL(string: source)
  }
}

// MARK: - Decodable

extension PhotoURL: Decodable {}

// MARK: - Comparable

extension PhotoURL: Comparable {
  static func < (lhs: PhotoURL, rhs: PhotoURL) -> Bool {
    lhs.width > rhs.width
  }
}
