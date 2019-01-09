//
//  MenuSelectViewController.swift
//  dippa_store2
//
//  Created by 松本直樹 on 2019/01/01.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit
import Firebase

class MenuSelectViewController: UITableViewController {
    
    // UserDefaults
    let userDefaults = UserDefaults.standard
    var memos: [[String: String]] = [[:]]
    
    var defaultStore : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userDefaults.object(forKey: "memos") != nil {
            self.memos = self.userDefaults.array(forKey: "memos") as! [[String : String]]
        } else {
            self.memos = [
                ["title": "カレー", "detail": "810円"],
                ["title": "ハンバーグ", "detail": "700円"],
                ["title": "ラーメン", "detail": "750円"]
            ]
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        defaultStore = Firestore.firestore()
        
        defaultStore.collection("Tea").document("Darjeeling").setData([
            "ProducingArea": "India",
            "TeaLeaf": "OP"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
//        let data: [String: Any] = [
//            "String": "string",
//            "Boolean": true,
//            "Number": 0.123456789,
//            "Date": Date(),
//            "Array": ["array", 1, false],
//            "Null": NSNull(),
//            "Object": [
//                "obj1": 2,
//                "obj2": ["nest": "nestObj"]
//            ]
//        ]
//        
//        defaultStore.collection("data").document("example").setData(data) { err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
        
        let ref = defaultStore.collection("Tea").document("Darjeeling")
        
        ref.updateData(["ProducingArea" : "Japan"]){ err in
            if let err  = err {
                print("Error update document: \(err)")
            }else{
                print("Document successfully update")
            }
        }
        
        defaultStore.collection("Tea").document("Darjeeling").delete(){ err in
            if let err = err{
                print("Error removing document: \(err)")
            }else{
                print("Document successfully removed!")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToMemoList(sender: UIStoryboardSegue) {
        guard let sourceVC = sender.source as? MenuViewController else {
            return
        }
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            self.memos[selectedIndexPath.row] = sourceVC.menu
        } else {
            self.memos.append(sourceVC.menu)
        }
        self.userDefaults.set(self.memos, forKey: "memos")
        self.tableView.reloadData()
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
            self.memos.remove(at: indexPath.row)
            self.userDefaults.set(self.memos, forKey: "memos")
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
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "editMenu" {
            let memoVC = segue.destination as! MenuViewController
            memoVC.menu = self.memos[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    
    }
}
