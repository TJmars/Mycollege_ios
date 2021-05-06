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
    var loginApp:LoginApp!
    
    
    var documentIDArray:[String] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
   
    
    let backButton = UIButton()
    let classNameTextField = UITextField()
    let facultyTextField = UITextField()
    let seasonTextField = UITextField()
    let dayTextField = UITextField()
    let teacherTextField = UITextField()
    let classTextField = UITextField()
    let evaRateTextView = UITextView()
    let careerTextView = UITextView()
    let postButton = UIButton()
    
    let classNameLabel = UILabel()
    let facultyLabel = UILabel()
    let seasonLabel = UILabel()
    let dayLabel = UILabel()
    let teacherLabel = UILabel()
    let classLabel = UILabel()
    let evaRateLabel = UILabel()
    let careerLabel = UILabel()
    
    
    var dayPickerView = UIPickerView()
    var facultyPickerView = UIPickerView()
    var seasonPickerView = UIPickerView()
    
    var day = ""
    var period = ""
    
    
    var dayNum = 0
    var periodNum = 0
    
    let dataList = [["月曜","火曜","水曜","木曜","金曜", "土曜"],["1限","2限","3限","4限","5限","6限"]]
    let dataList2 = ["すべての学部","経済","社会","人文"]
    let dataList3 = [["すべての学科","経済","経営","金融"],["すべての学科","社会","メディア社会"],["すべての学科","英米","パ文","日東"]]
    let dataList4 = ["春学期","秋学期","通年"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }
        
        let width = view.frame.size.width
        scrollView.contentSize = CGSize(width: width, height: 800 + view.frame.size.height / 2)
        
        //        戻るボタン
        backButton.frame = CGRect(x: 0, y: 0, width: 115, height: 40)
        backButton.setTitle("《 Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        backButton.addTarget(self, action: #selector(tapBackButton(_:)), for: .touchUpInside)
        backButton.setTitleColor(UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1), for: .normal)
        
        //        クラス名
        classNameLabel.frame = CGRect(x: 10, y: 60, width: width - 20, height: 20)
        classNameLabel.textAlignment = .center
        classNameLabel.text = "教科名"
        classNameTextField.frame = CGRect(x: 10, y: 90, width: width - 20, height: 30)
        classNameTextField.textAlignment = .center
        classNameTextField.placeholder = "教科名を入力してください"
        classNameTextField.font = UIFont.systemFont(ofSize: 16.0)
        classNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        classNameTextField.layer.borderWidth = 1.0
        classNameTextField.layer.cornerRadius = 5
        classNameTextField.clipsToBounds = true
        
        //        教員名
        teacherLabel.frame = CGRect(x: 10, y: 140, width: width - 20, height: 20)
        teacherLabel.textAlignment = .center
        teacherLabel.text = "教員名"
        teacherTextField.frame = CGRect(x: 10, y: 170, width: width - 20, height: 30)
        teacherTextField.textAlignment = .center
        teacherTextField.placeholder = "教員名を入力してください"
        teacherTextField.font = UIFont.systemFont(ofSize: 16.0)
        teacherTextField.layer.borderColor = UIColor.lightGray.cgColor
        teacherTextField.layer.borderWidth = 1.0
        teacherTextField.layer.cornerRadius = 5
        teacherTextField.clipsToBounds = true
        
        //        学部
        facultyLabel.frame = CGRect(x: 10, y: 220, width: width - 20, height: 20)
        facultyLabel.textAlignment = .center
        facultyLabel.text = "学部名"
        facultyTextField.frame = CGRect(x: 10, y: 250, width: width - 20, height: 30)
        facultyTextField.textAlignment = .center
        facultyTextField.placeholder = "学部を入力してください"
        facultyTextField.font = UIFont.systemFont(ofSize: 16.0)
        facultyTextField.layer.borderColor = UIColor.lightGray.cgColor
        facultyTextField.layer.borderWidth = 1.0
        facultyTextField.layer.cornerRadius = 5
        facultyTextField.clipsToBounds = true
        
        //        学期
        seasonLabel.frame = CGRect(x: 10, y: 300, width: width - 20, height: 20)
        seasonLabel.textAlignment = .center
        seasonLabel.text = "学期"
        seasonTextField.frame = CGRect(x: 10, y: 330, width: width - 20, height: 30)
        seasonTextField.textAlignment = .center
        seasonTextField.placeholder = "学期を入力してください"
        seasonTextField.font = UIFont.systemFont(ofSize: 16.0)
        seasonTextField.layer.borderColor = UIColor.lightGray.cgColor
        seasonTextField.layer.borderWidth = 1.0
        seasonTextField.layer.cornerRadius = 5
        seasonTextField.clipsToBounds = true
        
        //        日時
        dayLabel.frame = CGRect(x: 10, y: 380, width: width - 20, height: 20)
        dayLabel.textAlignment = .center
        dayLabel.text = "曜日、日時"
        dayTextField.frame = CGRect(x: 10, y: 410, width: width - 20, height: 30)
        dayTextField.textAlignment = .center
        dayTextField.placeholder = "曜日、時間を入力してください"
        dayTextField.font = UIFont.systemFont(ofSize: 16.0)
        dayTextField.layer.borderColor = UIColor.lightGray.cgColor
        dayTextField.layer.borderWidth = 1.0
        dayTextField.layer.cornerRadius = 5
        dayTextField.clipsToBounds = true
        
        //        教室
        classLabel.frame = CGRect(x: 10, y: 460, width: width - 20, height: 20)
        classLabel.textAlignment = .center
        classLabel.text = "教室"
        classTextField.frame = CGRect(x: 10, y: 490, width: width - 20, height: 30)
        classTextField.textAlignment = .center
        classTextField.placeholder = "教室を入力してください"
        classTextField.font = UIFont.systemFont(ofSize: 16.0)
        classTextField.layer.borderColor = UIColor.lightGray.cgColor
        classTextField.layer.borderWidth = 1.0
        classTextField.layer.cornerRadius = 5
        classTextField.clipsToBounds = true
        
        //        評価基準
        evaRateLabel.frame = CGRect(x: 10, y: 540, width: width - 20, height: 20)
        evaRateLabel.textAlignment = .center
        evaRateLabel.text = "評価基準"
        evaRateTextView.frame = CGRect(x: 10, y: 570, width: width - 20, height: 90)
        
        evaRateTextView.font = UIFont.systemFont(ofSize: 16.0)
        evaRateTextView.layer.borderColor = UIColor.lightGray.cgColor
        evaRateTextView.layer.borderWidth = 1.0
        evaRateTextView.layer.cornerRadius = 5
        evaRateTextView.clipsToBounds = true
        
        //        経歴
        careerLabel.frame = CGRect(x: 10, y: 680, width: width - 20, height: 20)
        careerLabel.textAlignment = .center
        careerLabel.text = "教員の経歴"
        careerTextView.frame = CGRect(x: 10, y: 710, width: width - 20, height: 90)
        
        careerTextView.font = UIFont.systemFont(ofSize: 16.0)
        careerTextView.layer.borderColor = UIColor.lightGray.cgColor
        careerTextView.layer.borderWidth = 1.0
        careerTextView.layer.cornerRadius = 5
        careerTextView.clipsToBounds = true
        
        //        投稿
        postButton.frame = CGRect(x: 30, y: 860, width: width - 60, height: 40)
        postButton.setTitle("この内容で投稿", for: .normal)
        postButton.addTarget(self, action: #selector(tapPostButton(_:)), for: .touchUpInside)
        postButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        postButton.layer.cornerRadius = 10
        postButton.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
        createPickerView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(backButton)
        scrollView.addSubview(classNameTextField)
        scrollView.addSubview(teacherTextField)
        scrollView.addSubview(facultyTextField)
        scrollView.addSubview(seasonTextField)
        scrollView.addSubview(dayTextField)
        scrollView.addSubview(classTextField)
        scrollView.addSubview(evaRateTextView)
        scrollView.addSubview(careerTextView)
        scrollView.addSubview(classNameLabel)
        scrollView.addSubview(teacherLabel)
        scrollView.addSubview(facultyLabel)
        scrollView.addSubview(seasonLabel)
        scrollView.addSubview(dayLabel)
        scrollView.addSubview(classLabel)
        scrollView.addSubview(evaRateLabel)
        scrollView.addSubview(careerLabel)
        scrollView.addSubview(postButton)
    }
    
    
    @objc func tapPostButton(_ sender:UIButton) {
        if self.classNameTextField.text != "" && self.classTextField.text != "" && self.teacherTextField.text != "" && self.seasonTextField.text != "" && self.dayTextField.text != "" {
            
            let dialog = UIAlertController(title: "新規授業の作成", message: "この内容で新規授業を作成しますか？", preferredStyle: .alert)
            
            dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                let postsRef = Firestore.firestore().collection(self.loginApp.collegeNameData).whereField("className", isEqualTo:  self.classNameTextField.text!).whereField("teacher", isEqualTo: self.teacherTextField.text!).getDocuments() { (querySnapshot,err) in
                    var count = 0
                    if let err = err {
                        print("\(err)")
                        return
                    } else {
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        var postArray: [PostData] = []
                        postArray = querySnapshot!.documents.map { document in
                            let postData = PostData(document: document)
                            count = 1
                            return postData
                        }
                        
                        if count == 0 {
                            self.createClass()
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            
                            let dialog = UIAlertController(title: "この授業はすでに登録されています", message: "\(self.classNameTextField.text!) (\(self.teacherTextField.text!))はすでに作成されています。授業情報の変更については授業詳細ページの「内容を編集」より行ってください。", preferredStyle: .alert)
                            
                            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(dialog, animated: true, completion: nil)
                        }
                        
                    }
                    
                }
                
            }))
            self.present(dialog, animated: true, completion: nil)
        } else {
            let dialog = UIAlertController(title: "空欄があります", message: "授業名、教員名、教室名、学期、時間は空欄にできません", preferredStyle: .alert)
            
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
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
            return 6
        } else if pickerView == facultyPickerView {
            return dataList2.count
        } else {
            return dataList4.count
        }
    }
    
    //    textFieldのキーボードにpickerViewを表示
    func createPickerView() {
        
        dayPickerView.delegate = self
        facultyPickerView.delegate = self
        seasonPickerView.delegate = self
        
        dayTextField.inputView = dayPickerView
        facultyTextField.inputView = facultyPickerView
        seasonTextField.inputView = seasonPickerView
        
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
        teacherTextField.inputAccessoryView = toolBar
        evaRateTextView.inputAccessoryView = toolBar
        careerTextView.inputAccessoryView = toolBar
        seasonTextField.inputAccessoryView = toolBar
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dayPickerView {
            return dataList[component][row]
        } else if pickerView == facultyPickerView {
            return dataList2[row]
        } else {
            return dataList4[row]
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
        } else if pickerView == facultyPickerView {
            if row == 0 {
                facultyTextField.text = ""
            } else {
                facultyTextField.text = dataList2[row]
            }
        } else {
            seasonTextField.text = dataList4[row]
        }
    }
    @objc func donePicker() {
        classNameTextField.endEditing(true)
        dayTextField.endEditing(true)
        facultyTextField.endEditing(true)
        classTextField.endEditing(true)
        teacherTextField.endEditing(true)
        evaRateTextView.endEditing(true)
        careerTextView.endEditing(true)
        seasonTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        classNameTextField.endEditing(true)
        dayTextField.endEditing(true)
        facultyTextField.endEditing(true)
        classTextField.endEditing(true)
        teacherTextField.endEditing(true)
        evaRateTextView.endEditing(true)
        careerTextView.endEditing(true)
        seasonTextField.endEditing(true)
    }
    
    
    @objc func tapBackButton(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func createClass() {
        
        //        データの保存先を定義
        let postRef = Firestore.firestore().collection(self.loginApp.collegeNameData).document()
        
        //        FireStoreにデータを保存
        let postDic = [
            "className": self.classNameTextField.text!,
            "season": self.seasonTextField.text!,
            "day": self.day,
            "period": self.period,
            "faculty": self.facultyTextField.text!,
            "teacher": self.teacherTextField.text!,
            "classRoom": self.classTextField.text!,
            "evaRate": self.evaRateTextView.text!,
            "career": self.careerTextView.text!,
            "member": 0,
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
