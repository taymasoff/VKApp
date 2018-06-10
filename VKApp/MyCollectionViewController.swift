//
//  MyCollectionViewController.swift
//  lesson3tableviews
//
//  Created by Maxim on 23.01.18.
//  Copyright © 2018 Maxim Ivunin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionCell"

class MyCollectionViewController: UICollectionViewController {

    var tableData: String = ""
    
    var dataContent = ["entry1", "entry2", "entry3", "entry4", "entry5"]

    // MARK: UICollectionViewDataSource

    override func viewDidLoad() {
        super.viewDidLoad()
        print("data received \(self.tableData)")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataContent.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
    
        cell.centerImage.image = UIImage(named:"icon")
        cell.centerLabel.text = "\(dataContent[indexPath.row])"
    
        return cell
    }
}
