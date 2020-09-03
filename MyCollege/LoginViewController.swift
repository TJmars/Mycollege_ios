//
//  LoginViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/22.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if let address = mailAddressTextField.text , let password = passwordTextField.text {
            
            //            空欄があるときは何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            //            HUDで処理を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "入力事項に誤りがあります")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました")
                
                //                HUDを消す
                SVProgressHUD.dismiss()
                
                //                画面を閉じる
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    
    
}
