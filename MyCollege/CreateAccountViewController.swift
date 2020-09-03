//
//  CreateAccountViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/22.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let password2 = password2TextField.text, let displayName = displayNameTextField.text {
            //            どれかが空欄の時は何もしない
            if address.isEmpty || password.isEmpty || password2.isEmpty || displayName.isEmpty {
                if password != password2 {
                    print("DEBUG_PRINT: パスワードが一致していない")
                    SVProgressHUD.showError(withStatus: "パスワードが一致していません")
                    return
                }
                print("DEBUG_PRINT: 空欄があります")
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            
            //            ユーザー作成　成功したら自動ログイン
            
            SVProgressHUD.show()
            
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                    return
                }
                print("PRINT_DEBUG: ユーザー作成に成功")
                
                //                表示名を設定
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            //                            プロフィールの更新でエラー発生
                            print("DEBUG_PRINT:" + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました")
                            return
                        }
                        print("DEBUG_PRINT:[displayName = \(user.displayName!)]の設定に成功しました")
                        
                        //                        HUDを消す
                        SVProgressHUD.dismiss()
                        //                        画面へ戻る
                        self.performSegue(withIdentifier: "toTabBar", sender: nil)
                    }
                }
            }
        }
    }
    
    
    
}
