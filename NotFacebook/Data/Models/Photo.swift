//
//  Photo.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct Photo {
  let id: String
  let createdDate: Date
  let photoURLs: [PhotoURL]
  
  var largestPhotoURL: URL? {
    guard let photoUrl = photoURLs.sorted().first else { return nil }
    return URL(string: photoUrl.source)
  }
  
  var smallestPhotoURL: URL? {
    guard let photoUrl = photoURLs.sorted().last else { return nil }
    return URL(string: photoUrl.source)
  }
  
  var dateString: String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .short
    let dateString = formatter.string(from: createdDate)
    return dateString
  }
}

// MARK: - Decodable

extension Photo: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case id
    case createdDate = "created_time"
    case photoURLs = "images"
  }
}
