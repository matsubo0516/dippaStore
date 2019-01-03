//
//  ShopViewController.swift
//  dippa_store2
//
//  Created by 松本直樹 on 2019/01/02.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ShopTableView: UITableView!
    
    let content:[String] = ["店舗名","住所","電話番号","営業時間","内装写真","外装写真" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return content.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return content[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 0
        case 3:
            return 7
        case 4:
            return 0
        case 5:
            return 0
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShopTableViewCell", forIndexPath: IndexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = 0
        case 1:
            cell.textLabel?.text = 0
        case 2:
            cell.textLabel?.text = 0
        case 3:
            cell.textLabel?.text = 7
        case 4:
            cell.textLabel?.text = 0
        case 5:
            cell.textLabel?.text = 0
        default:
            break
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
