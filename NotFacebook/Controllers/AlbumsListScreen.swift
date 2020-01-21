//
//  AlbumsListScreen.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 17.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class AlbumsListScreen: UICollectionViewController {
  
  // MARK: - Properties
  
  var networking: NetworkingFacade!
  
  var albums: [PhotoAlbum] = []
  
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
    networking: NetworkingFacade = NetworkingFacade()
  ) -> AlbumsListScreen {
    
    let controller = AlbumsListScreen.instantiate()
    controller.networking = networking
    return controller
  }
  
  func loadData(limit: Int = 20) {
    if isLoading { return }
    isLoading = true
    
    _ = networking.getAlbums(
      limit: limit,
      after: paging?.cursors.after
    ) { [weak self] result in
      guard let self = self else { return }
 
      self.isLoading = false
      
      switch result {
      case .success(let newAlbums, let paging):
        
        self.paging = paging
        self.albums.append(contentsOf: newAlbums)
        self.showNoDataCell = self.albums.isEmpty
        if let paging = paging {
          self.hasMoreData = paging.next != nil
        } else {
          self.hasMoreData = false
        }
        
        let totalAlbums = self.albums.count
        let startIndex = totalAlbums - newAlbums.count
        
        self.updateCollectionViewCells(
          startIndex: startIndex,
          endIndex: totalAlbums - 1)
        
        #if DEBUG
        print("Loaded \(newAlbums.count) new albums")
        #endif
        
      case .failure(let error):
        
        if (error as? NetworkingError) == .unauthenticated {
          self.navigationController?.popToRootViewController(animated: true)
          return
        }
        
        self.showNoDataCell = self.albums.isEmpty
        self.hasMoreData = false
        self.collectionView.reloadData()
        
        var message = "Something went wrong"
        if let error = error as? NetworkingError {
          if error == .noData {
            message = "You don't have any albums"
          }
        }
        self.showAlert(title: "Failed to load albums", message: message)
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
  }
  
  func presentPhotoListScreen(with album: PhotoAlbum) {
    let vc = PhotoListScreen.initializeController(with: album)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func setupUI() {
    navigationItem.title = "My Albums"
    
    let barButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "person.crop.circle"),
      style: .plain,
      target: self,
      action: #selector(presentDrawer))
    barButtonItem.tintColor = .label
    navigationItem.rightBarButtonItem = barButtonItem
    
    navigationItem.hidesBackButton = true
  }
  
  @objc func presentDrawer() {
    guard let navController = navigationController else { return }

    let drawer = DrawerController.initializeController()
    navController.add(childController: drawer)
    drawer.view.fillSuperview()
    drawer.open()
  }
}

// MARK: - UICollectionViewControllerDataSource

extension AlbumsListScreen {
  
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
    return showNoDataCell ? 1 : albums.count
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
    
    let album = albums[indexPath.item]
    cell.setup(with: album)
  }
}

// MARK: - UICollectionViewControllerDelegate

extension AlbumsListScreen {
  
  override func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    
    guard !showNoDataCell && indexPath.section != 1 else { return }
    let album = albums[indexPath.item]
    presentPhotoListScreen(with: album)
  }
}

// MARK: - UICollectionViewControllerDelegateFlowLayout

extension AlbumsListScreen: UICollectionViewDelegateFlowLayout {
  
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

extension AlbumsListScreen: UICollectionViewDataSourcePrefetching {
  
  func collectionView(
    _ collectionView: UICollectionView,
    prefetchItemsAt indexPaths: [IndexPath]
  ) {
    
    guard indexPaths.contains(where: { $0.section == 1 }) else { return }
    loadData()
  }
}

// MARK: - Storyboarded

extension AlbumsListScreen: Storyboarded {}
