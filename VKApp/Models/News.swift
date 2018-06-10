//
//  News.swift
//  VKApp
//
//  Created by Тимур Таймасов on 29.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class News: Object {
    
    // MARK: - Variables
    
    @objc dynamic var postId: Int = 0
    @objc dynamic var sourceId: Int = 0
    @objc dynamic var postAuthorName: String = ""
    @objc dynamic var postAuthorPhotoURL: String = ""
    @objc dynamic var postTime: String = ""
    @objc dynamic var postText: String = ""
    @objc dynamic var postPhotoURL: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var comments: Int = 0
    @objc dynamic var reposts: Int = 0
    @objc dynamic var views: Int = 0
    
    @objc dynamic var authorSourceId: Int = 0
    @objc dynamic var authorName: String = ""
    @objc dynamic var authorPhotoURL: String = ""
    
    // MARK: - Initialization
    
    convenience init(json: JSON) {
        self.init()
        
        self.postId = json["post_id"].intValue
        self.sourceId = json["source_id"].intValue
        let unixTime = json["date"].doubleValue
        self.postTime = timeAgoSince(unixTime)
        self.postText = json["text"].stringValue
        
        if let photo = json["attachments"][0]["photo"]["photo_604"].string {
            self.postPhotoURL = photo
        } else if let photo = json["attachments"][0]["link"]["photo"]["photo_604"].string {
            self.postPhotoURL = photo
        } else if let photo = json["attachments"][0]["video"]["photo_800"].string {
            self.postPhotoURL = photo
        } else if let photo = json["attachments"][0]["video"]["photo_640"].string {
                self.postPhotoURL = photo
        } else if let photo = json["attachments"][0]["video"]["photo_320"].string {
            self.postPhotoURL = photo
        } else if let photo = json["attachments"][0]["doc"]["preview"]["photo"]["sizes"][2]["src"].string {
            self.postPhotoURL = photo
        } else {
            self.postPhotoURL = ""
        }
    
        self.likes = json["likes"]["count"].intValue
        self.comments = json["comments"]["count"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.views = json["views"]["count"].intValue
        
    }
    
    convenience init(profiles json: JSON) {
        self.init()
        
        self.authorSourceId = json["id"].intValue
        self.authorName = "\(json["first_name"].stringValue) \(json["last_name"])"
        self.authorPhotoURL = json["photo_50"].stringValue
    }
    
    convenience init(groups json: JSON) {
        self.init()
        
        self.authorSourceId = json["id"].intValue
        self.authorName = json["name"].stringValue
        self.authorPhotoURL = json["photo_50"].stringValue
    }
    
    @objc open override class func primaryKey() -> String? {
        return "postId"
    }
    
}
