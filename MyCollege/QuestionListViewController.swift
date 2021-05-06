//
//  QuestionListViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/08/19.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class QuestionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var Abutton: UIButton!
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    
    var documentID = ""
    var childNum = 0
    var titleText = ""
    var contentText = ""
    var answerCount = 0
    var indexNum = 0
    var checkSegue = 0
    var questionContent = ""
    var answerContentsArray:[String] = []
    var answerNameArray:[String] = []
    var uuidTime = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
        }

        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
        
        Abutton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        Abutton.layer.cornerRadius = 10.0
        Abutton.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
//        tableView.estimatedRowHeight = 66
//        tableView.rowHeight = UITableView.automaticDimension
      
        
        
        //        カスタムセルを登録
        let nib = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        
        let storage = Storage.storage()
        let MAX_SIZE:Int64 = 1024 * 1024
        let nameRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(documentID + "QE").child("\(uuidTime)").child("name")
        
        
        nameRef.getData(maxSize: MAX_SIZE) { result, error in
            self.nameLabel.text = "\(String(data: result!, encoding: String.Encoding.utf32)!)さんからの質問"
            
        }
        
        
        let contentRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(documentID + "QE").child("\(uuidTime)").child("content")
        
        
        contentRef.getData(maxSize: MAX_SIZE) { result, error in
            self.questionContent = String(data: result!, encoding: String.Encoding.utf32)!
            
              }
        
        answerCountNum()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerContentsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! QuestionTableViewCell
        cell.backgroundColor = .white
        cell.layoutIfNeeded()
        
        
        if indexPath.row == 0 {
            let storage = Storage.storage()
            
            let textRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(documentID + "QE").child("\(uuidTime)").child("title")
            
            let MAX_SIZE:Int64 = 1024 * 1024
            textRef.getData(maxSize: MAX_SIZE) { result, error in
                cell.titleLabel?.text = String(data: result!, encoding: String.Encoding.utf32)
                self.titleText = String(data: result!, encoding: String.Encoding.utf32)!
            }


            cell.contentLabel?.text = questionContent
            self.contentText = questionContent

        } else {
            
            cell.contentLabel?.text = answerContentsArray[indexPath.row - 1]
            cell.titleLabel?.text = "\(answerNameArray[indexPath.row - 1])さんからの回答"
            
        }
        //        セル内のボタン
        cell.imagesButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        return cell
    }
    
    @IBAction func toAnswerButton(_ sender: Any) {
        performSegue(withIdentifier: "toAnswer", sender: nil)
    }
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAnswer" {
            let answerViewController:AnswerViewController = segue.destination as! AnswerViewController
            answerViewController.documentID = documentID
            answerViewController.titleText = titleText
            answerViewController.contentText = contentText
            answerViewController.childNum = childNum
            answerViewController.answerCount = answerCount
            answerViewController.uuidTime = uuidTime
        } else {
            let modalViewController:ModalViewController = segue.destination as! ModalViewController
            modalViewController.documentID = documentID
            modalViewController.childNum = childNum
            modalViewController.answerCount = answerCount
            modalViewController.checkSegue = checkSegue
            modalViewController.indexNum = indexNum
            modalViewController.uuidTime = uuidTime
            
        }
    }
    
    
    
    func answerCountNum() {
        let storage1 = Storage.storage()
        let MAX_SIZE:Int64 = 1024 * 1024
        let storageReference = storage1.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(documentID + "QE").child("\(uuidTime)")
        storageReference.listAll { (result, error) in
            if let error = error {
                // ...
            }
            for (count, prefix) in result.prefixes.enumerated() {
//                コンテンツの読み取り
                let contentRef = storage1.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(self.documentID + "QE").child("\(self.uuidTime)").child("answer\(count + 1)").child("content")
                
                
                
                contentRef.getData(maxSize: MAX_SIZE) { result, error in
                    let content = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    self.answerContentsArray.append(content)
                     
                    if self.answerNameArray.count == self.answerContentsArray.count {
                                           self.tableView.reloadData()
                                       }
                    
                }
                

//                名前の読み取り
                let nameRef = storage1.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(self.documentID + "QE").child("\(self.uuidTime)").child("answer\(count + 1)").child("name")
                
                nameRef.getData(maxSize: MAX_SIZE) { result, error in
                    let name = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    self.answerNameArray.append(name)
                     
                    if self.answerNameArray.count == self.answerContentsArray.count {
                        self.tableView.reloadData()
                    }
                }
                
                self.answerCount += 1
               
            }
         
        }
       
    }
    
//    セル内のボタン
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
       
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        indexNum = indexPath!.row 
       
        
//        画面遷移
        if indexNum == 0 {
            checkSegue = 0
        } else {
             checkSegue = 1
        }
        performSegue(withIdentifier: "modal", sender: nil)
    }
    
    @IBAction func returnButton(_ sender: Any) {
       
        answerNameArray = []
        answerContentsArray = []
         self.dismiss(animated: true, completion: nil)
    }
    
    
}
