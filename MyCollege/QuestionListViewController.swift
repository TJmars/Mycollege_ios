//
//  QuestionListViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/08/19.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class QuestionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var Abutton: UIButton!
    
    
    
    
    
    var documentID = ""
    var childNum = 0
    var titleText = ""
    var contentText = ""
    var answerCount = 0
    var indexNum = 0
    var checkSegue = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
       
        
        Abutton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        Abutton.layer.cornerRadius = 10.0
        Abutton.clipsToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 300
        tableView.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
        //        カスタムセルを登録
        let nib = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        
        
        let storage = Storage.storage()
        
        
        let MAX_SIZE:Int64 = 1024 * 1024
        
        
        let nameRef = storage.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(childNum)").child("name")
        
        
        nameRef.getData(maxSize: MAX_SIZE) { result, error in
            self.nameLabel.text = String(data: result!, encoding: String.Encoding.utf32)
            
        }
        answerCountNum()
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if answerCount <= 3 {
            return 1
        } else {
            return answerCount - 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! QuestionTableViewCell
        cell.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
        if indexPath.row == 0 {
            let storage = Storage.storage()
            
            let textRef = storage.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(childNum)").child("title")
            
            let MAX_SIZE:Int64 = 1024 * 1024
            textRef.getData(maxSize: MAX_SIZE) { result, error in
                cell.titleLabel?.text = String(data: result!, encoding: String.Encoding.utf32)
                self.titleText = String(data: result!, encoding: String.Encoding.utf32)!
            }
            let contentRef = storage.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(childNum)").child("content")
            contentRef.getData(maxSize: MAX_SIZE) { result, error in
                cell.contentLabel?.text = String(data: result!, encoding: String.Encoding.utf32)
                self.contentText = String(data: result!, encoding: String.Encoding.utf32)!
            }


        } else {
            
            let storages = Storage.storage()
            let contentRef = storages.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(childNum)").child("answer\(indexPath.row)")
            let MAX_SIZE:Int64 = 1024 * 1024
            
            contentRef.getData(maxSize: MAX_SIZE) { result, error in
                cell.contentLabel?.text = String(data: result!, encoding: String.Encoding.utf32)
            }
            
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
        } else {
            let modalViewController:ModalViewController = segue.destination as! ModalViewController
            modalViewController.documentID = documentID
            modalViewController.childNum = childNum
            modalViewController.answerCount = answerCount
            modalViewController.checkSegue = checkSegue
            modalViewController.indexNum = indexNum
        }
    }
    
    
    
    
    func answerCountNum() {
        let storage1 = Storage.storage()
        let storageReference = storage1.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(childNum)")
        storageReference.listAll { (result, error) in
            if let error = error {
                // ...
            }
            for prefix in result.prefixes {
                
            }
            for item in result.items {
                // The items under storageReference.
                self.answerCount += 1
                self.tableView.reloadData()
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
         self.dismiss(animated: true, completion: nil)
    }
    
    
}
