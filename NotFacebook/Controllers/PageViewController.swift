//
//  PageViewController.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
  
  // MARK: - Views
  
  lazy var backButton = UIButton.makeBackButton(
    target: self,
    action: #selector(dismissController))
  
  lazy var previousButton = UIButton.makeArrowButton(
    direction: .left,
    target: self,
    action: #selector(presentPreviousPhoto))
  
  lazy var nextButton = UIButton.makeArrowButton(
    direction: .right,
    target: self,
    action: #selector(presentNextPhoto))
  
  // MARK: - Properties
  
  var photos: [Photo]!
  var startIndex: Int!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkAssertions()
    setupDataSourceAndDelegate()
    setFirstController()
    setupButtons()
  }
  
  // MARK: - Funcs
  
  class func initializeController(
    with photos: [Photo],
    startIndex: Int
  ) -> PageViewController {
    
    let controller = PageViewController.instantiate()
    controller.photos = photos
    controller.startIndex = startIndex
    return controller
  }
  
  func setFirstController() {
    let controller = makeController(at: startIndex)
    setViewControllers(
      [controller],
      direction: .forward,
      animated: false)
  }
  
  func makeController(at index: Int) -> PhotoFullScreen {
    let photo = photos[index]
    let controller = PhotoFullScreen.initializeController(
      with: photo,
      index: index)
    return controller
  }
  
  func setupButtons() {
    view.addSubview(backButton)
    view.addSubview(previousButton)
    view.addSubview(nextButton)
    
    backButton.anchor(
      top: view.topAnchor,
      trailing: view.trailingAnchor,
      padding: .init(top: 10, left: 0, bottom: 0, right: 10),
      size: .init(width: 60, height: 60))
    
    previousButton.anchor(
      leading: view.leadingAnchor,
      centerY: view.centerYAnchor,
      size: .init(width: 60, height: 60))
    
    nextButton.anchor(
      trailing: view.trailingAnchor,
      centerY: view.centerYAnchor,
      size: .init(width: 60, height: 60))
    
    setupArrowButtons(for: startIndex)
  }
  
  func setupDataSourceAndDelegate() {
    dataSource = self
    delegate = self
  }
  
  func checkAssertions() {
    assert(photos != nil)
    assert(startIndex != nil)
  }
  
  func setupArrowButtons(for index: Int) {
    previousButton.isEnabled = index > 0
    nextButton.isEnabled = index < photos.count - 1
  }
  
  @objc func presentPreviousPhoto() {
    guard let viewController = viewControllers?.first else { return }
    guard let previousController = pageViewController(
      self,
      viewControllerBefore: viewController
      ) else {
        return
    }
    
    setViewControllers(
      [previousController],
      direction: .reverse,
      animated: true)
    
    guard let pvc = previousController as? Indexable else { return }
    setupArrowButtons(for: pvc.index)
  }
  
  @objc func presentNextPhoto() {
    guard let viewController = viewControllers?.first else { return }
    guard let nextController = pageViewController(
      self,
      viewControllerAfter: viewController
      ) else {
        return
    }
    
    setViewControllers(
      [nextController],
      direction: .forward,
      animated: true)
    
    guard let nvc = nextController as? Indexable else { return }
    setupArrowButtons(for: nvc.index)
  }
  
  @objc func dismissController() {
    dismiss(animated: true)
  }
}

// MARK: - UIPageViewControllerDataSource

extension PageViewController: UIPageViewControllerDataSource {
  
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    
    guard let viewController = viewController as? Indexable else { return nil }
    
    let previousIndex = viewController.index - 1
    guard previousIndex >= 0 else { return nil }
    
    let previousController = makeController(at: previousIndex)
    return previousController
  }
  
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    
    guard let viewController = viewController as? Indexable else { return nil }
    
    let nextIndex = viewController.index + 1
    guard nextIndex < photos.count else { return nil }
    
    let nextController = makeController(at: nextIndex)
    return nextController
  }
  
}

// MARK: - UIPageViewControllerDelegate

extension PageViewController: UIPageViewControllerDelegate {
  
  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    
    guard completed else { return }
    guard let viewController = viewControllers?.first as? Indexable else { return }
    setupArrowButtons(for: viewController.index)
  }
  
}

// MARK: - Storyboarded

extension PageViewController: Storyboarded {}
