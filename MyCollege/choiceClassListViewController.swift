//
//  choiceClassListViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

//時間割画面で空欄をタップした時に遷移してくる

import UIKit
import Firebase
import RealmSwift

class choiceClassListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segumentTitle: UISegmentedControl!
    
    
    //    投稿データを格納
    var postArray: [PostData] = []
    var postArray2:[PostData] = []
    var documentIDArray:[String] = []
    var postArrayData:[PostData] = []
    
    //    Firebaseのリスナー
    var listener: ListenerRegistration!
    
    //    choiceViewControllerから受け取る
    var daytext = ""
    var periodtext = ""
    var seasonNum = 0
    var season = ""
    
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
        
        segumentTitle.setTitle("\(loginApp.facultyData)学部のみ", forSegmentAt: 0)
        segumentTitle.setTitle("全て", forSegmentAt: 1)

        
        tableView.delegate = self
        tableView.dataSource = self
        
        dayLabel.text = daytext + periodtext
        //        カスタムセルを登録
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        documentIDArray = []
        
        if Auth.auth().currentUser != nil {
            //            ログイン済
            if listener == nil {
                
                if seasonNum == 0 {
                    season = "春学期"
                    getClass()
                    
                } else {
                    season = "秋学期"
                    getClass()
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
        
        return postArrayData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArrayData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "goToDetail", sender: nil)
        performSegue(withIdentifier: "toTop", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        let detailViewController: DetailClassViewController = segue.destination as! DetailClassViewController
        //        let indexPath = self.tableView.indexPathForSelectedRow
        //        detailViewController.postData = postArray[indexPath!.row]
        //        detailViewController.documentID = documentIDArray[indexPath!.row]
        //        detailViewController.checkSegue = 1
        
        if segue.identifier == "toTop" {
            let classTopViewController: ClassTopViewController = segue.destination as! ClassTopViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            classTopViewController.postData = postArrayData[indexPath!.row]
            classTopViewController.documentID = documentIDArray[indexPath!.row]
            classTopViewController.checkSegue = 1
            
        }
    }
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func segumentControll(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            getClass()
        case 1:
            getClass2()
        default:
            getClass()
        }
    }
    
    //    時間割から受け取った時間の授業を取得する
    func getClass() {
        postArrayData = []
        // listener未登録なら、登録してスナップショットを受信する
        let postsRef = Firestore.firestore().collection(loginApp.collegeNameData).whereField("day", isEqualTo: daytext).whereField("period", isEqualTo: periodtext).whereField("season", isEqualTo: "\(season)" ).whereField("faculty", isEqualTo: loginApp.facultyData).getDocuments() { (querySnapshot,err) in
            if let err = err {
                print("DEBUG_PRINY: \(err)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.postArray = querySnapshot!.documents.map { document in
                self.documentIDArray.append(document.documentID)
                print("1")
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let postData = PostData(document: document)
                return postData
            }
            self.postArrayData.append(contentsOf: self.postArray)
            
            // TableViewの表示を更新する
            self.tableView.reloadData()
            
        }
        
        let postsRefs = Firestore.firestore().collection(loginApp.collegeNameData).whereField("day", isEqualTo: daytext).whereField("period", isEqualTo: periodtext).whereField("season", isEqualTo: "通年" ).whereField("faculty", isEqualTo: loginApp.facultyData).getDocuments() { (querySnapshot,err) in
            if let err = err {
                print("DEBUG_PRINY: \(err)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.postArray2 = querySnapshot!.documents.map { document in
                self.documentIDArray.append(document.documentID)
                
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let postData = PostData(document: document)
                return postData
            }
            self.postArrayData.append(contentsOf: self.postArray2)
            
            // TableViewの表示を更新する
            self.tableView.reloadData()
            
        }
        
    }
    
    func getClass2() {
        postArrayData = []
        // listener未登録なら、登録してスナップショットを受信する
        let postsRef = Firestore.firestore().collection(loginApp.collegeNameData).whereField("day", isEqualTo: daytext).whereField("period", isEqualTo: periodtext).whereField("season", isEqualTo: "\(season)" ).getDocuments() { (querySnapshot,err) in
            if let err = err {
                print("DEBUG_PRINY: \(err)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.postArray = querySnapshot!.documents.map { document in
                self.documentIDArray.append(document.documentID)
                print("1")
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let postData = PostData(document: document)
                return postData
            }
            self.postArrayData.append(contentsOf: self.postArray)
            
            // TableViewの表示を更新する
            self.tableView.reloadData()
            
        }
        
        let postsRefs = Firestore.firestore().collection(loginApp.collegeNameData).whereField("day", isEqualTo: daytext).whereField("period", isEqualTo: periodtext).whereField("season", isEqualTo: "通年" ).getDocuments() { (querySnapshot,err) in
            if let err = err {
                print("DEBUG_PRINY: \(err)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.postArray2 = querySnapshot!.documents.map { document in
                self.documentIDArray.append(document.documentID)
                
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let postData = PostData(document: document)
                return postData
            }
            self.postArrayData.append(contentsOf: self.postArray2)
            
            // TableViewの表示を更新する
            self.tableView.reloadData()
            
        }
        
    }
    
}
