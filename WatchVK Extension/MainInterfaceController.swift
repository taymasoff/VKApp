//
//  MainInterfaceController.swift
//  WatchVK Extension
//
//  Created by Тимур Таймасов on 03.06.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import WatchKit
import WatchConnectivity

class MainInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var lastPostAuthorImage: WKInterfaceImage!
    @IBOutlet var lastPostAuthorName: WKInterfaceLabel!
    @IBOutlet var lastPostTime: WKInterfaceLabel!
    @IBOutlet var lastPostText: WKInterfaceLabel!
    
    // MARK: - Variables
    
    var wcSession: WCSession?
    
    // MARK: - Properties
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession?.delegate = self
            wcSession?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        guard activationState == .activated else {
            lastPostAuthorName.setText("Can't connect")
            return
        }
        
        print("Session started")
        wcSession?.sendMessage(["request":"token"], replyHandler: { reply in
            print("Session got reply")
            NewsService.getDataForWidget(token: reply["token"] as! String) { posts in
                print("Service started")
                let URLArray = posts.map({ (post: News!) -> String in
                    post.postAuthorPhotoURL
                })
                let authorsArray = posts.map({ (post: News!) -> String in
                    post.postAuthorName
                })
                let timesArray = posts.map({ (post: News!) -> String in
                    post.postTime
                })
                let textsArray = posts.map({ (post: News!) -> String in
                    post.postText
                })
                
                print("Preparing to update UI")
                DispatchQueue.main.async {
                    self.update(url: URLArray.first!, name: authorsArray.first!, time: timesArray.first!, text: textsArray.first!)
                }
                
            }
        }, errorHandler: { err in
            print("Session error", err.localizedDescription)
        })
    }
    
    // MARK: - Private Methods
    
    private func update(url: String, name: String, time: String, text: String) {
        lastPostAuthorImage.imageFromUrl(url)
        lastPostAuthorName.setText(name)
        lastPostTime.setText(time)
        lastPostText.setText(text)
        print("UI updated")
    }
    
    // MARK: - Actions
    
    @IBAction func showMoreButtonPressed() {}
    
}

// Image Downloader
extension WKInterfaceImage {
    public func imageFromUrl(_ urlString: String) {
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url as URL)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                if let imageData = data as Data? {
                    DispatchQueue.main.async {
                        self.setImageData(imageData)
                    }
                }
            });
            task.resume()
        }
    }
}
