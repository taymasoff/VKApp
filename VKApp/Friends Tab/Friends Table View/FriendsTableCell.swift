//
//  FriendsTableViewCell.swift
//  VKApp
//
//  Created by Тимур Таймасов on 26.02.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit

class FriendsTableCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendCity: UILabel!
    
    // MARK: - Properties
    
    var user: Friend? {
        didSet {
            friendName.text = user?.name
            friendCity.text = user?.city
        }
    }
    
}
