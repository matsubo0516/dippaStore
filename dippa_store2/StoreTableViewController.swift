//
//  StoreTableViewController.swift
//  dippa_store2
//
//  Created by 松本直樹 on 2019/01/06.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

class StoreTableViewController: UITableViewController {
    
        var mySections = [String]()
        var twoDimArray = [[String]]()
        var selectedClass = ""
        var selectedPerson = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            mySections = ["3年A組","3年B組","3年C組"]
            
            for _ in 0 ... 2{
                twoDimArray.append([])
            }
            
            twoDimArray[0] = ["井上","加藤","田中"]
            twoDimArray[1] = ["鈴木","吉田"]
            twoDimArray[2] = ["遠藤","佐藤","村田","山田"]
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return mySections.count
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return twoDimArray[section].count
        }
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return mySections[section]
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Reuse", for: indexPath)
            cell.textLabel?.text = twoDimArray[indexPath.section][indexPath.row]
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedClass = mySections[indexPath.section]
            selectedPerson = twoDimArray[indexPath.section][indexPath.row]
        }
        
    }
