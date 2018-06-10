//
//  UserGroupsDataService.swift
//  VKApp
//
//  Created by Тимур Таймасов on 29.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct UserGroupsDataService {

    // MARK: Groups List Get Request
    static func getData() {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/groups.get"
        components.queryItems = [
            URLQueryItem(name: "fields", value: "members_count"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let group = json["response"]["items"].compactMap { Group(json: $0.1)}
                
                RealmRecords.saveUsersData(groups: group)
                print("Groups data was loaded from internet.")
                
            case .failure(let error):
                
                print(error, "\nCan't get user groups")
                
            }
            
        }
    }
    
    // MARK: Leave the Group by GroupID Get Request
    static func leaveGroup(_ groupID: String, completion: @escaping (_ result: Int)->Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/groups.leave"
        components.queryItems = [
            URLQueryItem(name: "group_id", value: "\(groupID)"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let result = json["response"].intValue
                completion(result)
                
            case .failure(let error):
                
                print(error, "\nRequest error.")
                
            }
        }
    }
    
    // MARK: Join the Group by GroupID Get Request
    static func joinGroup(_ groupID: String, completion: @escaping (_ result: Int)->Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/groups.join"
        components.queryItems = [
            URLQueryItem(name: "group_id", value: "\(groupID)"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let result = json["response"].intValue
                completion(result)
                
            case .failure(let error):
                
                print(error, "\nRequest error.")
                
            }
        }
    }
}
