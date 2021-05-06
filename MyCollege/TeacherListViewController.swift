//
//  TeacherListViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/20.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Firebase
import RealmSwift

class TeacherListViewController: ButtonBarPagerTabStripViewController {
    
    
    @IBOutlet weak var adTitleButton: UIButton!
    var appDetail:AppDetail!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
            
        } else {
            appDetail = AppDetail()
            
        }
        
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        settings.style.buttonBarBackgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarMinimumLineSpacing = 15
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14.0)
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
        adTitleButton.layer.borderWidth = 1.0
        adTitleButton.layer.borderColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1).cgColor
        adTitleButton.layer.cornerRadius = 15
        adTitleButton.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First")
        let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Second")
        let thirdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Third")
        let fourthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Fourth")
        let fifthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Fifth")
        
        
        let childViewControllers:[UIViewController] = [firstVC, secondVC, thirdVC, fourthVC, fifthVC]
        return childViewControllers
    }
    
    @IBAction func adButton(_ sender: Any) {
        performSegue(withIdentifier: "toMakeAd", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let makeAdViewController: MakeAdViewController = segue.destination as! MakeAdViewController
        makeAdViewController.checkSegue = 0
    }
    
    
}


class FirstViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let teacherViewController = TeacherListViewController()
    var appDetail:AppDetail!
    
    struct Team {
        var teamNames:String = ""
        var images:UIImage? = nil
        var uuidTimes:String = ""
        var passwords:String = ""
    }
    
    var teamArray = [Team]()
    let realm = try! Realm()
    var loginApp:LoginApp!
    
    
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "球技"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var teamName = ""
    var image = UIImage()
    var uuidTime = ""
    var password = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }
        
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
            
        } else {
            appDetail = AppDetail()
            
        }
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //       CollectionViewのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        if appDetail.count1 == 0 {
            getdata()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if appDetail.count1 != 0 {
            getdata()
        }
        
        try! self.realm.write {
            self.appDetail.count1 = 0
            
            self.realm.add(self.appDetail)
        }
    }
    
    func getdata() {
        teamArray = [Team]()
        teamName = ""
        image = UIImage()
        uuidTime = ""
        password = ""
        let storage = Storage.storage()
        let storageReference = storage.reference().child(loginApp.collegeNameData).child(Const.CirclePath).child("球技")
        storageReference.listAll { (result, error) in
            if let error = error {
                print("ERROR\(error)")
            }
            for prefix in result.prefixes {
                let prefixStr = "\(prefix)"
                let arr:[String] = prefixStr.components(separatedBy: "/")
                
                var team = Team()
                //                uuidの取得
                //                self.uuidTimeArray.append(arr[6])
                team.uuidTimes = arr[6]
                
                //                団体名と画像をとパスワードを取得
                let storageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("球技").child("\(arr[6])").child("teamName")
                let MAX_SIZE:Int64 = 1024 * 1024
                storageRef.getData(maxSize: MAX_SIZE) { result, error in
                    let teamName = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.teamNames = teamName
                    
                    if team.images != nil && team.passwords != ""{
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let passwordRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("球技").child("\(arr[6])").child("passWord")
                
                passwordRef.getData(maxSize: MAX_SIZE) { result, error in
                    let password = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.passwords = password
                    
                    if team.images != nil && team.teamNames != "" {
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("球技").child("\(arr[6])").child("image")
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    
                    if let error = error {
                        print("エラー\(error)")
                        
                        
                    } else {
                        let image = UIImage(data: data!)
                        
                        team.images = image
                        
                        if team.teamNames != "" && team.passwords != "" {
                            self.teamArray.append(team)
                            self.collectionView.reloadData()
                        }
                    }
                }
                
            }
            
            
        }
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return teamArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        
        //        Tag番号でタイトルと画像をセット
        let teamNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let editButton = cell.contentView.viewWithTag(3) as! UIButton
        editButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        let team = teamArray[indexPath.row]
        teamNameLabel.text = team.teamNames
        imageView.image = team.images
        imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    //   セルのレイアウトを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.layer.bounds.width
        let height = self.collectionView.layer.bounds.height
        
        let widthcellSize : CGFloat = width / 2 - 1
        let heightcellSize : CGFloat = height / 3.5 - 1
        return CGSize(width: widthcellSize, height: heightcellSize)
    }
    
    //    編集ボタンタップ
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        
        var alertTextField: UITextField?
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)!
        let team = teamArray[indexPath.row]
        
        
        let alert = UIAlertController(
            title: "パスワード", message: "編集用パスワードを入力してください", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
        })
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "OK", style: UIAlertAction.Style.default) { _ in
                if alertTextField?.text == team.passwords {
                    self.teamName = team.teamNames
                    self.image = team.images!
                    self.uuidTime = team.uuidTimes
                    self.password = team.passwords
                    
                    self.performSegue(withIdentifier: "toMakeAd", sender: nil)
                } else {
                    let alert = UIAlertController(
                        title: "パスワードが違います", message: "入力されたパスワードに誤りがあります", preferredStyle: UIAlertController.Style.alert)
                    
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "OK", style: UIAlertAction.Style.cancel, handler: nil
                        )
                    )
                    self.present(alert, animated: true)
                }
            }
        )
        
        self.present(alert, animated: true)
    }
    
    //    セルタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let team = teamArray[indexPath.row]
        teamName = team.teamNames
        image = team.images!
        uuidTime = team.uuidTimes
        
        
        performSegue(withIdentifier: "toCircle", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCircle" {
            let circleViewController:CircleViewController = segue.destination as! CircleViewController
            circleViewController.teamName = teamName
            circleViewController.image = image
            circleViewController.uuidTime = uuidTime
            circleViewController.genre = "球技"
        } else {
            let makeAdViewController:MakeAdViewController = segue.destination as! MakeAdViewController
            makeAdViewController.teamName = teamName
            makeAdViewController.image = image
            makeAdViewController.uuidTime = uuidTime
            makeAdViewController.password = password
            makeAdViewController.genre = "球技"
            makeAdViewController.checkSegue = 1
        }
    }
}




class SecondViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    var appDetail:AppDetail!
    
    struct Team {
        var teamNames:String = ""
        var images:UIImage? = nil
        var uuidTimes:String = ""
        var passwords:String = ""
    }
    
    var teamArray = [Team]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "その他スポーツ"
    
    
    
    var teamName = ""
    var image = UIImage()
    var uuidTime = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }
        
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
            
        } else {
            appDetail = AppDetail()
            
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //       CollectionViewのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        if appDetail.count2 == 0 {
            getData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if appDetail.count2 != 0 {
            getData()
        }
        try! self.realm.write {
            self.appDetail.count2 = 0
            
            self.realm.add(self.appDetail)
        }
    }
    func getData() {
        teamArray = [Team]()
        teamName = ""
        image = UIImage()
        uuidTime = ""
        password = ""
        
        let storage = Storage.storage()
        let storageReference = storage.reference().child(loginApp.collegeNameData).child(Const.CirclePath).child("その他スポーツ")
        storageReference.listAll { (result, error) in
            if let error = error {
                print("ERROR\(error)")
            }
            for prefix in result.prefixes {
                let prefixStr = "\(prefix)"
                let arr:[String] = prefixStr.components(separatedBy: "/")
                
                var team = Team()
                //                uuidの取得
                //                self.uuidTimeArray.append(arr[6])
                team.uuidTimes = arr[6]
                
                //                団体名と画像を取得
                let storageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("その他スポーツ").child("\(arr[6])").child("teamName")
                let MAX_SIZE:Int64 = 1024 * 1024
                storageRef.getData(maxSize: MAX_SIZE) { result, error in
                    let teamName = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.teamNames = teamName
                    
                    if team.images != nil && team.passwords != "" {
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let passwordRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("その他スポーツ").child("\(arr[6])").child("passWord")
                
                passwordRef.getData(maxSize: MAX_SIZE) { result, error in
                    let password = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.passwords = password
                    
                    if team.images != nil && team.teamNames != "" {
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("その他スポーツ").child("\(arr[6])").child("image")
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    
                    if let error = error {
                        print("エラー\(error)")
                        
                        
                    } else {
                        let image = UIImage(data: data!)
                        
                        team.images = image
                        
                        if team.teamNames != "" && team.passwords != "" {
                            self.teamArray.append(team)
                            self.collectionView.reloadData()
                        }
                    }
                }
                
            }
            
            
        }
    }
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return teamArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        
        //        Tag番号でタイトルと画像をセット
        let teamNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let editButton = cell.contentView.viewWithTag(3) as! UIButton
        editButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        
        let team = teamArray[indexPath.row]
        teamNameLabel.text = team.teamNames
        imageView.image = team.images
        imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    //   セルのレイアウトを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.layer.bounds.width
        let height = self.collectionView.layer.bounds.height
        
        let widthcellSize : CGFloat = width / 2 - 1
        let heightcellSize : CGFloat = height / 3.5 - 1
        return CGSize(width: widthcellSize, height: heightcellSize)
    }
    
    //    セルタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "toCircle", sender: nil)
        
    }
    
    //    編集ボタンタップ
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        
        var alertTextField: UITextField?
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)!
        let team = teamArray[indexPath.row]
        
        
        let alert = UIAlertController(
            title: "パスワード", message: "編集用パスワードを入力してください", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
        })
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "OK", style: UIAlertAction.Style.default) { _ in
                if alertTextField?.text == team.passwords {
                    self.teamName = team.teamNames
                    self.image = team.images!
                    self.uuidTime = team.uuidTimes
                    self.password = team.passwords
                    
                    self.performSegue(withIdentifier: "toMakeAd", sender: nil)
                } else {
                    let alert = UIAlertController(
                        title: "パスワードが違います", message: "入力されたパスワードに誤りがあります", preferredStyle: UIAlertController.Style.alert)
                    
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "OK", style: UIAlertAction.Style.cancel, handler: nil
                        )
                    )
                    self.present(alert, animated: true)
                }
            }
        )
        
        self.present(alert, animated: true)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCircle" {
            let circleViewController:CircleViewController = segue.destination as! CircleViewController
            circleViewController.teamName = teamName
            circleViewController.image = image
            circleViewController.uuidTime = uuidTime
            circleViewController.genre = "その他スポーツ"
        } else {
            let makeAdViewController:MakeAdViewController = segue.destination as! MakeAdViewController
            makeAdViewController.teamName = teamName
            makeAdViewController.image = image
            makeAdViewController.uuidTime = uuidTime
            makeAdViewController.password = password
            makeAdViewController.genre = "その他スポーツ"
            makeAdViewController.checkSegue = 1
        }
        
    }
    
}




class ThirdViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    var appDetail:AppDetail!
    
    struct Team {
        var teamNames:String = ""
        var images:UIImage? = nil
        var uuidTimes:String = ""
        var passwords:String = ""
    }
    
    var teamArray = [Team]()
    
    
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "音楽、ダンス"
    @IBOutlet weak var collectionView: UICollectionView!
    
    var teamName = ""
    var image = UIImage()
    var uuidTime = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
        }
        
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
            
        } else {
            appDetail = AppDetail()
            
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //       CollectionViewのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        if appDetail.count3 == 0 {
            getData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if appDetail.count3 != 0 {
            getData()
        }
        try! self.realm.write {
            self.appDetail.count3 = 0
            
            self.realm.add(self.appDetail)
        }
    }
    
    func getData() {
        teamArray = [Team]()
        teamName = ""
        image = UIImage()
        uuidTime = ""
        password = ""
        let storage = Storage.storage()
        let storageReference = storage.reference().child(loginApp.collegeNameData).child(Const.CirclePath).child("音楽、ダンス")
        storageReference.listAll { (result, error) in
            if let error = error {
                print("ERROR\(error)")
            }
            for prefix in result.prefixes {
                let prefixStr = "\(prefix)"
                let arr:[String] = prefixStr.components(separatedBy: "/")
                
                var team = Team()
                //                uuidの取得
                //                self.uuidTimeArray.append(arr[6])
                team.uuidTimes = arr[6]
                
                //                団体名と画像を取得
                let storageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("音楽、ダンス").child("\(arr[6])").child("teamName")
                let MAX_SIZE:Int64 = 1024 * 1024
                storageRef.getData(maxSize: MAX_SIZE) { result, error in
                    let teamName = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.teamNames = teamName
                    
                    if team.images != nil && team.passwords != "" {
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let passwordRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("音楽、ダンス").child("\(arr[6])").child("passWord")
                
                passwordRef.getData(maxSize: MAX_SIZE) { result, error in
                    let password = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.passwords = password
                    
                    if team.images != nil && team.teamNames != "" {
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("音楽、ダンス").child("\(arr[6])").child("image")
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    
                    if let error = error {
                        print("エラー\(error)")
                        
                        
                    } else {
                        let image = UIImage(data: data!)
                        
                        team.images = image
                        
                        if team.teamNames != "" && team.passwords != ""{
                            self.teamArray.append(team)
                            self.collectionView.reloadData()
                        }
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return teamArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        
        //        Tag番号でタイトルと画像をセット
        let teamNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let editButton = cell.contentView.viewWithTag(3) as! UIButton
        editButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        let team = teamArray[indexPath.row]
        teamNameLabel.text = team.teamNames
        imageView.image = team.images
        imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    //   セルのレイアウトを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.layer.bounds.width
        let height = self.collectionView.layer.bounds.height
        
        let widthcellSize : CGFloat = width / 2 - 1
        let heightcellSize : CGFloat = height / 3.5 - 1
        return CGSize(width: widthcellSize, height: heightcellSize)
    }
    
    //    セルタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        performSegue(withIdentifier: "toCircle", sender: nil)
        
    }
    
    //    編集ボタンタップ
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        
        var alertTextField: UITextField?
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)!
        let team = teamArray[indexPath.row]
        
        
        let alert = UIAlertController(
            title: "パスワード", message: "編集用パスワードを入力してください", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
        })
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "OK", style: UIAlertAction.Style.default) { _ in
                if alertTextField?.text == team.passwords {
                    self.teamName = team.teamNames
                    self.image = team.images!
                    self.uuidTime = team.uuidTimes
                    self.password = team.passwords
                    
                    self.performSegue(withIdentifier: "toMakeAd", sender: nil)
                } else {
                    let alert = UIAlertController(
                        title: "パスワードが違います", message: "入力されたパスワードに誤りがあります", preferredStyle: UIAlertController.Style.alert)
                    
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "OK", style: UIAlertAction.Style.cancel, handler: nil
                        )
                    )
                    self.present(alert, animated: true)
                }
            }
        )
        
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCircle" {
            let circleViewController:CircleViewController = segue.destination as! CircleViewController
            circleViewController.teamName = teamName
            circleViewController.image = image
            circleViewController.uuidTime = uuidTime
            circleViewController.genre = "音楽、ダンス"
        } else {
            let makeAdViewController:MakeAdViewController = segue.destination as! MakeAdViewController
            makeAdViewController.teamName = teamName
            makeAdViewController.image = image
            makeAdViewController.uuidTime = uuidTime
            makeAdViewController.password = password
            makeAdViewController.genre = "音楽、ダンス"
            makeAdViewController.checkSegue = 1
        }
    }
}



class FourthViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    var appDetail:AppDetail!
    
    struct Team {
        var teamNames:String = ""
        var images:UIImage? = nil
        var uuidTimes:String = ""
        var passwords:String = ""
    }
    
    var teamArray = [Team]()
    
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "ボランティア"
    
    var teamName = ""
    var image = UIImage()
    var uuidTime = ""
    var password = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
        }
        
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
            
        } else {
            appDetail = AppDetail()
            
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //       CollectionViewのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        if appDetail.count4 == 0 {
            getData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if appDetail.count4 != 0 {
            getData()
        }
        try! self.realm.write {
            self.appDetail.count4 = 0
            
            self.realm.add(self.appDetail)
        }
    }
    
    func getData() {
        teamArray = [Team]()
        teamName = ""
        image = UIImage()
        uuidTime = ""
        password = ""
        let storage = Storage.storage()
        let storageReference = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("ボランティア")
        storageReference.listAll { (result, error) in
            if let error = error {
                print("ERROR\(error)")
            }
            for prefix in result.prefixes {
                let prefixStr = "\(prefix)"
                let arr:[String] = prefixStr.components(separatedBy: "/")
                
                var team = Team()
                //                uuidの取得
                //                self.uuidTimeArray.append(arr[5])
                team.uuidTimes = arr[6]
                
                //                団体名と画像を取得
                let storageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("ボランティア").child("\(arr[6])").child("teamName")
                let MAX_SIZE:Int64 = 1024 * 1024
                storageRef.getData(maxSize: MAX_SIZE) { result, error in
                    let teamName = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.teamNames = teamName
                    
                    if team.images != nil && team.passwords != ""{
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let passwordRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("ボランティア").child("\(arr[6])").child("passWord")
                
                passwordRef.getData(maxSize: MAX_SIZE) { result, error in
                    let password = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.passwords = password
                    
                    if team.images != nil && team.teamNames != "" {
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("ボランティア").child("\(arr[6])").child("image")
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    
                    if let error = error {
                        print("エラー\(error)")
                        
                        
                    } else {
                        let image = UIImage(data: data!)
                        
                        team.images = image
                        
                        if team.teamNames != "" && team.passwords != "" {
                            self.teamArray.append(team)
                            self.collectionView.reloadData()
                        }
                    }
                }
                
            }
            
            
        }
        
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return teamArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        
        //        Tag番号でタイトルと画像をセット
        let teamNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let editButton = cell.contentView.viewWithTag(3) as! UIButton
        editButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        let team = teamArray[indexPath.row]
        teamNameLabel.text = team.teamNames
        imageView.image = team.images
        imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    //   セルのレイアウトを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.layer.bounds.width
        let height = self.collectionView.layer.bounds.height
        
        let widthcellSize : CGFloat = width / 2 - 1
        let heightcellSize : CGFloat = height / 3.5 - 1
        return CGSize(width: widthcellSize, height: heightcellSize)
    }
    
    //    セルタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "toCircle", sender: nil)
        
    }
    
    //    編集ボタンタップ
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        
        var alertTextField: UITextField?
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)!
        let team = teamArray[indexPath.row]
        
        
        let alert = UIAlertController(
            title: "パスワード", message: "編集用パスワードを入力してください", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
        })
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "OK", style: UIAlertAction.Style.default) { _ in
                if alertTextField?.text == team.passwords {
                    self.teamName = team.teamNames
                    self.image = team.images!
                    self.uuidTime = team.uuidTimes
                    self.password = team.passwords
                    
                    self.performSegue(withIdentifier: "toMakeAd", sender: nil)
                } else {
                    let alert = UIAlertController(
                        title: "パスワードが違います", message: "入力されたパスワードに誤りがあります", preferredStyle: UIAlertController.Style.alert)
                    
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "OK", style: UIAlertAction.Style.cancel, handler: nil
                        )
                    )
                    self.present(alert, animated: true)
                }
            }
        )
        
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCircle" {
            let circleViewController:CircleViewController = segue.destination as! CircleViewController
            circleViewController.teamName = teamName
            circleViewController.image = image
            circleViewController.uuidTime = uuidTime
            circleViewController.genre = "ボランティア"
        } else {
            let makeAdViewController:MakeAdViewController = segue.destination as! MakeAdViewController
            makeAdViewController.teamName = teamName
            makeAdViewController.image = image
            makeAdViewController.uuidTime = uuidTime
            makeAdViewController.password = password
            makeAdViewController.genre = "ボランティア"
            makeAdViewController.checkSegue = 1
        }
        
    }
}

class FifthViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    struct Team {
        var teamNames:String = ""
        var images:UIImage? = nil
        var uuidTimes:String = ""
        var passwords:String = ""
    }
    
    var teamArray = [Team]()
    
    //ここがボタンのタイトルに利用されます
    var itemInfo: IndicatorInfo = "その他"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    var appDetail:AppDetail!
    
    var teamName = ""
    var image = UIImage()
    var uuidTime = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
        }
        
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
            
        } else {
            appDetail = AppDetail()
            
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //       CollectionViewのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        if appDetail.count5 == 0 {
            getData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if appDetail.count5 != 0 {
            getData()
        }
        try! self.realm.write {
            self.appDetail.count5 = 0
            
            self.realm.add(self.appDetail)
        }
    }
    
    func getData() {
        teamArray = [Team]()
        teamName = ""
        image = UIImage()
        uuidTime = ""
        password = ""
        let storage = Storage.storage()
        let storageReference = storage.reference().child(loginApp.collegeNameData).child(Const.CirclePath).child("その他")
        storageReference.listAll { (result, error) in
            if let error = error {
                print("ERROR\(error)")
            }
            for prefix in result.prefixes {
                let prefixStr = "\(prefix)"
                let arr:[String] = prefixStr.components(separatedBy: "/")
                
                var team = Team()
                //                uuidの取得
                //                self.uuidTimeArray.append(arr[5])
                team.uuidTimes = arr[6]
                
                //                団体名と画像を取得
                let storageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("その他").child("\(arr[6])").child("teamName")
                let MAX_SIZE:Int64 = 1024 * 1024
                storageRef.getData(maxSize: MAX_SIZE) { result, error in
                    let teamName = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.teamNames = teamName
                    
                    if team.images != nil && team.passwords != "" {
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let passwordRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("その他").child("\(arr[6])").child("passWord")
                
                passwordRef.getData(maxSize: MAX_SIZE) { result, error in
                    let password = String(data: result!, encoding: String.Encoding.utf32)!
                    
                    team.passwords = password
                    
                    if team.images != nil && team.teamNames != "" {
                        self.teamArray.append(team)
                        self.collectionView.reloadData()
                    }
                    
                }
                
                let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child("その他").child("\(arr[6])").child("image")
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    
                    if let error = error {
                        print("エラー\(error)")
                        
                        
                    } else {
                        let image = UIImage(data: data!)
                        
                        team.images = image
                        
                        if team.teamNames != "" && team.passwords != "" {
                            self.teamArray.append(team)
                            self.collectionView.reloadData()
                        }
                    }
                }
                
            }
            
            
        }
        
    }
    
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return teamArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        
        //        Tag番号でタイトルと画像をセット
        let teamNameLabel = cell.contentView.viewWithTag(2) as! UILabel
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        let editButton = cell.contentView.viewWithTag(3) as! UIButton
        editButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        let team = teamArray[indexPath.row]
        teamNameLabel.text = team.teamNames
        imageView.image = team.images
        imageView.contentMode = .scaleAspectFill
        return cell
    }
    
    //   セルのレイアウトを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.layer.bounds.width
        let height = self.collectionView.layer.bounds.height
        
        let widthcellSize : CGFloat = width / 2 - 1
        let heightcellSize : CGFloat = height / 3.5 - 1
        return CGSize(width: widthcellSize, height: heightcellSize)
    }
    
    //    セルタップ
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "toCircle", sender: nil)
        
    }
    
    //    編集ボタンタップ
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        
        var alertTextField: UITextField?
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)!
        let team = teamArray[indexPath.row]
        
        
        let alert = UIAlertController(
            title: "パスワード", message: "編集用パスワードを入力してください", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
        })
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil
            )
        )
        alert.addAction(
            UIAlertAction(
                title: "OK", style: UIAlertAction.Style.default) { _ in
                if alertTextField?.text == team.passwords {
                    self.teamName = team.teamNames
                    self.image = team.images!
                    self.uuidTime = team.uuidTimes
                    self.password = team.passwords
                    
                    self.performSegue(withIdentifier: "toMakeAd", sender: nil)
                } else {
                    let alert = UIAlertController(
                        title: "パスワードが違います", message: "入力されたパスワードに誤りがあります", preferredStyle: UIAlertController.Style.alert)
                    
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "OK", style: UIAlertAction.Style.cancel, handler: nil
                        )
                    )
                    self.present(alert, animated: true)
                }
            }
        )
        
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCircle" {
            let circleViewController:CircleViewController = segue.destination as! CircleViewController
            circleViewController.teamName = teamName
            circleViewController.image = image
            circleViewController.uuidTime = uuidTime
            circleViewController.genre = "その他"
        } else {
            let makeAdViewController:MakeAdViewController = segue.destination as! MakeAdViewController
            makeAdViewController.teamName = teamName
            makeAdViewController.image = image
            makeAdViewController.uuidTime = uuidTime
            makeAdViewController.password = password
            makeAdViewController.genre = "その他"
            makeAdViewController.checkSegue = 1
        }
    }
}

