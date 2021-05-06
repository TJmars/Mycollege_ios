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
import RealmSwift


class CreateAccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var collegeNameTextField: UITextField!
    @IBOutlet weak var facultyTextField: UITextField!
    let dataList = ["経済","社会","人文"]
    var facultyPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }
        createPickerView()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let password2 = password2TextField.text, let displayName = displayNameTextField.text, let faculty = facultyTextField.text {
            //            どれかが空欄の時は何もしない
            if address.isEmpty || password.isEmpty || password2.isEmpty || displayName.isEmpty || faculty.isEmpty {
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
                        
                        try! self.realm .write {
                            self.loginApp.deleateApp = 1
                            self.loginApp.facultyData = self.facultyTextField.text!
                            self.loginApp.collegeNameData = self.collegeNameTextField.text!
                            self.realm.add(self.loginApp)
                        }
                        
                        print(self.loginApp.deleateApp)
                        
                        //                        HUDを消す
                        SVProgressHUD.dismiss()
                        //                        画面へ戻る
                        self.performSegue(withIdentifier: "toTabBar", sender: nil)
                    }
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    //    textFieldのキーボードにpickerViewを表示
    func createPickerView() {
        
        facultyPickerView.delegate = self
    
        facultyTextField.inputView = facultyPickerView
        
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePicker))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
       
        displayNameTextField.inputAccessoryView = toolBar
        mailAddressTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        password2TextField.inputAccessoryView = toolBar
        facultyTextField.inputAccessoryView = toolBar
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        facultyTextField.text = dataList[row]
    }
    @objc func donePicker() {
       
        displayNameTextField.endEditing(true)
        mailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
        password2TextField.endEditing(true)
        facultyTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayNameTextField.endEditing(true)
        mailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
        password2TextField.endEditing(true)
        facultyTextField.endEditing(true)
       
    }
    
}
