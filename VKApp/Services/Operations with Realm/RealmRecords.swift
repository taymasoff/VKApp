//
//  RealmRecords.swift
//  VKApp
//
//  Created by Тимур Таймасов on 28.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import RealmSwift

class RealmRecords {
    
    // MARK: - Records
    
    static func saveUsersData(friends: [Friend]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(friends, update: true)
            }
        } catch {
            print("Realm Error: ", error.localizedDescription)
        }
    }
    
    static func saveUsersData(groups: [Group]) {
        do {
            let realm = try Realm()
            let oldGroups = realm.objects(Group.self)
            try realm.write {
                realm.delete(oldGroups)
                realm.add(groups)
            }
        } catch {
            print("Realm Error: ", error.localizedDescription)
        }
    }
    
    static func saveUsersData(news: [News]) {
        do {
            let realm = try Realm()
            let oldNews = realm.objects(News.self)
            try realm.write {
                realm.delete(oldNews)
                realm.add(news, update: true)
            }
        } catch {
            print("Realm Error: ", error.localizedDescription)
        }
    }
    
    static func saveUsersData(photos: [Photos]) {
        do {
            let realm = try Realm()
            let oldPhotos = realm.objects(Photos.self)
            try realm.write {
                realm.delete(oldPhotos)
                realm.add(photos)
            }
        } catch {
            print("Realm Error: ", error.localizedDescription)
        }
    }
    
    // MARK: - Removals
    
    static func deleteGroupsObject(id: String) {
        do {
            let realm = try Realm()
            let toDelete = realm.objects(Group.self).filter("id=%@", id)
            try realm.write {
                realm.delete(toDelete)
            }
        } catch {
            print("Realm Error: ", error.localizedDescription)
        }
    }
    
}
