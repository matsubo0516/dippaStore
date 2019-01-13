//
//  EditMenuViewController.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/12.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit
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

    var menu: Menu? {
        didSet { isEdit = true }
    }
    // 編集モードか追加モードかのフラグ
    var isEdit = false

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
        if isEdit {
            editMenu(photoURL: self.menu?.rawPhoto)
        } else {
            addMenu(photoURL: self.menu?.rawPhoto)
        }
    }

    private func close() {
        if isEdit {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
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
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
