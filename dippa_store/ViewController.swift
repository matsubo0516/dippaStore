//
//  ViewController.swift
//  dippa_store
//
//  Created by 松本直樹 on 2018/12/08.
//  Copyright © 2018年 松本直樹. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // SearchBarのdelegateの通知先を設定
        searchText.delegate = self
        // プレースホルダの設定
        searchText.placeholder = "検索したいメニュー名を入力してください"
    }
    
    /// 検索をタップ時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        // キーボードを閉じる
        view.endEditing(true)
    
        if let searchWord = searchBar.text{
            // デバックエリアに出力
            print(searchWord)
        }
    }
}

