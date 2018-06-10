//
//  SetImageToRow.swift
//  VKApp
//
//  Created by Тимур Таймасов on 04.04.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit

class SetTableImageToRow: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: UITableViewCell?
    
    init(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        
        guard let tableView = tableView
            , let cell = self.cell
            , let getCacheImage = dependencies[0] as? GetCacheImage
            , let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            setImage(image, toCell: cell)
        } else if tableView.indexPath(for: cell) == nil {
            setImage(image, toCell: cell)
        }
    }
    
    private func setImage(_ image: UIImage, toCell cell: UITableViewCell) {
        if let exactCell = cell as? FriendsTableCell {
            exactCell.friendPhoto.image = image
        } else if let exactCell = cell as? GroupsTableCell {
            exactCell.groupImage.image = image
        } else if let exactCell = cell as? NewsTableCell {
            exactCell.postAuthorImg.image = image
        } else if let exactCell = cell as? SearchGroupsTableCell {
            exactCell.searchGroupImage.image = image
        }
    }
    
}
