//
//  FBUser.swift
//  VKApp
//
//  Created by Тимур Таймасов on 16.04.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Foundation

class FBUser {
    
    static let share = FBUser()
    
    private init() {}
    
    var uid = ""
    var email = ""
    var groupsJoined = [nil] as [String?]
    
    var toAny: Any {
        return [
            "Id": uid,
            "Email": email,
            "Groups_joined": groupsJoined
        ]
    }
}
