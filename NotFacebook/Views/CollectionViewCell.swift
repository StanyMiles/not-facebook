//
//  CollectionViewCell.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 17.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  func setup(
    with album: PhotoAlbum,
    imageClient: ImageClient = .shared
  ) {
    
    titleLabel.text = album.name
    
    guard let url = album.coverURL else { return }
    activityIndicator.startAnimating()
    
    imageClient.setImage(
      on: imageView,
      fromURL: url,
      activityIndicator: activityIndicator)
  }
  
  func setup(
    with photo: Photo,
    imageClient: ImageClient = .shared
  ) {
    
    titleLabel.text = photo.dateString
    
    guard let url = photo.smallestPhotoURL else { return }
    activityIndicator.startAnimating()
    
    imageClient.setImage(
      on: imageView,
      fromURL: url,
      activityIndicator: activityIndicator)
  }
}
