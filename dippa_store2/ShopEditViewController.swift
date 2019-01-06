//
//  ShopEditViewController.swift
//  dippa_store2
//
//  Created by 松本直樹 on 2019/01/06.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

class ShopEditViewController: UIViewController {

    var contents:[String: String] = [:]
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var hours1TextField: UITextField!
    @IBOutlet weak var hours2TextField: UITextField!
    @IBOutlet weak var hours3TextField: UITextField!
    @IBOutlet weak var hours4TextField: UITextField!
    @IBOutlet weak var hours5TextField: UITextField!
    @IBOutlet weak var hours6TextField: UITextField!
    @IBOutlet weak var hours7TextField: UITextField!
    @IBOutlet weak var hours8TextField: UITextField!
    @IBOutlet weak var innerPhotoImageView: UIImageView!
    @IBOutlet weak var outerPhotoImageView: UIImageView!
    @IBOutlet weak var shopSaveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === self.shopSaveButton else {
            return
        }
        self.contents["name"] = self.nameTextField.text ?? ""
        self.contents["adress"] = self.adressTextField.text ?? ""
        self.contents["phone"] = self.phoneTextField.text ?? ""
        self.contents["hours1"] = self.hours1TextField.text ?? ""
        self.contents["hours2"] = self.hours2TextField.text ?? ""
        self.contents["hours3"] = self.hours3TextField.text ?? ""
        self.contents["hours4"] = self.hours4TextField.text ?? ""
        self.contents["hours5"] = self.hours5TextField.text ?? ""
        self.contents["hours6"] = self.hours6TextField.text ?? ""
        self.contents["hours7"] = self.hours7TextField.text ?? ""
        self.contents["hours8"] = self.hours8TextField.text ?? ""
        
    }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
}
