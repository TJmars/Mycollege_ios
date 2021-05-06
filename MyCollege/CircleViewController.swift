//
//  CircleViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/09/13.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class CircleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    
    var teamName = ""
    var image = UIImage()
    var uuidTime = ""
    var genre = ""
    
    var faculty = ""
    var act = ""
    var dayPlace = ""
    var cost = ""
    var member = ""
    var contact = ""
    
    var contentCount = 0
    

    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
        }
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        let storage = Storage.storage()
        let MAX_SIZE:Int64 = 1024 * 1024
        
        let facultyRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("faculty")
        
        facultyRef.getData(maxSize: MAX_SIZE) { result, error in
            self.faculty = String(data: result!, encoding: String.Encoding.utf32)!
            self.tableView.reloadData()
        }
        
        let actRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("act")
        
        actRef.getData(maxSize: MAX_SIZE) { result, error in
            self.act = String(data: result!, encoding: String.Encoding.utf32)!
            
            self.tableView.reloadData()
           
        }
        
        let dayPlaceRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("dayPlace")
        
        dayPlaceRef.getData(maxSize: MAX_SIZE) { result, error in
            self.dayPlace = String(data: result!, encoding: String.Encoding.utf32)!
            self.tableView.reloadData()
        }
        
        let costRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("cost")
        
        costRef.getData(maxSize: MAX_SIZE) { result, error in
            self.cost = String(data: result!, encoding: String.Encoding.utf32)!
            self.tableView.reloadData()
        }
        
        let memberRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("member")
        
        memberRef.getData(maxSize: MAX_SIZE) { result, error in
            self.member = String(data: result!, encoding: String.Encoding.utf32)!
            self.tableView.reloadData()
        }
        
        let contactRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("contact")
        
        contactRef.getData(maxSize: MAX_SIZE) { result, error in
            self.contact = String(data: result!, encoding: String.Encoding.utf32)!
           self.tableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        switch indexPath.row {
        case 0:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let teamNameLabel = cell.contentView.viewWithTag(1) as! UILabel
            teamNameLabel.text = teamName
            
            return cell
        case 1:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            
            let imageView = cell.contentView.viewWithTag(1) as! UIImageView
            imageView.image = image
            
            return cell
        case 2:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath)
            
            let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
            let contentLabel = cell.contentView.viewWithTag(2) as! UILabel
            titleLabel.text = "活動内容"
            contentLabel.text = act
            
            
            return cell
            
        case 3:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath)
            
            let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
            let contentLabel = cell.contentView.viewWithTag(2) as! UILabel
            titleLabel.text = "対象学部、キャンパスなど"
            contentLabel.text = faculty
            
            
            return cell
            
        case 4:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath)
            
            let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
            let contentLabel = cell.contentView.viewWithTag(2) as! UILabel
            titleLabel.text = "活動日、場所など"
            contentLabel.text = dayPlace
            
            
            return cell
            
        case 5:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath)
            
            let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
            let contentLabel = cell.contentView.viewWithTag(2) as! UILabel
            titleLabel.text = "費用"
            contentLabel.text = cost
            
            
            return cell
        case 6:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath)
            
            let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
            let contentLabel = cell.contentView.viewWithTag(2) as! UILabel
            titleLabel.text = "人数構成"
            contentLabel.text = member
            
            
            return cell
            
        default:
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath)
            
            let titleLabel = cell.contentView.viewWithTag(1) as! UILabel
            let contentLabel = cell.contentView.viewWithTag(2) as! UILabel
            titleLabel.text = "連絡先"
            contentLabel.text = contact
            
            
            return cell
        }
    }
    
    func createTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
