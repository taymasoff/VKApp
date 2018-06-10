//
//  FriendsCollectionViewController.swift
//  VKApp
//
//  Created by Тимур Таймасов on 26.02.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class FriendsCollectionController: UICollectionViewController {
    
    // MARK: - Variables
    
    var username: String?
    var userID: String?
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    var photos: Results<Photos> = {
        let realm = try! Realm()
        return realm.objects(Photos.self)
    }()
    
    private var token: NotificationToken?
    deinit {
        token?.invalidate()
    }
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    // MARK: Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        self.navigationItem.title = username
        
        loadPhotosData()
    }

    // MARK: - UICollectionView Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "friendCollectionCell"
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? FriendsCollectionCell else {
            fatalError("The dequeued cell is not an instance of FriendsCollectionCell")
        }
        
        let photosCell = photos[indexPath.row]
        
        cell.layer.borderWidth = 0
        cell.frame.size.width = screenWidth / 3
        cell.frame.size.height = screenWidth / 3
        
        let getCacheImage = GetCacheImage(url: photosCell.photoURL)
        let setImage = SetCollectionImageToRow(cell: cell, indexPath: indexPath, collectionView: collectionView)
        setImage.addDependency(getCacheImage)
        OperationQueue.main.addOperation(setImage)
        queue.addOperation(getCacheImage)
        
        return cell
    }
    
    // MARK: - Private Methods
    
    private func loadPhotosData() {
        
        pairPhotosWithRealm()
        
        UserPhotosDataService.getData(ownerID: userID!)
    }
    
    private func pairPhotosWithRealm() {
        token = photos.observe({ [weak self] change in
            guard let collection = self?.collectionView else {
                return
            }
            switch change {
            case RealmCollectionChange.initial:
                collection.reloadData()
            case RealmCollectionChange.update(_, let delete, let insert, let update):
                collection.performBatchUpdates({
                    collection.deleteItems(at: delete.map { IndexPath(row: $0, section:0) })
                    collection.insertItems(at: insert.map { IndexPath(row: $0, section:0) })
                    collection.reloadItems(at: update.map { IndexPath(row: $0, section:0) })
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }

}
