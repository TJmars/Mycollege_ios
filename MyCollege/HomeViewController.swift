//
//  HomeViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/20.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //    Realm
    let realm = try! Realm()
   var task = Task()
   var index = 0
    
//    日付
   let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
        //       CollectionViewのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        collectionView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
       
               let format = DateFormatter()
        format.dateStyle = .medium
//        日付
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEE", options: 0, locale: Locale.current)
        let daytext =  formatter.string(from: Date())
        let datetext = format.string(from: Date())
        dateLabel.text = "\(datetext) (\(daytext))"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //        Tag番号を使って画像セット
        let classNameLabel = cell.contentView.viewWithTag(1) as! UILabel
                let classRoomLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        let indexNum = indexPath.row + 1
       
        
        let taskArray = try! Realm().objects(Task.self).filter("cellPoint == \(indexNum)")
       
        if taskArray.count != 0 {

            task = taskArray[0]
         classNameLabel.text = task.className
            classRoomLabel.text = task.classRoom
            cell.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)

        } else {
            classNameLabel.text = ""
            classRoomLabel.text = ""
            cell.backgroundColor = .white
        }
        
       
      
        
       
        return cell
    }
    
    //   セルのレイアウトを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.layer.bounds.width
        let height = self.collectionView.layer.bounds.height
        
        let widthcellSize : CGFloat = width / 6 - 1
        let heightcellSize : CGFloat = height / 6 - 1
        return CGSize(width: widthcellSize, height: heightcellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let indexNum:Int = indexPath[1] + 1
        
        let taskArray = try! Realm().objects(Task.self).filter("cellPoint == \(indexNum)")
        
        if taskArray.count != 0 {
            performSegue(withIdentifier: "toDetailClass", sender: nil)
            
        } else {
            performSegue(withIdentifier: "toChoice", sender: nil)
        }
        
    }
    
    
    //    画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        let indexPath = self.collectionView.indexPathsForSelectedItems![0]
        let indexNum = indexPath[1] + 1
        let indexNo = indexPath[1]
        
        if segue.identifier == "toDetailClass" {
            let detailClassViewController:DetailClassViewController = segue.destination as! DetailClassViewController
            let taskArray = try! Realm().objects(Task.self).filter("cellPoint == \(indexNum)")
            detailClassViewController.task = taskArray[0]
            detailClassViewController.checkSegue = 0
            
        } else {
            let ChoiceClassListViewController:choiceClassListViewController = segue.destination as! choiceClassListViewController
            let segueDay = indexNo % 6
            let seguePeriod = indexNo / 6
            
            switch segueDay {
            case 0:
                ChoiceClassListViewController.daytext = "月曜"
            case 1:
                ChoiceClassListViewController.daytext = "火曜"
            case 2:
                ChoiceClassListViewController.daytext = "水曜"
            case 3:
                ChoiceClassListViewController.daytext = "木曜"
            case 4:
                ChoiceClassListViewController.daytext = "金曜"
            case 5:
                ChoiceClassListViewController.daytext = "土曜"
            default:
                ChoiceClassListViewController.daytext = "月曜"
            }
            
            switch seguePeriod {
            case 0:
                ChoiceClassListViewController.periodtext = "1限"
            case 1:
                ChoiceClassListViewController.periodtext = "2限"
            case 2:
                ChoiceClassListViewController.periodtext = "3限"
            case 3:
                ChoiceClassListViewController.periodtext = "4限"
            case 4:
                ChoiceClassListViewController.periodtext = "5限"
            case 5:
                ChoiceClassListViewController.periodtext = "6限"
            default:
                ChoiceClassListViewController.periodtext = "1限"
            }
        }
        
        
    }
    
    
    @IBAction func logoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        tabBarController?.selectedIndex = 0
    }
    
    
}
