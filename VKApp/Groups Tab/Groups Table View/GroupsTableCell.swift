//
//  TableViewCell.swift
//  VKApp
//
//  Created by Тимур Таймасов on 26.02.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsTableCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupSubscribers: UILabel!
    @IBOutlet weak var followButton: FollowButton!
    
    // MARK: - Properties

    var fButton : (() -> Void)? = nil
    
    var group: Group? {
        didSet {
        
            groupName.text = group?.name
            if let userInGroup = group?.isUserBelongsTo {
                followButton.activateButton(bool: userInGroup)
            }
            if let subs = group?.subscribers {
                groupSubscribers.text = "\(subs) subscribers"
            } else {
                groupSubscribers.text = " "
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



