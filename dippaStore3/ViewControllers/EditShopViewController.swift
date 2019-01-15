//
//  EditShopViewController.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/12.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit
//import Firebase
import FirebaseFirestore
import PKHUD

class EditShopViewController: UITableViewController {

    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var shopPhoneTextField: UITextField!
    @IBOutlet weak var mondayTextField: UITextField!
    @IBOutlet weak var tuesdayTextField: UITextField!
    @IBOutlet weak var wednesdayTextField: UITextField!
    @IBOutlet weak var thursdayTextField: UITextField!
    @IBOutlet weak var fridayTextField: UITextField!
    @IBOutlet weak var saturdayTextField: UITextField!
    @IBOutlet weak var sundayTextField: UITextField!
    @IBOutlet weak var holidayTextField: UITextField!
//    @IBOutlet weak var insideImageView: UIImageView!
//    @IBOutlet weak var outsideImageView: UIImageView!

    private var firestore: Firestore {
        return Firestore.firestore()
    }

//    private var storage: Storage {
//        return Storage.storage()
//    }
    
    var shop: Shop?
//    {
//        didSet { isEdit = true }
//    }
//    // 編集モードか追加モードかのフラグ
//    var isEdit = false
//    // 写真が追加、更新されたかのフラグ
//    var isNewPhoto = false

    // お店の編集が成功したのを知らせる
    var editCompleted: ((Shop) -> Void)?
//    var addCompleted: (() -> Void)?

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
        mondayTextField.text = shop.mondayOpenHours ?? ""
        tuesdayTextField.text = shop.tuesdayOpenHours ?? ""
        wednesdayTextField.text = shop.wednesdayOpenHours ?? ""
        thursdayTextField.text = shop.thursdayOpenHours ?? ""
        fridayTextField.text = shop.fridayOpenHours ?? ""
        saturdayTextField.text = shop.saturdayOpenHours ?? ""
        sundayTextField.text = shop.sundayOpenHours ?? ""
        holidayTextField.text = shop.holidayOpenHours ?? ""
        
//        let insideurl = URL(string: shop.insidePhoto)
//        insideImageView.kf.setImage(with: insideurl)
//        let outsideurl = URL(string: shop.outsidePhoto)
//        outsideImageView.kf.setImage(with: outsideurl)
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
//        if isNewPhoto {
//            saveInsidePhoto()
//// 2つに分けて実行できるっけ？
////            saveOutsidePhoto()
//        } else {
//            if isEdit {
//                saveShop(photoURL: self.shop?.insidePhoto)
//// 2つに分けて実行できるっけ？
////                saveShop(photoURL: self.shop?.outsidePhoto)
//            }
//        }
    }

    private func close() {
        self.navigationController?.popViewController(animated: true)
    }

//    private func saveInsidePhoto() {
//                if let image = self.insideImageView.image, let data = image.jpegData(compressionQuality: 0.8) {
//                    HUD.show(.progress, onView: view)
//
//                    // Storageにアクセスする
//                    let id = NSUUID().uuidString.lowercased()
//                    let imageRef = storage.reference().child("shops/\(id).jpg")
//                    let metadata = StorageMetadata()
//                    metadata.contentType = "image/jpeg"
//                    imageRef.putData(data, metadata: metadata) { (metadata, error) in
//                        if let error = error {
//                            print(error.localizedDescription)
//                        } else {
//                            imageRef.downloadURL { (url, error) in
//                                if let error = error {
//                                    print(error.localizedDescription)
//                                } else if let url = url {
//                                    print(url.absoluteString)
//                                    if self.isEdit {
//                                        self.saveShop(photoURL: url.absoluteString)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }

//        private func saveOutsidePhoto() {
//            if let outsidePhoto = self.outsideImageView.image, let data = outsidePhoto.jpegData(compressionQuality: 0.8) {
//                HUD.show(.progress, onView: view)
//                
//                // Storageにアクセスする
//                let id = NSUUID().uuidString.lowercased()
//                let imageRef = storage.reference().child("shops/\(id).jpg")
//                let metadata = StorageMetadata()
//                metadata.contentType = "image/jpeg"
//                imageRef.putData(data, metadata: metadata) { (metadata, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        imageRef.downloadURL { (url, error) in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            } else if let url = url {
//                                print(url.absoluteString)
//                                if self.isEdit {
//                                    self.saveShop(photoURL: url.absoluteString)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    
    
    private func saveShop() {
//    private func saveShop(photoURL: String?) {
        if let shop = self.shop, let id = shop.id {
            let name = shopNameTextField.text ?? ""
            let address = shopAddressTextField.text ?? ""
            let phone = shopPhoneTextField.text ?? ""
            let mondayOpenHours = mondayTextField.text ?? ""
            let tuesdayOpenHours = tuesdayTextField.text ?? ""
            let wednesdayOpenHours = wednesdayTextField.text ?? ""
            let thursdayOpenHours = thursdayTextField.text ?? ""
            let fridayOpenHours = fridayTextField.text ?? ""
            let saturdayOpenHours = saturdayTextField.text ?? ""
            let sundayOpenHours = sundayTextField.text ?? ""
            let holidayOpenHours = holidayTextField.text ?? ""
//            let insidePhoto = photoURL ?? ""
//            let outsidePhoto = photoURL ?? ""
            let newShop = Shop(id: id,
                               name: name,
                               phone: phone,
                               address: address,
                               mondayOpenHours: mondayOpenHours,
                               tuesdayOpenHours: tuesdayOpenHours,
                               wednesdayOpenHours: wednesdayOpenHours,
                               thursdayOpenHours: thursdayOpenHours,
                               fridayOpenHours: fridayOpenHours,
                               saturdayOpenHours: saturdayOpenHours,
                               sundayOpenHours: sundayOpenHours,
                               holidayOpenHours: holidayOpenHours)
//                               insidePhoto: insidePhoto,
//                               outsidePhoto: outsidePhoto)

            HUD.show(.progress)

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
        mondayTextField.resignFirstResponder()
        tuesdayTextField.resignFirstResponder()
        wednesdayTextField.resignFirstResponder()
        thursdayTextField.resignFirstResponder()
        fridayTextField.resignFirstResponder()
        saturdayTextField.resignFirstResponder()
        sundayTextField.resignFirstResponder()
        holidayTextField.resignFirstResponder()
//        insideImageView.resignFirstResponder()
//        outsideImageView.resignFirstResponder()
    }
}
    
//    @IBAction func didTapInsideCameraButton(_ sender: Any) {
//        insideSelectImageAlert()
//    }
//
//    private func insideSelectImageAlert() {
//        let alertController = UIAlertController(title: "画像を選択", message:nil, preferredStyle: .actionSheet)
//
//        // Camera
//        let cameraAction = UIAlertAction(title: "カメラを開く", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) -> Void in
//            let imagePicker = UIImagePickerController()
//            imagePicker.sourceType = UIImagePickerController.SourceType.camera
//            imagePicker.delegate = self
//            self.present(imagePicker, animated: true, completion: nil)
//        })
//        alertController.addAction(cameraAction)
//
//        // PhotoAlbum
//        let photoAction = UIAlertAction(title: "フォトライブラリを開く", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) -> Void in
//            let imagePicker = UIImagePickerController()
//            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            imagePicker.delegate = self
//            self.present(imagePicker, animated: true, completion: nil)
//        })
//        alertController.addAction(photoAction)
//
//        // Cancel
//        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true, completion: nil)
//    }
//
////    @IBAction func didTapoutsideCameraButton(_ sender: Any) {
////        outsideSelectImageAlert()
////    }
//
////    private func outsideSelectImageAlert() {
////        let alertController = UIAlertController(title: "画像を選択", message:nil, preferredStyle: .actionSheet)
////
////        // Camera
////        let cameraAction = UIAlertAction(title: "カメラを開く", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) -> Void in
////            let imagePicker = UIImagePickerController()
////            imagePicker.sourceType = UIImagePickerController.SourceType.camera
////            imagePicker.delegate = self
////            self.present(imagePicker, animated: true, completion: nil)
////        })
////        alertController.addAction(cameraAction)
////
////        // PhotoAlbum
////        let photoAction = UIAlertAction(title: "フォトライブラリを開く", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) -> Void in
////            let imagePicker = UIImagePickerController()
////            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
////            imagePicker.delegate = self
////            self.present(imagePicker, animated: true, completion: nil)
////        })
////        alertController.addAction(photoAction)
////
////        // Cancel
////        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
////        alertController.addAction(cancelAction)
////
////        present(alertController, animated: true, completion: nil)
////    }
////

//extension EditShopViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    // MARK: - Image picker controller delegate
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        dismiss(animated: true, completion: nil)
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            // 1080pixel : Instagramの投稿画像サイズ
//                if let insideresizedImage = image.resize(width: 1080.0) {
//                    self.insideImageView.image = insideresizedImage
//                    self.isNewPhoto = true
////            } else {
////                if let outsideresizedImage = image.resize(width: 1080.0) {
////                    self.outsideImageView.image = outsideresizedImage
////                    self.isNewPhoto = true
////                    }
//           }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
