//
//  HomeViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/20.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

//時間割画面

import UIKit
import RealmSwift
import Firebase
import Lottie

class HomeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logoutTitleButton: UIButton!
    
    
    //    Realm
    let realm = try! Realm()
    var task = Task()
    var index = 0
    
    var seasonNum = 0
    
    //    日付
    let formatter = DateFormatter()
    let format = DateFormatter()
    
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
        
        
        
        format.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMdd", options: 0, locale: Locale.current)
        //        日付
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEE", options: 0, locale: Locale.current)
        let daytext =  formatter.string(from: Date())
        let datetext = format.string(from: Date())
        dateLabel.text = "\(datetext) (\(daytext))"
        
        logoutTitleButton.layer.borderWidth = 1.0
        logoutTitleButton.layer.borderColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1).cgColor
        logoutTitleButton.layer.cornerRadius = 15
        logoutTitleButton.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    @IBAction func segumentControll(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            seasonNum = 0
            collectionView.reloadData()
        case 1:
            seasonNum = 1
            collectionView.reloadData()
        default:
            seasonNum = 0
            collectionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 36
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //        Tag番号を使ってセット
        let classNameLabel = cell.contentView.viewWithTag(1) as! UILabel
        let classRoomLabel = cell.contentView.viewWithTag(2) as! UILabel
        
        let indexNum = indexPath.row + 1
        var taskArray = try! Realm().objects(Task.self)
        
        if seasonNum == 0 {
            taskArray = try! Realm().objects(Task.self).filter("cellPoint == \(indexNum)").filter("season == '春学期' || season == '通年' ")
        } else {
            taskArray = try! Realm().objects(Task.self).filter("cellPoint == \(indexNum)").filter("season == '秋学期' || season == '通年' ")
        }
        
        if taskArray.count != 0 {
            
            task = taskArray[0]
            classNameLabel.text = task.className
            classRoomLabel.text = task.classRoom
            switch task.colorNum {
            case 0:
                classNameLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
                classRoomLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
            case 1:
                classNameLabel.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1)
                classRoomLabel.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1)
            case 2:
                classNameLabel.backgroundColor = UIColor(red: 1.0, green: 0.7, blue: 0.8, alpha: 1)
                classRoomLabel.backgroundColor = UIColor(red: 1.0, green: 0.7, blue: 0.8, alpha: 1)
            case 3:
                classNameLabel.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 1.0, alpha: 1)
                classRoomLabel.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 1.0, alpha: 1)
            case 4:
                classNameLabel.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1)
                classRoomLabel.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1)
            case 5:
                classNameLabel.backgroundColor = UIColor(red: 1.0, green: 0.7, blue: 0.6, alpha: 1)
                classRoomLabel.backgroundColor = UIColor(red: 1.0, green: 0.7, blue: 0.6, alpha: 1)
            default:
                classNameLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
                classRoomLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
            }
            cell.backgroundColor = .white
            
        } else {
            classNameLabel.text = ""
            classRoomLabel.text = ""
            classRoomLabel.backgroundColor = .white
            classNameLabel.backgroundColor = .white
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
        
        var taskArray = try! Realm().objects(Task.self)
        
        if seasonNum == 0 {
            taskArray = try! Realm().objects(Task.self).filter("cellPoint == \(indexNum)").filter("season == '春学期' || season == '通年' ")
        } else {
            taskArray = try! Realm().objects(Task.self).filter("cellPoint == \(indexNum)").filter("season == '秋学期' || season == '通年' ")
        }
        
        if taskArray.count != 0 {
            //            performSegue(withIdentifier: "toDetailClass", sender: nil)
            performSegue(withIdentifier: "toTop", sender: nil)
            
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
            
        } else if segue.identifier == "toTop" {
            let classTopViewController:ClassTopViewController = segue.destination as! ClassTopViewController
            let taskArray = try! Realm().objects(Task.self).filter("cellPoint == \(indexNum)")
            classTopViewController.task = taskArray[0]
            classTopViewController.checkSegue = 0
            
        } else {
            let ChoiceClassListViewController:choiceClassListViewController = segue.destination as! choiceClassListViewController
            ChoiceClassListViewController.seasonNum = seasonNum
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
        
        let dialog = UIAlertController(title: "ログアウト", message: "現在のアカウントからログアウトしますか？", preferredStyle: .alert)
        
        dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            try! Auth.auth().signOut()
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
            
            self.tabBarController?.selectedIndex = 0
            

        }))
        
        self.present(dialog, animated: true, completion: nil)
    }
    
    
    
}

class StartAnimeViewController: UIViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var rogoView: UIView!
    
    
    var animationView:AnimationView = AnimationView()
    var animatview:AnimationView = AnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let animation = Animation.named("smile")
            self.animationView.frame = CGRect(x:0, y:0, width: self.rogoView.frame.size.width, height: self.rogoView.frame.size.height)
            self.animationView.animation = animation
            self.animationView.contentMode = .scaleAspectFit
            self.animationView.loopMode = .playOnce
            self.animationView.backgroundColor = .clear
            self.rogoView.addSubview(self.animationView)
            self.animationView.play()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            let animat = Animation.named("title")
            self.animatview.frame = CGRect(x: 0, y: 0, width: self.titleView.frame.size.width, height: self.titleView.frame.size.height)
            self.animatview.animation = animat
            self.animatview.contentMode = .scaleAspectFill
            self.animatview.loopMode = .playOnce
            self.animatview.backgroundColor = .clear
            self.titleView.addSubview(self.animatview)
            self.animatview.play()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
           self.performSegue(withIdentifier: "toTab", sender: nil)
        }

    }
    

}

