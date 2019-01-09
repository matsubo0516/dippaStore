//
//  SigninViewController.swift
//  dippa_store2
//
//  Created by 松本直樹 on 2019/01/09.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController {

    let user = User.shared
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTouchSigninButton(_ sender: Any) {
        if let credential = getCredential() {
            user.signin(credential: credential)
        }
    }
    
    @IBAction func didTouchLoginButton(_ sender: Any) {
        if let credential = getCredential() {
            user.login(credential: credential)
        }
    }
    
    // delegate
    func didCreate(error: Error?) {
        if let error = error {
            self.alert("エラー", error.localizedDescription, nil)
            return
        }
        self.presentTaskList()
    }
    // delegate
    func didLogin(error: Error?) {
        if let error = error {
            print (error.localizedDescription)
            self.alert("エラー", error.localizedDescription, nil)
            return
        }
        self.presentTaskList()
    }
    
    func getCredential() -> Credential?{
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if (email.isEmpty) {
            self.alert("エラー", "メールアドレスを入力して下さい", nil)
            return nil
        }
        if (password.isEmpty) {
            self.alert("エラー", "パスワードを入力して下さい", nil)
            return nil
        }
        return Credential(email: email, password: password)
    }
    
    func presentTaskList () {
        //Storyboardを指定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MenuSelectViewController")
        self.present(viewController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //キーボードを閉じる
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
