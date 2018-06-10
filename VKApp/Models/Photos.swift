//
//  Photos.swift
//  VKApp
//
//  Created by Тимур Таймасов on 21.04.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Photos: Object {
    
    // MARK: - Variables
    
    @objc dynamic var id: String = ""
    @objc dynamic var photoURL: String = ""
    
    // MARK: - Initialization
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.photoURL = json["photo_604"].stringValue
        
    }
    
    @objc open override class func primaryKey() -> String? {
        return "id"
    }
    
}
