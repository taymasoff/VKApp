//
//  Utils.swift
//  VKApp
//
//  Created by Тимур Таймасов on 16.05.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Foundation

let fetchNewFriendsGroup = DispatchGroup()
var timer: DispatchSourceTimer?
var lastUpdate: Date? {
    get {
        return UserDefaults.standard.object(forKey: "Last Update") as? Date
    }
    set {
        UserDefaults.standard.setValue(Date(), forKey: "Last Update")
    }
}
