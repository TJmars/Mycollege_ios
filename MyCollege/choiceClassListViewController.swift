//
//  choiceClassListViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class choiceClassListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //    投稿データを格納
    var postArray: [PostData] = []
    var documentIDArray:[String] = []
    
    //    Firebaseのリスナー
    var listener: ListenerRegistration!
    
//    choiceViewControllerから受け取る
    var daytext = ""
    var periodtext = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
                
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).whereField("day", isEqualTo: daytext).whereField("period", isEqualTo: periodtext).getDocuments() { (querySnapshot,err) in
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
        performSegue(withIdentifier: "goToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController: DetailClassViewController = segue.destination as! DetailClassViewController
        let indexPath = self.tableView.indexPathForSelectedRow
        detailViewController.postData = postArray[indexPath!.row]
        detailViewController.documentID = documentIDArray[indexPath!.row]
        detailViewController.checkSegue = 1
    }
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
