//
//  ClassListViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/20.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class ClassListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    
    @IBOutlet weak var classNameTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var facultyTextField: UITextField!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //    投稿データを格納
    var postArray: [PostData] = []
    var documentIDArray:[String] = []
    
    
    
    
    //    Firebaseのリスナー
    var listener: ListenerRegistration!
    
    
    
    var dayPickerView = UIPickerView()
    var facultyPickerView = UIPickerView()
    
    
    var day = ""
    var period = ""
    
    let dataList = [["すべての曜日","月曜","火曜","水曜","木曜","金曜", "土曜"],["すべての時間","1限","2限","3限","4限","5限","6限"]]
    let dataList2 = ["すべての学部","経済","社会","人文"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createPickerView()
        print("we")
        tableView.delegate = self
        tableView.dataSource = self
        
        //        カスタムセルを登録
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
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
                day = data1
            }
            if data2 == "すべての時間" {
                data2 = ""
                period = data2
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
    
    //    検索ボタン
    @IBAction func searchButton(_ sender: Any) {
        
        documentIDArray = []
        
        if Auth.auth().currentUser != nil {
            //            ログイン済
            if listener == nil {
                if classNameTextField.text != "" {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("className", isEqualTo:  classNameTextField.text!).getDocuments() { (querySnapshot,err) in
                        if let err = err {
                            print("DEBUG_PRINY: \(err)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            self.documentIDArray.append(document.documentID)
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                        
                    }
                } else if day != "" && period != "" && facultyTextField.text != "" {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("day", isEqualTo:  day).whereField("period", isEqualTo: period).whereField("faculty", isEqualTo: facultyTextField.text!).getDocuments() { (querySnapshot,err) in
                        if let err = err {
                            print("DEBUG_PRINY: \(err)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            self.documentIDArray.append(document.documentID)
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                        
                    }
                } else if day != "" && period == "" && facultyTextField.text == "" {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("day", isEqualTo:  day).getDocuments() { (querySnapshot,err) in
                        if let err = err {
                            print("DEBUG_PRINY: \(err)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            self.documentIDArray.append(document.documentID)
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                        
                    }
                } else if day == "" && period != "" && facultyTextField.text == "" {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("period", isEqualTo:  period).getDocuments() { (querySnapshot,err) in
                        if let err = err {
                            print("DEBUG_PRINY: \(err)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            self.documentIDArray.append(document.documentID)
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                        
                    }
                } else if day == "" && period == "" && facultyTextField.text != "" {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("faculty", isEqualTo:  facultyTextField.text!).getDocuments() { (querySnapshot,err) in
                        if let err = err {
                            print("DEBUG_PRINY: \(err)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            self.documentIDArray.append(document.documentID)
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                        
                    }
                } else if day != "" && period != "" && facultyTextField.text == "" {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("day", isEqualTo:  day).whereField("period", isEqualTo: period).getDocuments() { (querySnapshot,err) in
                        if let err = err {
                            print("DEBUG_PRINY: \(err)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            self.documentIDArray.append(document.documentID)
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                        
                    }
                } else if day != "" && period == "" && facultyTextField.text != "" {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("day", isEqualTo:  day).whereField("faculty", isEqualTo: facultyTextField.text!).getDocuments() { (querySnapshot,err) in
                        if let err = err {
                            print("DEBUG_PRINY: \(err)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            self.documentIDArray.append(document.documentID)
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                        
                    }
                } else if day == "" && period != "" && facultyTextField.text != "" {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("period", isEqualTo:  period).whereField("faculty", isEqualTo: facultyTextField.text!).getDocuments() { (querySnapshot,err) in
                        if let err = err {
                            print("DEBUG_PRINY: \(err)")
                            return
                        }
                        // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                        self.postArray = querySnapshot!.documents.map { document in
                            self.documentIDArray.append(document.documentID)
                            print("DEBUG_PRINT: document取得 \(document.documentID)")
                            let postData = PostData(document: document)
                            return postData
                        }
                        // TableViewの表示を更新する
                        self.tableView.reloadData()
                        
                    }
                } else {
                    print("hi")
                }
                
            }
        } else {
//            ログイン未
            if listener != nil {
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    
    @IBAction func newClassButton(_ sender: Any) {
        performSegue(withIdentifier: "toNewClass", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailViewController: DetailClassViewController = segue.destination as! DetailClassViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            detailViewController.postData = postArray[indexPath!.row]
            detailViewController.documentID = documentIDArray[indexPath!.row]
            detailViewController.checkSegue = 1
            
        }
        
    }
    
    
}
