//
//  LoginWebViewController.swift
//  VKApp
//
//  Created by Тимур Таймасов on 02.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import WebKit
import FirebaseAuth
import FirebaseDatabase

class LoginWebViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Variables
    
    private lazy var ref = Database.database().reference()
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.load(VKApiAuthorization.authRequest)
        
        // firebaseAuth()
    }
    
    // MARK: - Private Methods
    // Пока не используется
//    private func firebaseAuth() {
//        //user1@gmail.com 123456 || user2@gmail.com 654321
//        Auth.auth().signIn(withEmail: "user1@gmail.com", password: "123456") { (user, error) in
//            if let user = user {
//                let fbUser = FBUser.share
//
//                fbUser.uid = user.uid
//                fbUser.email = user.email!
//
//                self.ref.child("User")
//            }
//        }
//    }
    
}

extension LoginWebViewController: WKNavigationDelegate {
    
    // MARK: Receiving a token
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) {result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        
        if let token = params["access_token"] {
            
            VKApi.access_token = token
            performSegue(withIdentifier: "loginSuccess", sender: nil)
        }
        decisionHandler(.allow)
        
        
    }
    
}
