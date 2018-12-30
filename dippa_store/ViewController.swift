//
//  ViewController.swift
//  dippa_store
//
//  Created by 松本直樹 on 2018/12/08.
//  Copyright © 2018年 松本直樹. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pictureImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // SearchBarのdelegateの通知先を設定
        searchText.delegate = self
        // プレースホルダの設定
        searchText.placeholder = "検索したいメニュー名を入力してください"
        //TableViewのdataSourceを設定
        tableView.dataSource = self
    }
    
    ///メニューのリスト（タプル配列）
    var menuList : [(name: String, maker: String, link: URL, image: URL)] = []
    
    /// 検索をタップ時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        // キーボードを閉じる
        view.endEditing(true)
    
        if let searchWord = searchBar.text{
            // デバックエリアに出力
            print(searchWord)
            //入力されていたら、メニューを検索
            searchMenu(keyword: searchWord)
        }
    }
    
    //JSONのitem内のデータ構造
    struct ItemJson: Codable {
        //メニューの名称
        let name: String?
        //メーカー
        let maker: String?
        //掲載URL
        let url: URL?
        //画像URL
        let image: URL?
    }
    //JSONのデータ構造
    struct ResultJson: Codable {
        //複数要素
        let item:[ItemJson]?
    }
    
    
    //searchMenuメソッド
    //第一引数：KEYWORD 検索したいワード
    func searchMenu(keyword : String) {
        
        //メニューの検索キーワードをエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        //リクエストURLの組み立て｜
        guard let req_url = URL(string: "http://www.sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            return
        }
        print(req_url)
        
        //リクエストに必要な情報を生成
        let req = URLRequest(url: req_url)
        //データ転送を管理するためのセッションを生成
        let session = URLSession (configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        //リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data , response , error)in
            //セッションを終了
            session.finishTasksAndInvalidate()
            // do try catch エラーハンドリング
            do {
                //JSONDecorderのインスタンス取得
                let decoder = JSONDecoder()
                //受け取ったJSONデータを解析して格納
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                //メニューの情報が取得できているか確認
                if let items = json.item{
                    //メニューリストを初期化
                    self.menuList.removeAll()
                    //取得しているメニューの数だけ処理
                    for item in items{
                        //メニューの名称、メーカー名、掲載URL、画像URLをアンラップ
                        if let name = item.name , let maker = item.maker , let link = item.url , let image = item.image{
                            //1つのメニューをタプルでまとめて管理
                            let menu = (name,maker,link,image)
                            //メニューの配列へ追加
                            self.menuList.append(menu)
                        }
                    }
                    //TableViewを更新する
                    self.tableView.reloadData()
                    
                    if let menudbg = self.menuList.first{
                        print("----------------")
                        print("menuList[0] = \(menudbg)")
                    }
                }
            } catch {
                //エラー処理
                print("エラーがでました")
            }
        })
        //ダウンロード開始
        task.resume()
    }
    
    //Cellの総数を返すDatasourceメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //メニューリストの総数
        return menuList.count
    }
   
    //Cellに値を設定するDatasourceメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //今回表示を行う、Cellオブジェクト（1行）を取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        //メニューのタイトル設定
        cell.textLabel?.text = menuList[indexPath.row].name
        //メニュー画像を取得
        if let imageData = try? Data(contentsOf: menuList[indexPath.row].image){
            //正常に取得できた場合は、UIimageで画像オブジェクトを生成して、Cellにメニュー画像を設定
            cell.imageView?.image = UIImage(data: imageData)
        }
        //設定済みのCellオブジェクトを画面に反映
        return cell
    }
    
    ///カメラ領域の処理
    @IBAction func cameraButtonAction(_ sender: Any) {
        //カメラかライブラリーのどちらを選択するか
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //カメラを起動するための選択肢定義
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action:UIAlertAction) in
                //カメラを起動
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        //フォトライブラリーが利用可能か確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //フォトライブラリーを起動するための選択肢定義
            let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: { (action:UIAlertAction) in
                //フォトライブラリーを起動
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        //キャンセルの選択肢を定義
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    
        //ipadた落ちる対策
        alertController.popoverPresentationController?.sourceView = view
        
        //選択肢の画面に表示
        present(alertController, animated: true, completion: nil)
    }
    
    
    //撮影が終わった時に呼ばれるdelegete
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //撮影した写真を、配置したpictureimageに
        pictureImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //モーダルビューw閉じる
        dismiss(animated: true, completion: nil)
    }
    
}

