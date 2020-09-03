//
//  NewClassViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/25.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class NewClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //    Realm
    let realm = try! Realm()
    var task: Task!
    var taskArray = try! Realm().objects(Task.self)
    
    //    投稿データを格納
       var postArray: [PostData] = []
    var documentIDArray:[String] = []
    
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var facultyTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    
    
    var dayPickerView = UIPickerView()
    var facultyPickerView = UIPickerView()
    
    var day = ""
    var period = ""
    
    var dayNum = 0
      var periodNum = 0
    
    let dataList = [["すべての曜日","月曜","火曜","水曜","木曜","金曜", "土曜"],["すべての時間","1限","2限","3限","4限","5限","6限"]]
    let dataList2 = ["すべての学部","経済","社会","人文"]
    let dataList3 = [["すべての学科","経済","経営","金融"],["すべての学科","社会","メディア社会"],["すべての学科","英米","パ文","日東"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createPickerView()
    }
    
    @IBAction func CreateClassButton(_ sender: Any) {
        
        if classNameTextField.text != "" && classTextField.text != "" && teacherTextField.text != "" {
            createClass()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
   
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == dayPickerView {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dayPickerView {
            return 7
        } else {
            return dataList2.count
        }
    }
    
    //    textFieldのキーボードにpickerViewを表示
    func createPickerView() {
        
        dayPickerView.delegate = self
        facultyPickerView.delegate = self
        
        dayTextField.inputView = dayPickerView
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
        classNameTextField.inputAccessoryView = toolBar
        dayTextField.inputAccessoryView = toolBar
        facultyTextField.inputAccessoryView = toolBar
        
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dayPickerView {
            return dataList[component][row]
        } else {
            
            return dataList2[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dayPickerView {
            var data1 = "\(self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)!)"
            var data2 = "\(self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 1), forComponent: 1)!)"
            
            day = data1
            period = data2
            if data1 == "すべての曜日" {
                data1 = ""
            }
            if data2 == "すべての時間" {
                data2 = ""
            }
            
            dayTextField.text = data1 + data2
        } else {
            if row == 0 {
                facultyTextField.text = ""
            } else {
                facultyTextField.text = dataList2[row]
            }
        }
    }
    @objc func donePicker() {
        classNameTextField.endEditing(true)
        dayTextField.endEditing(true)
        facultyTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        classNameTextField.endEditing(true)
        dayTextField.endEditing(true)
        facultyTextField.endEditing(true)
        
    }
    
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func createClass() {
        
        //        データの保存先を定義
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        
        //        FireStoreにデータを保存
        let postDic = [
            "className": self.classNameTextField.text!,
            "day": self.day,
            "period": self.period,
            "faculty": self.facultyTextField.text!,
            "teacher": self.teacherTextField.text!,
            "classRoom": self.classTextField.text!,
            "gradeS": 0,
            "gradeA": 0,
            "gradeB": 0,
            "gradeC": 0,
            "gradeD": 0,
            "level4": 0,
            "level3": 0,
            "level2": 0,
            "level1": 0,
            "evaA": 0,
            "evaB": 0,
            "evaC": 0,
            "evaD": 0,
            "imageNum": 1
            
            
            ] as [String : Any]
        postRef.setData(postDic)
    }
}
