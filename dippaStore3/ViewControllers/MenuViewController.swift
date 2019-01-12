//
//  MenuViewController.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/12.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var menuPriceLabel: UILabel!

    var menu: Menu?

    // メニューが編集されたら、MenusViewControllerで再描画
    var isEdited = false
    var edited: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.tableFooterView = UIView()

        if let menu = self.menu {
            setupCells(with: menu)
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

    private func setupCells(with menu: Menu) {
        let url = URL(string: menu.rawPhoto)
        menuImageView.kf.setImage(with: url)

        menuNameLabel.text = menu.name
        menuPriceLabel.text = "¥\(menu.price)"
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "掲載メニュー"
        let leftBarButtonItem = UIBarButtonItem(title: "戻る", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapLeftButton))
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        let rightBarButtonItem = UIBarButtonItem(title: "編集", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapRightButton))
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }

    @objc func didTapLeftButton(sender: UIBarButtonItem) {
        if isEdited {
            if let edited = self.edited {
                edited()
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

    @objc func didTapRightButton(sender: UIBarButtonItem) {
        self.isEdited = false
    }

}
