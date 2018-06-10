//
//  FriendsTableViewController.swift
//  VKApp
//
//  Created by Тимур Таймасов on 26.02.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift
import WatchConnectivity
import GoogleMobileAds

class FriendsTableController: UITableViewController, UISearchBarDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    var wcSession: WCSession?
    
    var bannerView: GADBannerView!
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    var friends: Results<Friend> = {
        let realm = try! Realm()
        return realm.objects(Friend.self)
    }()
    
    private var token: NotificationToken?
    deinit {
        token?.invalidate()
    }
    
    private var isSearching = false
    private var filteredFriends = [Friend]()
    
    private var username: String?
    private var userID: String?
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 80.0
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(FriendsTableController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.tintColor = Colors.twitterBlue
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        
        loadFriendsData()
        loadDataForExtensions()
        wcSessionSetup()
        bannerViewSetup()
    }
    
    // MARK: -  Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if isSearching {
            return filteredFriends.count
        } else {
            return friends.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "friendTableCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FriendsTableCell else {
            fatalError("The dequeued cell is not an instance of FriendsTableCell")
        }
        
        var friendCell: Friend!
        
        if isSearching {
            friendCell = filteredFriends[indexPath.row]
        } else {
            friendCell = friends[indexPath.row]
        }
        
        cell.user = friendCell
        
        let getCacheImage = GetCacheImage(url: friendCell.photoURL)
        let setImage = SetTableImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
        setImage.addDependency(getCacheImage)
        OperationQueue.main.addOperation(setImage)
        queue.addOperation(getCacheImage)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFriend = friends[indexPath.row]

        username = selectedFriend.name
        userID = selectedFriend.id

        performSegue(withIdentifier: "go", sender: self)
    }

    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        
        isSearching = false
        view.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            isSearching = false
            view.endEditing(true)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } else {
            isSearching = true
            filteredFriends = friends.filter({ (friend: Friend) -> Bool in
                friend.name.localizedCaseInsensitiveContains(searchBar.text!)
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UIRefreshControl
    
    @objc func handleRefresh (_ refreshControl: UIRefreshControl) {
        
        UserFriendsDataService.getData()
        refreshControl.endRefreshing()
    }
    
    // MARK: -  Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            let vc = segue.destination as! FriendsCollectionController
            vc.username = username
            vc.userID = userID
        }
    }
    
    // MARK: - Private Methods
    
    private func loadFriendsData() {
        
        pairFriendsWithRealm()
        
        if friends.isEmpty {
            UserFriendsDataService.getData()
        }
    }
    
    private func pairFriendsWithRealm() {
        token = friends.observe({ [weak self] change in
            guard let table = self?.tableView else {
                return
            }
            switch change {
            case RealmCollectionChange.initial:
                table.reloadData()
            case RealmCollectionChange.update(_, let delete, let insert, let update):
                table.performBatchUpdates({
                    table.deleteRows(at: delete.map { IndexPath(row: $0, section:0) }, with: .automatic)
                    table.insertRows(at: insert.map { IndexPath(row: $0, section:0) }, with: .automatic)
                    table.reloadRows(at: update.map { IndexPath(row: $0, section:0) }, with: .automatic)
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func loadDataForExtensions() {
        
        NewsService.getDataForWidget { posts in
            let defaults = UserDefaults(suiteName: "group.timur.taymasov.newsGroup")
            
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
            
            defaults?.set(URLArray, forKey: "URLArray")
            defaults?.set(authorsArray, forKey: "authorsArray")
            defaults?.set(timesArray, forKey: "timesArray")
            defaults?.set(textsArray, forKey: "textsArray")
            defaults?.synchronize()
            
        }
    }
    
    private func wcSessionSetup() {
        if WCSession.isSupported() {
            wcSession = WCSession.default
            wcSession?.delegate = self
            wcSession?.activate()
        }
    }
    
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    private func bannerViewSetup() {
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
}

extension FriendsTableController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        guard message["request"] as? String == "token" else { return }
        
        replyHandler(["token" : VKApi.access_token as Any])
        
    }
}
