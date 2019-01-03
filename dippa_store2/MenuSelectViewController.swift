//
//  MenuSelectViewController.swift
//  dippa_store2
//
//  Created by 松本直樹 on 2019/01/01.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

class MenuSelectViewController: UITableViewController {
    
    // UserDefaults
    let userDefaults = UserDefaults.standard
    
    //var memos = ["カレー", "ハンバーグ", "ラーメン"]
    //本当はこうしたかった
//    var memos = [
//        ["title": "カレー", "detail": "810円"],
//        ["title": "ハンバーグ", "detail": "700円"],
//        ["title": "ラーメン", "detail": "750円"]
//    ]
    
    var memos: [String: String] = [:]
    let memo = sourceVC.memo
    
    @IBAction func unwindToMemoList(sender: UIStoryboardSegue) {

        guard let sourceVC = sender.source as? MenuViewController else {
            return
        }
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            self.memos[selectedIndexPath.row] = memo
        } else {
            self.memos.append(memo)
        }
        self.userDefaults.set(self.memos, forKey: "memos")
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userDefaults.object(forKey: "memos") != nil {
            self.memo = self.userDefaults.stringArray(forKey: "memos")!
        } else {
            self.memo =
                ["title": "カレー", "detail": "810円"],
                ["title": "ハンバーグ", "detail": "700円"],
                ["title": "ラーメン", "detail": "750円"]
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.memos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuSelectViewCell", for: indexPath)
        
        // Configure the cell...
        //本当は以下のようにしたかった
        cell.textLabel?.text = self.memos[indexPath.row]["title"]
        cell.detailTextLabel?.text = self.memos[indexPath.row]["detail"]
        
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
        self.memo.remove(at: indexPath.row)
        self.userDefaults.set(self.memo, forKey: "memos")
        tableView.deleteRows(at: [indexPath], with: .fade)
     }
     }

    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "editMenu" {
            let memoVC = segue.destination as! MenuViewController
            memoVC.memo = self.memo[(self.tableView.indexPathForSelectedRow?.row)!]
     }
    
    }
}
