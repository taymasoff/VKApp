//
//  Group.swift
//  VKApp
//
//  Created by Тимур Таймасов on 26.02.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Group: Object {
    
    // MARK: - Variables
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = "Group Name"
    @objc dynamic var isUserBelongsTo: Bool = false
    @objc dynamic var subscribers: Int = 0
    @objc dynamic var photoURL: String = ""
    
    // MARK: - Initialization
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.subscribers = json["members_count"].intValue
        self.isUserBelongsTo = json["is_member"].boolValue
        self.photoURL = json["photo_200"].stringValue
        
    }
    
    @objc open override class func primaryKey() -> String? {
        return "id"
    }
    
}

