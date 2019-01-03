//
//  MenuViewController.swift
//  dippa_store2
//
//  Created by 松本直樹 on 2019/01/01.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var MenuTextField: UITextField!
    @IBOutlet weak var PriceTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var menu: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.saveButton.isEnabled = false
        //ここもデータの受け渡し方がおかしい
        if let menuTitle  = menu["title"] {
            self.MenuTextField.text = menuTitle
        }
        if let menuDetail  = menu["detail"] {
            self.PriceTextField.text = menuDetail
        }
        self.navigationItem.title = "メニュー編集"
        self.updateSaveButtonState()
    }
    
    private func updateSaveButtonState() {
        let menuTitle = self.MenuTextField.text ?? ""
        self.saveButton.isEnabled = !menuTitle.isEmpty
        let menuDetail = self.PriceTextField.text ?? ""
        self.saveButton.isEnabled = !menuDetail.isEmpty
    }
    
    @IBAction func MenuTextFieldChanged(_ sender: Any) {
        self.updateSaveButtonState()
    }
    
    @IBAction func cancellButton(_ sender: Any) {
        if self.presentingViewController is UINavigationController {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === self.saveButton else {
            return
        }
        self.menu["title"] = self.MenuTextField.text ?? ""
        self.menu["detail"] = self.PriceTextField.text ?? ""
    }


}
