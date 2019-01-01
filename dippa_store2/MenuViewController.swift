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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var memo: [String: String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === self.saveButton else {
            return
        }
        self.memo["title"] = self.MenuTextField.text ?? ""
        self.memo["detail"] = "あとで入力値を受け取ってセットする"
        
    }


}
