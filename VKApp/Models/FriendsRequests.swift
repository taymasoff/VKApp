//
//  FriendsRequests.swift
//  VKApp
//
//  Created by Тимур Таймасов on 16.05.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class FriendsRequests: Object {
    
    // MARK: - Variables
    
    @objc dynamic var id: String = ""
    
    // MARK: - Initialization
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["user_id"].stringValue
    }
    
    @objc open override class func primaryKey() -> String? {
        return "id"
    }
    
}
