//
//  GroupsTableViewController.swift
//  VKApp
//
//  Created by Тимур Таймасов on 26.02.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsTableController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    var groups: Results<Group> = {
        let realm = try! Realm()
        return realm.objects(Group.self)
    }()
    
    private var token: NotificationToken?
    deinit {
        token?.invalidate()
    }
    
    var filteredGroups = [Group]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 80.0
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(GroupsTableController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl?.tintColor = Colors.twitterBlue
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        
        loadGroupsData()
    }
    
    // MARK: -  Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return filteredGroups.count
        } else {
            return groups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "groupTableCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? GroupsTableCell else {
            fatalError("The dequeued cell is not an instance of GroupsTableCell")
        }
        
        var groupCell: Group!

        if isSearching {
            groupCell = filteredGroups[indexPath.row]
        } else {
            groupCell = groups[indexPath.row]
        }
        
        cell.group = groupCell
        
        cell.groupImage.setRounded()
        
        cell.fButton = {
            if groupCell.isUserBelongsTo == true {
                UserGroupsDataService.leaveGroup(groupCell.id) { result in
                    if result == 1 {
                        print("Group Left.")
                        DispatchQueue.main.async {
                            RealmRecords.deleteGroupsObject(id: groupCell.id)
                        }
                    }
                }
            }
        }
        
        let getCacheImage = GetCacheImage(url: groupCell.photoURL)
        let setImage = SetTableImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
        setImage.addDependency(getCacheImage)
        OperationQueue.main.addOperation(setImage)
        queue.addOperation(getCacheImage)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
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
            tableView.reloadData()
            
        } else {
            isSearching = true
            filteredGroups = groups.filter({ (group: Group) -> Bool in
                group.name.localizedCaseInsensitiveContains(searchBar.text!)
            })
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Unwind Action
    
    @IBAction func unwindToGroupsTC(segue: UIStoryboardSegue) { }
    
    // MARK: - UIRefreshControl
    
    @objc func handleRefresh (_ refreshControl: UIRefreshControl) {
        
        UserGroupsDataService.getData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Private Methods
    
    private func loadGroupsData() {
        
        pairGroupsWithRealm()
        
        if groups.isEmpty {
            UserGroupsDataService.getData()
        }
    }
    
    private func pairGroupsWithRealm() {
        token = groups.observe({ [weak self] change in
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
    

    
}

