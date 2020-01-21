//
//  PhotoAlbum.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct PhotoAlbum {
  let id: String
  let name: String
  let createdDate: Date
  let picture: CoverPicture
  
  var coverURL: URL? {
    URL(string: picture.data.url)
  }
  
  var dateString: String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    formatter.dateStyle = .short
    let dateString = formatter.string(from: createdDate)
    return dateString
  }
  
  struct CoverPicture: Decodable {
    let data: PictureData
  }
  
  struct PictureData: Decodable {
    let url: String
  }
}

// MARK: - Decodable

extension PhotoAlbum: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case createdDate = "created_time"
    case picture
  }
}
