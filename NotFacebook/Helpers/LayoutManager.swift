//
//  LayoutManager.swift
//  NotFacebook
//
//  Created by Stanislav Kobiletski on 18.01.2020.
//  Copyright © 2020 Stanislav Kobiletski. All rights reserved.
//

import UIKit

struct LayoutManager {
  
  static func getItemSize(
    for collectionView: UICollectionView,
    at indexPath: IndexPath,
    noDataCell: Bool,
    numberOfColumns: CGFloat = 2,
    horizontalSpacing: CGFloat = 10
  ) -> CGSize {
    
    let numberOfColumns = noDataCell || indexPath.section == 1 ? 1 : numberOfColumns
    
    let totalHorizontalSpacing = (numberOfColumns + 1) * horizontalSpacing
    let width = (collectionView.bounds.width - totalHorizontalSpacing) / numberOfColumns
    let height = indexPath.section == 1 ? 60 : width
    
    return CGSize(width: width, height: height)
  }
}
