//
//  MessagesViewController.swift
//  iMessage
//
//  Created by Тимур Таймасов on 02.06.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: - Variables
    
    var defaults = UserDefaults(suiteName: "group.timur.taymasov.newsGroup")
    
    // MARK: - Outlets
    
    @IBOutlet weak var postAuthorImage: UIImageView!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLastPost()
    }
    
    // MARK: - Private Methods
    
    private func loadLastPost() {
        if let URLArray = defaults?.array(forKey: "URLArray") {
            postAuthorImage.downloadedFrom(link: URLArray.first as! String)
        }
        if let authorsArray = defaults?.array(forKey: "authorsArray") {
            postAuthorLabel.text = authorsArray.first as? String
        }
        
        if let timesArray = defaults?.array(forKey: "timesArray") {
            postTimeLabel.text = timesArray.first as? String
        }
        
        if let textsArray = defaults?.array(forKey: "textsArray") {
            postTextLabel.text = textsArray.first as? String
        }
    }
    
    // MARK: - Actions
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        let layout = MSMessageTemplateLayout()
        layout.image = postAuthorImage.image
        layout.imageTitle = postAuthorLabel.text
        layout.imageSubtitle = postTimeLabel.text
        layout.caption = postTextLabel.text
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
        dismiss()
    }
    

}


// MARK: - Image Downloader
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
