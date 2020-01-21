//
//  UserData.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 20.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import Foundation

struct UserData {
  let firstName: String
  let picture: UserPicture
  
  var profileImageURL: URL? {
    guard let urlString = picture.data.url else { return nil }
    return URL(string: urlString)
  }
  
  struct UserPicture: Decodable {
    let data: PictureURL
  }
  
  struct PictureURL: Decodable {
    let url: String?
  }
}

// MARK: - Decodable

extension UserData: Decodable {
  
  enum CodingKeys: String, CodingKey {
    case firstName = "first_name"
    case picture
  }
}
