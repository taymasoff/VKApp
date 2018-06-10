//
//  SearchGroupsTableController.swift
//  VKApp
//
//  Created by Тимур Таймасов on 11.03.2018.
//  Copyright © 2018 Timur Taymasov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SearchGroupsTableController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Variables
    
    private lazy var ref = Database.database().reference()
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    var searchedGroups = [Group]()
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 80.0
        
        searchBar.delegate = self
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        
    }
    
    // MARK: -  Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchedGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "searchGroupCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchGroupsTableCell else {
            fatalError("The dequeued cell is not an instance of SubGroupsTableCell")
        }
        
        var groupCell: Group!
        
        groupCell = searchedGroups[indexPath.row]
        
        cell.group = groupCell
        
        cell.searchGroupImage.setRounded()
        
        cell.fButton = {
            if groupCell.isUserBelongsTo == false {
                UserGroupsDataService.joinGroup(groupCell.id) { result in
                    if result == 1 {
                        let fbUser = FBUser.share
                        
                        if !fbUser.groupsJoined.contains(groupCell.name) {
                            fbUser.groupsJoined.append(groupCell.name)
                            print("Group joined")
                        }
                        
                        self.ref.child("User").setValue(fbUser.toAny)
                        
                    }
                }
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let getCacheImage = GetCacheImage(url: groupCell.photoURL)
        let setImage = SetTableImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
        setImage.addDependency(getCacheImage)
        OperationQueue.main.addOperation(setImage)
        queue.addOperation(getCacheImage)
        
        return cell
    }
    
    // MARK: - UISearchBar Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        
        searchedGroups.removeAll()
        
        view.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        GroupsSearchService.find(scale: "30", searchBy: searchBar.text!) { [weak self] groups in
            self?.searchedGroups = groups
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
    }
    
}
