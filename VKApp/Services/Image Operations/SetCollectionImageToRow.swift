//
//  SetCollectionImageToRow.swift
//  VKApp
//
//  Created by Тимур Таймасов on 21.04.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit

class SetCollectionImageToRow: Operation {
    
    private let indexPath: IndexPath
    private weak var collectionView: UICollectionView?
    private var cell: UICollectionViewCell?
    
    init(cell: UICollectionViewCell, indexPath: IndexPath, collectionView: UICollectionView) {
        self.indexPath = indexPath
        self.collectionView = collectionView
        self.cell = cell
    }
    
    override func main() {
        
        guard let collectionView = collectionView
            , let cell = self.cell
            , let getCacheImage = dependencies[0] as? GetCacheImage
            , let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = collectionView.indexPath(for: cell), newIndexPath == indexPath {
            setImage(image, toCell: cell)
        } else if collectionView.indexPath(for: cell) == nil {
            setImage(image, toCell: cell)
        }
    }
    
    private func setImage(_ image: UIImage, toCell cell: UICollectionViewCell) {
        if let exactCell = cell as? FriendsCollectionCell {
            exactCell.friendPhoto.image = image
        } 
    }
    
}
