//
//  MainTabBarController.swift
//  VKApp
//
//  Created by Тимур Таймасов on 16.05.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import RealmSwift

class MainTabBarController: UITabBarController {
    
    // MARK: - Variables
    
    let friendsRequests: Results<FriendsRequests> = {
        let realm = try! Realm()
        return realm.objects(FriendsRequests.self)
    }()
    
    private var token: NotificationToken?
    deinit {
        token?.invalidate()
    }
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairFriendsRequestsWithRealm()
    }
    
    // MARK: - Private Functions
    
    private func pairFriendsRequestsWithRealm() {
        token = friendsRequests.observe({ [weak self] change in
            let tabItems = self?.tabBar.items as NSArray?
            let friendsTab = tabItems![0] as! UITabBarItem

            switch change {
            case RealmCollectionChange.initial:
                
                if let requests = self?.friendsRequests.count {
                    if requests == 0 {
                        friendsTab.badgeValue = nil
                    } else {
                        friendsTab.badgeValue = String(requests)
                    }
                } else {
                    friendsTab.badgeValue = nil
                }

            case RealmCollectionChange.update(_):
                
                if let requests = self?.friendsRequests.count {
                    if requests == 0 {
                        friendsTab.badgeValue = nil
                    } else {
                        friendsTab.badgeValue = String(requests)
                    }
                } else {
                    friendsTab.badgeValue = nil
                }
                
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}
