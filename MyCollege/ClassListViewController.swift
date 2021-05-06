//
//  ClassListViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/20.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

//講義検索画面　様々な条件で検索

import UIKit
import Firebase
import RealmSwift

class ClassListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var facultyTextField: UITextField!
    @IBOutlet weak var seasonTextField: UITextField!
    @IBOutlet weak var teacherTextField: UITextField!
    @IBOutlet weak var searchTitleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //    投稿データを格納
    var postArray: [PostData] = []
    var documentIDArray:[String] = []
    
    //    Firebaseのリスナー
    var listener: ListenerRegistration!
    
    var noDataLabel = UILabel()
    var noDataCount = 0
    
    
    var dayPickerView = UIPickerView()
    var facultyPickerView = UIPickerView()
    var seasonPickerView = UIPickerView()
    
    var day = ""
    var period = ""
    
    let dataList = [["すべての曜日","月曜","火曜","水曜","木曜","金曜", "土曜"],["すべての時間","1限","2限","3限","4限","5限","6限"]]
    let dataList2 = ["すべての学部","経済","社会","人文"]
    let dataList3 = ["未指定","春学期","秋学期","通年"]
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }

        
        createPickerView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //        カスタムセルを登録
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        searchTitleButton.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        searchTitleButton.layer.cornerRadius = 10
        searchTitleButton.clipsToBounds = true
        
        //    データがない時
        
        noDataLabel.frame = CGRect(x: self.tableView.frame.size.width / 2 - 100, y: self.tableView.frame.size.height / 3, width: 200, height: 100)
        noDataLabel.text = "Sorry,there is no data."
        noDataLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        noDataLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        noDataLabel.numberOfLines = 0
        noDataLabel.contentMode = .center
    }
    
    
//    pickerViewの設定
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
        } else if pickerView == facultyPickerView {
            return dataList2.count
        } else {
            return dataList3.count
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
        seasonTextField.inputAccessoryView = toolBar
        teacherTextField.inputAccessoryView = toolBar
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dayPickerView {
            return dataList[component][row]
        } else if pickerView == facultyPickerView {
            return dataList2[row]
        } else {
            return dataList3[row]
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
        } else if pickerView == facultyPickerView {
            if row == 0 {
                facultyTextField.text = ""
            } else {
                facultyTextField.text = dataList2[row]
            }
        } else {
            if row == 0 {
                seasonTextField.text = ""
            } else {
                seasonTextField.text = dataList3[row]
            }
        }
    }
    @objc func donePicker() {
        classNameTextField.endEditing(true)
        dayTextField.endEditing(true)
        facultyTextField.endEditing(true)
        seasonTextField.endEditing(true)
        teacherTextField.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        classNameTextField.endEditing(true)
        dayTextField.endEditing(true)
        facultyTextField.endEditing(true)
        seasonTextField.endEditing(true)
        teacherTextField.endEditing(true)
    }
    
    
    
    
    //    検索ボタン
    @IBAction func searchButton(_ sender: Any) {
        noDataCount = 0
        documentIDArray = []
        var searchTitleArray:[String] = []
        var searchContentsArray:[String] = []
        
        if classNameTextField.text != "" {
            searchTitleArray.append("className")
            searchContentsArray.append(classNameTextField.text!)
        }
        if day != "" {
            searchTitleArray.append("day")
            searchContentsArray.append(day)
        }
        if period != "" {
            searchTitleArray.append("period")
            searchContentsArray.append(period)
        }
        if facultyTextField.text != "" {
            searchTitleArray.append("faculty")
            searchContentsArray.append(facultyTextField.text!)
        }
        if seasonTextField.text != "" {
            searchTitleArray.append("season")
            searchContentsArray.append(seasonTextField.text!)
        }
        if teacherTextField.text != "" {
            searchContentsArray.append("teacher")
            searchContentsArray.append(teacherTextField.text!)
        }
        
        if Auth.auth().currentUser != nil {
            //            ログイン済
            if listener == nil {
                if searchTitleArray.count == 1 {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(loginApp.collegeNameData).whereField("\(searchTitleArray[0])", isEqualTo: "\(searchContentsArray[0])").getDocuments() { (querySnapshot,err) in
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
                } else if searchTitleArray.count == 2 {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(loginApp.collegeNameData).whereField("\(searchTitleArray[0])", isEqualTo: "\(searchContentsArray[0])").whereField("\(searchTitleArray[1])", isEqualTo: "\(searchContentsArray[1])").getDocuments() { (querySnapshot,err) in
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
                } else if searchTitleArray.count == 3 {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(loginApp.collegeNameData).whereField("\(searchTitleArray[0])", isEqualTo: "\(searchContentsArray[0])").whereField("\(searchTitleArray[1])", isEqualTo: "\(searchContentsArray[1])").whereField("\(searchTitleArray[2])", isEqualTo: "\(searchContentsArray[2])").getDocuments() { (querySnapshot,err) in
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
                } else if searchTitleArray.count == 4 {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(loginApp.collegeNameData).whereField("\(searchTitleArray[0])", isEqualTo: "\(searchContentsArray[0])").whereField("\(searchTitleArray[1])", isEqualTo: "\(searchContentsArray[1])").whereField("\(searchTitleArray[2])", isEqualTo: "\(searchContentsArray[2])").whereField("\(searchTitleArray[3])", isEqualTo: "\(searchContentsArray[3])").getDocuments() { (querySnapshot,err) in
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
                } else if searchTitleArray.count == 5 {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(loginApp.collegeNameData).whereField("\(searchTitleArray[0])", isEqualTo: "\(searchContentsArray[0])").whereField("\(searchTitleArray[1])", isEqualTo: "\(searchContentsArray[1])").whereField("\(searchTitleArray[2])", isEqualTo: "\(searchContentsArray[2])").whereField("\(searchTitleArray[3])", isEqualTo: "\(searchContentsArray[3])").whereField("\(searchTitleArray[4])", isEqualTo: "\(searchContentsArray[4])").getDocuments() { (querySnapshot,err) in
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
                } else if searchTitleArray.count == 6 {
                    // listener未登録なら、登録してスナップショットを受信する
                    let postsRef = Firestore.firestore().collection(loginApp.collegeNameData).whereField("\(searchTitleArray[0])", isEqualTo: "\(searchContentsArray[0])").whereField("\(searchTitleArray[1])", isEqualTo: "\(searchContentsArray[1])").whereField("\(searchTitleArray[2])", isEqualTo: "\(searchContentsArray[2])").whereField("\(searchTitleArray[3])", isEqualTo: "\(searchContentsArray[3])").whereField("\(searchTitleArray[4])", isEqualTo: "\(searchContentsArray[4])").whereField("\(searchTitleArray[5])", isEqualTo: "\(searchContentsArray[5])").getDocuments() { (querySnapshot,err) in
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
                    let dialog = UIAlertController(title: "該当データが多すぎます", message: "1つ以上の条件を入力してください", preferredStyle: .alert)
                    
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self.present(dialog, animated: true, completion: nil)
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
        tableView.reloadData()
        print("C")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postArray.count == 0 {
            if noDataCount == 0 {
                tableView.separatorStyle = .none
                self.tableView.addSubview(noDataLabel)
                noDataCount += 1
                print("A")
            }
        } else {
            tableView.separatorStyle = .singleLine
            noDataLabel.removeFromSuperview()
            print("B")
        }

        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "toDetail", sender: nil)
        
        performSegue(withIdentifier: "toTop", sender: nil)
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
            
        } else if segue.identifier == "toTop" {
            let classTopViewController: ClassTopViewController = segue.destination as! ClassTopViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            classTopViewController.postData = postArray[indexPath!.row]
            classTopViewController.documentID = documentIDArray[indexPath!.row]
            classTopViewController.checkSegue = 1
        }
        
    }
    
    
}
