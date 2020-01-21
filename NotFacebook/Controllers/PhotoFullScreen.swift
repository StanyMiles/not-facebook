//
//  PhotoFullScreen.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class PhotoFullScreen: UIViewController {
  
  // MARK: - Properties
 
  var photo: Photo!
  var imageClient: ImageClient!
  
  var index = 0
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkAssertions()
    loadData()
  }
  
  // MARK: - Funcs
  
  class func initializeController(
    with photo: Photo,
    index: Int,
    imageClient: ImageClient = .shared
  ) -> PhotoFullScreen {
    
    let controller = PhotoFullScreen.instantiate()
    controller.photo = photo
    controller.index = index
    controller.imageClient = imageClient
    return controller
  }
  
  func loadData() {
    guard let url = photo.largestPhotoURL else { return }
    
    activityIndicator.startAnimating()
    
    imageClient.setImage(
      on: self.imageView,
      fromURL: url,
      activityIndicator: activityIndicator)
  }
  
  func checkAssertions() {
    assert(photo != nil)
    assert(imageClient != nil)
  }
}

// MARK: - Storyboarded

extension PhotoFullScreen: Storyboarded {}

// MARK: - Indexable

extension PhotoFullScreen: Indexable {}
