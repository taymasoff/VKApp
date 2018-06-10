//
//  FriendsRequestsService.swift
//  VKApp
//
//  Created by Тимур Таймасов on 16.05.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct FriendsRequestsService {
    
    // MARK: Friend Requests List Get Requests
    static func getData() {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/friends.getRequests"
        components.queryItems = [
            URLQueryItem(name: "out", value: "0"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "need_viewed", value: "0"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.74")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let friends = json["response"]["items"].compactMap { FriendsRequests(json: $0.1) }
                
                BackgroundChecks.checkForFriendRequests(friends)

                print("Friends requests was loaded from internet.")
                
            case .failure(let error):
                
                print(error, "\nCan't get friends requests")
                
            }
        }
    }
}
