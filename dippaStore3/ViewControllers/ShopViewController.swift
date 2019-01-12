//
//  ShopViewController.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/07.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit
import FirebaseFirestore
import PKHUD

class ShopViewController: UITableViewController {

    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var shopPhoneLabel: UILabel!

    private var firestore: Firestore {
        return Firestore.firestore()
    }

    var shop: Shop?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.tableFooterView = UIView()

        loadShop(completion: { (shop) in
            if let shop = shop {
                self.shop = shop
                self.setupCells(with: shop)
            }
            HUD.hide()
        })
    }

    private func loadShop(completion: @escaping ((Shop?) -> Void)) {
        HUD.show(.progress, onView: view)

        // firestoreにアクセスする(getDocument)
        var shop: Shop?
        let documentRef = firestore.collection("shops").document(ShopId.documentId)
        documentRef.getDocument { (document, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let document = document {
                if document.exists {
                    do {
                        shop = try document.decoded()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            completion(shop)
        }
    }

    private func setupCells(with shop: Shop) {
        shopNameLabel.text = shop.name
        shopAddressLabel.text = shop.address
        shopPhoneLabel.text = shop.phone
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "お店情報"
        let rightBarButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapRightButton))
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }

    @objc func didTapRightButton(sender: UIBarButtonItem) {
    }

}
