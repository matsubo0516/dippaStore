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
    
    let sectionTitle:[String] = ["店舗名","住所","電話番号","営業時間","内装写真","外装写真" ]
    var content = [[String]]()
    var selectedTitle = ""
    var selectedcontent = ""
    
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShopTableView.delegate = self
        ShopTableView.dataSource = self
        
        for _ in 0 ... 5{
            content.append([])
        }
        
        content[0] = [userDefaults.object(forKey: "name") as! String]
        content[1] = [userDefaults.object(forKey: "adress") as! String]
        content[2] = [userDefaults.object(forKey: "phone") as! String]
        content[3] = [userDefaults.object(forKey: "hours1") as! String,
                      userDefaults.object(forKey: "hours2") as! String,
                      userDefaults.object(forKey: "hours3") as! String,
                      userDefaults.object(forKey: "hours4") as! String,
                      userDefaults.object(forKey: "hours5") as! String,
                      userDefaults.object(forKey: "hours6") as! String,
                      userDefaults.object(forKey: "hours7") as! String,
                      userDefaults.object(forKey: "hours8") as! String]
        
//        画像の受け渡しまでいけてない。
        content[4] = []
        content[5] = []
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content[section].count
        //        switch section {
//        case 0:
//            return 1
//        case 1:
//            return 1
//        case 2:
//            return 1
//        case 3:
//            return 7
//        case 4:
//            return 1
//        case 5:
//            return 1
//        default:
//            return 1
//        }
//    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopTableViewCell", for: indexPath)
        cell.textLabel?.text = self.content[indexPath.section][indexPath.row]
        return cell
    }
        
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopTableViewCell", for: indexPath)
//        cell.textLabel?.text = self.content[indexPath.section][indexPath.row]
//switch indexPath.section {
//        case 0:
//            cell.textLabel?.text = "0"
//        case 1:
//            cell.textLabel?.text = "0"
//        case 2:
//            cell.textLabel?.text = "0"
//        case 3:
//            cell.textLabel?.text = "7"
//        case 4:
//            cell.textLabel?.text = "0"
//        case 5:
//            cell.textLabel?.text = "0"
//        default:
//            break
//        }
//
//        return cell
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = sectionTitle[indexPath.section]
        selectedcontent = content[indexPath.section][indexPath.row]
    }
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
//        guard let identifier = segue.identifier else {
//            return
//        }
//        if identifier == "editShop" {
//        ここから先の書き方がわからない。
//
//        }
    }
}
