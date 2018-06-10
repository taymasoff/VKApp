//
//  UserFriendsDataService.swift
//  VKApp
//
//  Created by Тимур Таймасов on 28.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct UserFriendsDataService {
    
    // MARK: Friends List Get Request
    static func getData() {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/friends.get"
        components.queryItems = [
            URLQueryItem(name: "fields", value: "city, photo_200_orig"),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let friend = json["response"]["items"].compactMap { Friend(json: $0.1)}
                
                RealmRecords.saveUsersData(friends: friend)
                print("Friends data was loaded from internet.")
                
            case .failure(let error):
                
                print(error, "\nCan't get user friends")
                
            }
        }
    }
}
