//
//  MyTableViewController.swift
//  lesson3tableviews
//
//  Created by Maxim on 23.01.18.
//  Copyright © 2018 Maxim Ivunin. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController
{
    var dataContent = [""]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataContent = ["entry1", "entry2", "entry3", "entry4", "entry5"]
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "SECTION 1" : "SECTION2"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? dataContent.count : 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MyTableViewCell
        
        cell.leftTitle.text = "\(dataContent[indexPath.row])"
        cell.rightTitle.text = "# \(indexPath.row)"
        cell.imageView?.image = UIImage(named: "icon")

        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toCollectionSegue" {
            let cell = sender as! MyTableViewCell
            
            let indexPath = self.tableView.indexPath(for: cell)
            let index = indexPath?.row
            
            let collectionVC = segue.destination as! MyCollectionViewController
            
            collectionVC.tableData = dataContent[index!]
            
        }
    }
    

}
