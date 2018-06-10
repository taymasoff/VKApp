//
//  TodayViewController.swift
//  VKNews
//
//  Created by Тимур Таймасов on 28.05.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Variables
    
    var defaults = UserDefaults(suiteName: "group.timur.taymasov.newsGroup")
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - TableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = defaults?.array(forKey: "URLArray")?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "todayTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TodayTableViewCell else {
            fatalError("The dequeued cell is not an instance of TodayTableViewCell")
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.postAuthorImage.layer.cornerRadius = (cell.postAuthorImage.frame.width / 2)
        cell.postAuthorImage.layer.masksToBounds = true
        
        
        if let URLArray = defaults?.array(forKey: "URLArray") {
            cell.postAuthorImage.downloadedFrom(link: URLArray[indexPath.row] as! String)
        }
        
        if let authorsArray = defaults?.array(forKey: "authorsArray") {
            cell.postAuthorName.text = authorsArray[indexPath.row] as? String
        }
        
        if let timesArray = defaults?.array(forKey: "timesArray") {
            cell.postTime.text = timesArray[indexPath.row] as? String
        }
        
        if let textsArray = defaults?.array(forKey: "textsArray") {
            cell.postHeader.text = textsArray[indexPath.row] as? String
        }
        
        return cell
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
