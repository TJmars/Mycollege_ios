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
import RealmSwift

class LoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    let realm = try! Realm()
    var loginApp:LoginApp!
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var collegeNameTextField: UITextField!
    @IBOutlet weak var facultyTextField: UITextField!
    let dataList = ["学部名を選択","経済","社会","人文"]
    let collegeList = ["学校名を選択","武蔵大学"]
    var facultyPickerView = UIPickerView()
    var collegePickerView = UIPickerView()
    
    
    
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
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        if let address = mailAddressTextField.text , let password = passwordTextField.text, let faculty = facultyTextField.text, let college = collegeNameTextField.text{
            
            //            空欄があるときは何もしない
            if address.isEmpty || password.isEmpty || faculty.isEmpty || college.isEmpty {
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
                
                try! self.realm .write {
                    self.loginApp.deleateApp = 1
                    self.loginApp.facultyData = self.facultyTextField.text!
                    self.loginApp.collegeNameData = self.collegeNameTextField.text!
                    self.realm.add(self.loginApp)
                }
                
                print(self.loginApp.deleateApp)
                
                //                HUDを消す
                SVProgressHUD.dismiss()
                
                //                画面を閉じる
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == facultyPickerView {
            return dataList.count
        } else {
            return collegeList.count
        }
    }
    
    //    textFieldのキーボードにpickerViewを表示
    func createPickerView() {
        
        facultyPickerView.delegate = self
        facultyTextField.inputView = facultyPickerView
        collegePickerView.delegate = self
        collegeNameTextField.inputView = collegePickerView
        
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
       
        mailAddressTextField.inputAccessoryView = toolBar
        passwordTextField.inputAccessoryView = toolBar
        facultyTextField.inputAccessoryView = toolBar
        collegeNameTextField.inputAccessoryView = toolBar
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == facultyPickerView {
            return dataList[row]
        } else {
            return collegeList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == facultyPickerView {
            if row == 0 {
                facultyTextField.text = ""
            } else {
                facultyTextField.text = dataList[row]
            }
        } else {
            if row == 0 {
                collegeNameTextField.text = ""
            } else {
                collegeNameTextField.text = collegeList[row]
            }
        }
    }
    @objc func donePicker() {
       
        mailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
        facultyTextField.endEditing(true)
        collegeNameTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        mailAddressTextField.endEditing(true)
        passwordTextField.endEditing(true)
        facultyTextField.endEditing(true)
        collegeNameTextField.endEditing(true)
       
    }
    
}
