//
//  MenusViewController.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/07.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit
import FirebaseFirestore
import PKHUD

class MenusViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private var firestore: Firestore {
        return Firestore.firestore()
    }

    var menus: [Menu] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.tableFooterView = UIView()

        loadMenus(completion: { (menus) in
            self.menus = menus
            self.tableView.reloadData()
            HUD.hide()
        })
    }

    private func loadMenus(completion: @escaping (([Menu]) -> Void)) {
        HUD.show(.progress, onView: view)

        // firestoreにアクセスする(getDocuments)
        var menus: [Menu] = []
        let collectionRef = firestore.collection("menus").whereField("shopId", isEqualTo: ShopId.documentId)
        collectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let documents = snapshot?.documents {
                documents.forEach({ (document) in
                    if document.exists {
                        do {
                            let menu: Menu = try document.decoded()
                            menus.append(menu)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                })
            }
            completion(menus)
        }
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "掲載メニュー"
    }

    /// メニューを追加するViewControllerを呼ぶ
    /// AddにもEditMenuViewControllerを流用する
    public func presentAddMenuViewController() {
    }

}

extension MenusViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.setup(with: self.menus[indexPath.row])
        return cell
    }

    // MARK: - Table view delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuViewController.menu = self.menus[indexPath.row]
        menuViewController.edited = { () in
            // 再度ロードして追加分を反映
            self.loadMenus(completion: { (menus) in
                self.menus = menus
                self.tableView.reloadData()
                HUD.hide()
            })
        }
        self.navigationController?.pushViewController(menuViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        }
    }

}
