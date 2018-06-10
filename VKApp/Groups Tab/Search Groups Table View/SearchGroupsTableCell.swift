//
//  SearchGroupsTableCell.swift
//  VKApp
//
//  Created by Тимур Таймасов on 11.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit

class SearchGroupsTableCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var searchGroupImage: UIImageView!
    @IBOutlet weak var searchGroupName: UILabel!
    @IBOutlet weak var searchGroupSubscribers: UILabel!
    @IBOutlet weak var followButton: FollowButton!
    
    // MARK: - Variables
    
    var fButton : (() -> Void)? = nil
    
    var group: Group? {
        didSet {
            
            searchGroupName.text = group?.name
            if let subs = group?.subscribers {
                searchGroupSubscribers.text = "\(subs) subscribers"
            } else {
                searchGroupSubscribers.text = " "
            }
            if let userInGroup = group?.isUserBelongsTo {
                followButton.activateButton(bool: userInGroup)
            }
            
        }
    }
    
    // MARK: - Actions
    
    @IBAction func followButtonPressed(_ sender: FollowButton) {
        if let followButtonPressed = self.fButton {
            followButtonPressed()
        }
    }

}
