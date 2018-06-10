//
//  Friends.swift
//  VKApp
//
//  Created by Тимур Таймасов on 26.02.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Friend: Object {
    
    // MARK: - Variables
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = "Name Surname"
    @objc dynamic var city: String = "City"
    @objc dynamic var photoURL: String = ""
    
    // MARK: - Initialization
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.name = "\(json["first_name"]) \(json["last_name"])"
        self.city = json["city"]["title"].stringValue
        self.photoURL = json["photo_200_orig"].stringValue
        
    }
    
    @objc open override class func primaryKey() -> String? {
        return "id"
    }
    
}
