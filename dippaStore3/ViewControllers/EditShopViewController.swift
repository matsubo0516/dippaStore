//
//  EditShopViewController.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/12.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit
import FirebaseFirestore
import PKHUD

class EditShopViewController: UITableViewController {

    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var shopPhoneTextField: UITextField!

    private var firestore: Firestore {
        return Firestore.firestore()
    }

    var shop: Shop?
    // お店の編集が成功したのを知らせる
    var editCompleted: ((Shop) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.tableFooterView = UIView()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view.addGestureRecognizer(tapRecognizer)

        if let shop = self.shop {
            setupCells(with: shop)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (self.tabBarController! as! DippaTabBarController).hide()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (self.tabBarController! as! DippaTabBarController).show()
    }

    private func setupCells(with shop: Shop) {
        shopNameTextField.text = shop.name
        shopAddressTextField.text = shop.address
        shopPhoneTextField.text = shop.phone
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "掲載メニュー"
        let leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapLeftButton))
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        let rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapRightButton))
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }

    @objc func didTapLeftButton(sender: UIBarButtonItem) {
        close()
    }

    @objc func didTapRightButton(sender: UIBarButtonItem) {
        saveShop()
    }

    private func close() {
        self.navigationController?.popViewController(animated: true)
    }

    private func saveShop() {
        if let shop = self.shop, let id = shop.id {
            let name = shopNameTextField.text ?? ""
            let address = shopAddressTextField.text ?? ""
            let phone = shopPhoneTextField.text ?? ""
            let newShop = Shop(id: id, name: name, phone: phone, address: address)

            HUD.show(.progress, onView: view)

            // firestoreにアクセスする(setData)
            let collectionRef = firestore.collection("shops")
            let documentRef = collectionRef.document(id)
            documentRef.setData(newShop.toData()) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // お店の編集が成功したので登録先に知らせる
                    if let editCompleted = self.editCompleted {
                        editCompleted(newShop)
                    }
                }
                HUD.hide()
                self.close()
            }
        }
    }

    @objc func tapGesture(sender: UITapGestureRecognizer) {
        shopNameTextField.resignFirstResponder()
        shopAddressTextField.resignFirstResponder()
        shopPhoneTextField.resignFirstResponder()
    }
    
}
