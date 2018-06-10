//
//  GroupsSearchService.swift
//  VKApp
//
//  Created by Тимур Таймасов on 29.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct GroupsSearchService {
    
    // MARK: Find Groups by Name Get Request
    static func find(scale count: String, searchBy userSearchInput: String, completion: @escaping (_ groupData: [Group])->Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/groups.search"
        components.queryItems = [
            URLQueryItem(name: "fields", value: "members_count"),
            URLQueryItem(name: "q", value: "\(userSearchInput)"),
            URLQueryItem(name: "count", value: "\(count)"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let group = json["response"]["items"].compactMap { Group(json: $0.1)}
                completion(group)
                
            case .failure(let error):
                print(error, "\nSearch progress failed.")
                
            }
        }
    }
}
