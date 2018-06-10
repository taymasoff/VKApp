//
//  NewsService.swift
//  VKApp
//
//  Created by Тимур Таймасов on 29.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Alamofire
import SwiftyJSON

struct NewsService {
    
    // MARK: Newsfeed Get Request
    static func getData() {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/newsfeed.get"
        components.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "count", value: ""),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.74")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let posts = json["response"]["items"].compactMap { News(json: $0.1) }
                let groups = json["response"]["groups"].compactMap { News(groups: $0.1) }
                let profiles = json["response"]["profiles"].compactMap { News(profiles: $0.1) }
                
                
                for i in 0..<posts.count {
                    if posts[i].sourceId < 0 {
                        for id in 0..<groups.count {
                            if posts[i].sourceId * -1 == groups[id].authorSourceId {
                                posts[i].authorSourceId = groups[id].authorSourceId
                                posts[i].postAuthorName = groups[id].authorName
                                posts[i].postAuthorPhotoURL = groups[id].authorPhotoURL
                            }
                        }
                    } else {
                        for id in 0..<profiles.count {
                            if posts[i].sourceId == profiles[id].authorSourceId {
                                posts[i].authorSourceId = profiles[id].authorSourceId
                                posts[i].postAuthorName = profiles[id].authorName
                                posts[i].postAuthorPhotoURL = profiles[id].authorPhotoURL
                            }
                        }
                    }
                }
                
                RealmRecords.saveUsersData(news: posts)
                print("News data was loaded from internet.")
                
            case .failure(let error):
                
                print(error, "\nCan't get news data")
                
            }
            
        }
    }
    
    // MARK: 20 Last Posts from Newsfeeed Get Request (Used for extensions)
    static func getDataForWidget(completion: @escaping (_ posts: [News?]) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/newsfeed.get"
        components.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.74")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let posts = json["response"]["items"].compactMap { News(json: $0.1) }
                let groups = json["response"]["groups"].compactMap { News(groups: $0.1) }
                let profiles = json["response"]["profiles"].compactMap { News(profiles: $0.1) }
                
                
                for i in 0..<posts.count {
                    if posts[i].sourceId < 0 {
                        for id in 0..<groups.count {
                            if posts[i].sourceId * -1 == groups[id].authorSourceId {
                                posts[i].authorSourceId = groups[id].authorSourceId
                                posts[i].postAuthorName = groups[id].authorName
                                posts[i].postAuthorPhotoURL = groups[id].authorPhotoURL
                            }
                        }
                    } else {
                        for id in 0..<profiles.count {
                            if posts[i].sourceId == profiles[id].authorSourceId {
                                posts[i].authorSourceId = profiles[id].authorSourceId
                                posts[i].postAuthorName = profiles[id].authorName
                                posts[i].postAuthorPhotoURL = profiles[id].authorPhotoURL
                            }
                        }
                    }
                }
        
                completion(posts)
                print("News data was loaded from internet.")
                
            case .failure(let error):
                
                print(error, "\nCan't get news data")
                
            }
            
        }
    }
    
    // MARK: Create New Post with Text Get Request
    static func newPost(text: String) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/wall.post"
        components.queryItems = [
            URLQueryItem(name: "message", value: "\(text)"),
            URLQueryItem(name: "access_token", value: "\(VKApi.access_token)"),
            URLQueryItem(name: "v", value: "5.74")
        ]
        
        Alamofire.request(components.url!, method: .get).validate().responseJSON(queue: DispatchQueue.global()) { response in
            
            switch response.result {
            
            case .success(_):
                
                print("Post created")
            
            case .failure(let error):
                
                print(error, "\nError while trying to create a post")
                
            }
        }
    }
    
}
