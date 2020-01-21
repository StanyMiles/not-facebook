//
//  PhotoListScreen.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class PhotoListScreen: UICollectionViewController {
  
  // MARK: - Properties
  
  var album: PhotoAlbum!
  var networking: NetworkingFacade!
  
  var photos: [Photo] = []
  
  var showNoDataCell = false
  var hasMoreData = true
  var isLoading = false
  var paging: Paging?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkAssertions()
    setupUI()
    loadData()
  }
  
  // MARK: - Funcs
  
  class func initializeController(
    with album: PhotoAlbum,
    networking: NetworkingFacade = NetworkingFacade()
  ) -> PhotoListScreen {
    
    let controller = PhotoListScreen.instantiate()
    controller.album = album
    controller.networking = networking
    return controller
  }
  
  func loadData(limit: Int = 20) {
    if isLoading { return }
    isLoading = true
    
    _ = networking.getPhotos(
      fromAlbumWithId: album.id,
      limit: limit,
      after: paging?.cursors.after
    ) { [weak self] result in
      guard let self = self else { return }
      
      self.isLoading = false
      
      switch result {
      case .success(let newPhotos, let paging):
        
        self.paging = paging
        self.photos.append(contentsOf: newPhotos)
        self.showNoDataCell = self.photos.isEmpty
        if let paging = paging {
          self.hasMoreData = paging.next != nil
        } else {
          self.hasMoreData = false
        }
        
        let totalPhotos = self.photos.count
        let startIndex = totalPhotos - newPhotos.count
        
        self.updateCollectionViewCells(
          startIndex: startIndex,
          endIndex: totalPhotos - 1)
        
        #if DEBUG
        print("Loaded \(newPhotos.count) new photos")
        #endif
        
      case .failure(let error):
        
        if (error as? NetworkingError) == .unauthenticated {
          self.navigationController?.popToRootViewController(animated: true)
          return
        }
        
        self.showNoDataCell = self.photos.isEmpty
        self.hasMoreData = false
        self.collectionView.reloadData()
        
        var message = "Something went wrong"
        if let error = error as? NetworkingError {
          if error == .noData {
            message = "You don't have any photos in this album"
          }
        }
        self.showAlert(title: "Failed to load photos", message: message)
      }
    }
  }
  
  private func updateCollectionViewCells(
    startIndex: Int,
    endIndex: Int
  ) {
    guard endIndex > startIndex else {
      collectionView.reloadData()
      return
    }
    
    var ips: [IndexPath] = []
    for i in startIndex...endIndex {
      let ip = IndexPath(item: i, section: 0)
      ips.append(ip)
    }
    
    let spinnerSection = IndexSet(integer: 1)
    
    collectionView.performBatchUpdates({
      if !self.hasMoreData {
        self.collectionView.deleteSections(spinnerSection)
      }
      self.collectionView.insertItems(at: ips)
    })
  }
  
  func checkAssertions() {
    assert(networking != nil)
    assert(album != nil)
  }
  
  func setupUI() {
    navigationItem.title = album.name
  }
  
  func presentPhotoFullScreen(atIndex index: Int) {
    let vc = PageViewController.initializeController(
      with: photos,
      startIndex: index)
    navigationController?.present(vc, animated: true)
  }
}

// MARK: - UICollectionViewControllerDataSource

extension PhotoListScreen {
  
  override func numberOfSections(
    in collectionView: UICollectionView
  ) -> Int {
    hasMoreData && !showNoDataCell ? 2 : 1
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    if section == 1 { return 1 }
    return showNoDataCell ? 1 : photos.count
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    
    if indexPath.section == 1 {
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: ReuseIdentifier.spinner,
        for: indexPath)
    }
    
    if showNoDataCell {
      return collectionView.dequeueReusableCell(
        withReuseIdentifier: ReuseIdentifier.noData,
        for: indexPath)
    }
    
    return collectionView.dequeueReusableCell(
      withReuseIdentifier: ReuseIdentifier.cell,
      for: indexPath) as! CollectionViewCell
  }
  
  override func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let cell = cell as? CollectionViewCell else { return }
    
    let photo = photos[indexPath.item]
    cell.setup(with: photo)
  }
}

// MARK: - UICollectionViewControllerDelegate

extension PhotoListScreen {
  
  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    
    guard !showNoDataCell && indexPath.section != 1 else { return }
    presentPhotoFullScreen(atIndex: indexPath.item)
  }
}

// MARK: - UICollectionViewControllerDelegateFlowLayout

extension PhotoListScreen: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    
    LayoutManager.getItemSize(
      for: collectionView,
      at: indexPath,
      noDataCell: showNoDataCell)
  }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension PhotoListScreen: UICollectionViewDataSourcePrefetching {
  
  func collectionView(
    _ collectionView: UICollectionView,
    prefetchItemsAt indexPaths: [IndexPath]
  ) {
    
    guard indexPaths.contains(where: { $0.section == 1 }) else { return }
    loadData()
  }
}
// MARK: - Storyboarded

extension PhotoListScreen: Storyboarded {}
