//
//  UserPhotosDataService.swift
//  VKApp
//
//  Created by Тимур Таймасов on 21.04.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct UserPhotosDataService {
    
    // MARK: User Photos by UserID Get Request
    static func getData(ownerID: String) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/photos.getAll"
        components.queryItems = [
            URLQueryItem(name: "fields", value: ""),
            URLQueryItem(name: "owner_id", value: "\(ownerID)"),
            URLQueryItem(name: "photo_sizes", value: "0"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.74")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let photos = json["response"]["items"].compactMap { Photos(json: $0.1)}
                
                RealmRecords.saveUsersData(photos: photos)
                print("Friends data was loaded from internet.")
                
            case .failure(let error):
                
                print(error, "\nCan't get user photos")
                
            }
        }
    }
}
