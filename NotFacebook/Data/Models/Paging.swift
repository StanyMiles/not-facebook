//
//  Paging.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 20.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Paging {
  let cursors: Cursors
  let next: String?
  
  struct Cursors: Decodable {
    let before: String
    let after: String
  }
}

// MARK: - Decodable

extension Paging: Decodable {}
