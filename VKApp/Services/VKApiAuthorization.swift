//
//  VKApiAuthorization.swift
//  VKApp
//
//  Created by Тимур Таймасов on 07.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import Alamofire

struct VKApiAuthorization {
    
    private init() {}
    
    // MARK: Authorize via VK Api
    static var authRequest: URLRequest {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth.vk.com"
        components.path = "/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "\(VKApi.app_id)"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            // Права доступа к: Friends (+2), Groups (+262144), Wall (+8192), Photos (+4)
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.73")
        ]
        
        return URLRequest(url: components.url!)
        
    }
    
    // TODO: - Доделать Logout [Не работает вариант с куки]
    
//    static func logout() {
//
//        // Чистим куки чтобы после перезагрузки веб вью выходило окно логина
//        let storage = HTTPCookieStorage.shared
//        for cookie in storage.cookies! {
//            storage.deleteCookie(cookie)
//        }
//
//    }
    
}
