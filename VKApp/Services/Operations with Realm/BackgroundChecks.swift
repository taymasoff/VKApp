//
//  BackgroundChecks.swift
//  VKApp
//
//  Created by Тимур Таймасов on 16.05.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import RealmSwift

class BackgroundChecks {
    
    static func checkForFriendRequests(_ data: [FriendsRequests]) {
        do {
            let realm = try Realm()
            let oldRequests = realm.objects(FriendsRequests.self)
            try realm.write {
                realm.delete(oldRequests)
                realm.add(data)
            }
            print("Record success \(Thread.current)")
        } catch {
            print("Realm Error: ", error.localizedDescription)
        }
        NotificationCenter.default.post(name: Notification.Name("refresh"), object: nil)
        if timer != nil {
            fetchNewFriendsGroup.leave()
            print("Fetch left")
        }
    }
    
}
