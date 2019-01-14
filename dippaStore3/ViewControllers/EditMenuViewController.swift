//
//  EditMenuViewController.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/12.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import PKHUD

/// Editという名前にしたけど、Addにも流用する
/// menuプロパティが設定されいる: メニュー編集モード
/// menuプロパティが設定されていない: メニュー追加モード
class EditMenuViewController: UITableViewController {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuNameTextField: UITextField!
    @IBOutlet weak var menuPriceTextField: UITextField!

    private var firestore: Firestore {
        return Firestore.firestore()
    }

    private var storage: Storage {
        return Storage.storage()
    }

    var menu: Menu? {
        didSet { isEdit = true }
    }
    // 編集モードか追加モードかのフラグ
    var isEdit = false
    // 写真が追加、更新されたかのフラグ
    var isNewPhoto = false

    // メニューの編集、追加が成功したのを知らせる
    var editCompleted: ((Menu) -> Void)?
    var addCompleted: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.tableFooterView = UIView()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view.addGestureRecognizer(tapRecognizer)

        if let menu = self.menu {
            setupCells(with: menu)
        }
    }

    private func setupCells(with menu: Menu) {
        let url = URL(string: menu.rawPhoto)
        menuImageView.kf.setImage(with: url)

        menuNameTextField.text = menu.name
        menuPriceTextField.text = "\(menu.price)"
    }

    private func setupNavigationBar() {
        self.navigationItem.title = "掲載メニュー"
        let leftBarButtonName = isEdit ? "戻る" : "閉じる"
        let leftBarButtonItem = UIBarButtonItem(title: leftBarButtonName, style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapLeftButton))
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        let rightBarButtonName = isEdit ? "保存" : "追加"
        let rightBarButtonItem = UIBarButtonItem(title: rightBarButtonName, style: UIBarButtonItem.Style.plain, target: self, action: #selector(didTapRightButton))
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }

    @objc func didTapLeftButton(sender: UIBarButtonItem) {
        close()
    }

    @objc func didTapRightButton(sender: UIBarButtonItem) {
        if isNewPhoto {
            savePhoto()
        } else {
            if isEdit {
                editMenu(photoURL: self.menu?.rawPhoto)
            } else {
                addMenu(photoURL: self.menu?.rawPhoto)
            }
        }
    }

    private func close() {
        if isEdit {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func savePhoto() {
        if let image = self.menuImageView.image, let data = image.jpegData(compressionQuality: 0.8) {
            HUD.show(.progress, onView: view)

            // Storageにアクセスする(putData)
            let id = NSUUID().uuidString.lowercased()
            let imageRef = storage.reference().child("menus/\(id).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            imageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    imageRef.downloadURL { (url, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if let url = url {
                            print(url.absoluteString)
                            if self.isEdit {
                                self.editMenu(photoURL: url.absoluteString)
                            } else {
                                self.addMenu(photoURL: url.absoluteString)
                            }
                        }
                    }
                }
            }
        }
    }

    private func addMenu(photoURL: String?) {
        let name = menuNameTextField.text ?? ""
        let price = Int(menuPriceTextField.text ?? "0") ?? 0
        let rawPhoto = photoURL ?? ""
        let newMenu = Menu(id: nil, name: name, photo: "", rawPhoto: rawPhoto, price: price, shopId: ShopId.documentId)

        HUD.show(.progress, onView: view)

        // firestoreにアクセスする(addDocument)
        let collectionRef = firestore.collection("menus")
        collectionRef.addDocument(data: newMenu.toData()) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // メニューの追加が成功したので登録先に知らせる
                if let addCompleted = self.addCompleted {
                    addCompleted()
                }
            }
            HUD.hide()
            self.close()
        }
    }

    private func editMenu(photoURL: String?) {
        if let menu = self.menu, let id = menu.id {
            let name = menuNameTextField.text ?? ""
            let price = Int(menuPriceTextField.text ?? "0") ?? 0
            let rawPhoto = photoURL ?? ""
            let newMenu = Menu(id: id, name: name, photo: "", rawPhoto: rawPhoto, price: price, shopId: ShopId.documentId)

            HUD.show(.progress, onView: view)

            // firestoreにアクセスする(setData)
            let collectionRef = firestore.collection("menus")
            let documentRef = collectionRef.document(id)
            documentRef.setData(newMenu.toData()) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // メニューの編集が成功したので登録先に知らせる
                    if let editCompleted = self.editCompleted {
                        editCompleted(newMenu)
                    }
                }
                HUD.hide()
                self.close()
            }
        }
    }

    @objc func tapGesture(sender: UITapGestureRecognizer) {
        menuNameTextField.resignFirstResponder()
        menuPriceTextField.resignFirstResponder()
    }

    @IBAction func didTapCameraButton(_ sender: Any) {
        presentSelectImageAlert()
    }

    private func presentSelectImageAlert() {
        let alertController = UIAlertController(title: "画像を選択", message:nil, preferredStyle: .actionSheet)

        // Camera
        let cameraAction = UIAlertAction(title: "カメラを開く", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertController.addAction(cameraAction)

        // PhotoAlbum
        let photoAction = UIAlertAction(title: "フォトライブラリを開く", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        })
        alertController.addAction(photoAction)

        // Cancel
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

}

extension EditMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Image picker controller delegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 1080pixel : Instagramの投稿画像サイズ
            if let resizedImage = image.resize(width: 1080.0) {
                self.menuImageView.image = resizedImage
                self.isNewPhoto = true
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
