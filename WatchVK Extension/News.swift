//
//  News.swift
//  WatchVK Extension
//
//  Created by Тимур Таймасов on 05.06.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import SwiftyJSON

class News {
    
    // MARK: - Properties
    
    var postId: Int = 0
    var sourceId: Int = 0
    var postAuthorName: String = ""
    var postAuthorPhotoURL: String = ""
    var postTime: String = ""
    var postText: String = ""
    var postPhotoURL: String = ""
    var likes: Int = 0
    var comments: Int = 0
    var reposts: Int = 0
    var views: Int = 0
    
    var authorSourceId: Int = 0
    var authorName: String = ""
    var authorPhotoURL: String = ""
    
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
    
}
