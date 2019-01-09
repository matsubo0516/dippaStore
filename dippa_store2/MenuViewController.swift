//
//  MenuViewController.swift
//  dippa_store2
//
//  Created by 松本直樹 on 2019/01/01.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,  UIGestureRecognizerDelegate {

    @IBOutlet weak var MenuTextField: UITextField!
    @IBOutlet weak var PriceTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var menuPictureImage: UIImageView!
    
    var menu: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.saveButton.isEnabled = false
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(MenuViewController.tapped(_:)))
        
        // デリゲートをセット
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
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
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
//            if UIImagePickerController.isSourceTypeAvailable(.camera){
//                print("カメラは利用できます")
//                let imagePickerController = UIImagePickerController()
//                imagePickerController.sourceType = .camera
//                imagePickerController.delegate = self
//                present(imagePickerController, animated: true, completion: nil)
//            } else {
//                print("カメラは利用できません")
//            }
            let alertController = UIAlertController(title: "カメラ", message: "選択してください", preferredStyle: .actionSheet)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action:UIAlertAction)in
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .camera
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                })
                alertController.addAction(cameraAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action:UIAlertAction)in
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = self
                    self.present(imagePickerController, animated: true, completion: nil)
                })
                alertController.addAction(photoLibraryAction)
            }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
        alertController.popoverPresentationController?.sourceView = view
            
        present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        menuPictureImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
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
