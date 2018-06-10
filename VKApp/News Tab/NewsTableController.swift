//
//  NewsTableController.swift
//  VKApp
//
//  Created by Тимур Таймасов on 28.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import RealmSwift
import Social

class NewsTableController: UITableViewController, IsAllowedToScrollDelegate {
    
    // MARK: - Variables
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    var news: Results<News> = {
        let realm = try! Realm()
        return realm.objects(News.self)
    }()
    
    private var token: NotificationToken?
    deinit {
        token?.invalidate()
    }
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(NewsTableController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.tintColor = Colors.twitterBlue
        
        loadNewsData()
    }
    
    // MARK: -  TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "newsTableCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableCell else {
            fatalError("The dequeued cell is not an instance of NewsTableCell")
        }
        
        var newsCell: News!
        
        newsCell = news[indexPath.row]
        
        cell.news = newsCell
        
        cell.postAuthorImg.setRounded()

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let getCacheImage = GetCacheImage(url: newsCell.postAuthorPhotoURL)
        let setImage = SetTableImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
        setImage.addDependency(getCacheImage)
        OperationQueue.main.addOperation(setImage)
        queue.addOperation(getCacheImage)
        
        if newsCell.postPhotoURL == "" {
            cell.postImage.isHidden = true
        } else {
            cell.postImage.isHidden = false
            let getPostImage = GetCacheImage(url: newsCell.postPhotoURL)
            getPostImage.completionBlock = {
                OperationQueue.main.addOperation { 
                    cell.postImage.image = getPostImage.outputImage
                }
            }
            queue.addOperation(getPostImage)
        }
        
        return cell
    }
    
    // MARK: - UIRefreshControl
    
    @objc func handleRefresh (_ refreshControl: UIRefreshControl) {
        
        NewsService.getData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - IsAllowedToScroll Delegate
    
    func isAllowedToScroll(_ bool: Bool) {
        tableView.isScrollEnabled = bool
        print("News Table View Scroll is set to:", bool)
    }
    
    // MARK: - Private Methods
    
    private func loadNewsData() {
        pairNewsWithRealm()
        NewsService.getData()
    }
    
    private func pairNewsWithRealm() {
        token = news.observe({ [weak self] change in
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
    
    // MARK: - Actions

    // FIXME: - Memory Problems
    @IBAction func createNewPost(_ sender: Any) {
        
        let newPostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newPost") as! NewPostPopUpVC
        self.addChildViewController(newPostVC)
        newPostVC.view.frame = self.view.frame
        self.view.addSubview(newPostVC.view)
        
        let offset = self.tableView.contentOffset
        let w = self.view.bounds.width
        let h = self.view.bounds.height
        newPostVC.view.center = CGPoint(x: w/2, y: h/2+offset.y)
        
        
        newPostVC.didMove(toParentViewController: self)
        newPostVC.delegate = self
    }

}

    
    



