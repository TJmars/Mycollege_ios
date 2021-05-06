//
//  ClassTopViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/09/16.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

//クラス詳細ページなど

import UIKit
import XLPagerTabStrip
import RealmSwift
import Charts
import Firebase
import FirebaseUI
import TTTAttributedLabel

class ClassTopViewController: ButtonBarPagerTabStripViewController {
    
    
    let realm = try! Realm()
    var task: Task!
    var taskArray = try! Realm().objects(Task.self)
    
    var loginApp:LoginApp!
    
    //    どこから遷移したか　　0 = Home  1 = ClassList
    var checkSegue = 0
    //    編集画面に行ったか　　0 = 行った  1 = 行ってない
    var editNum = 0
    
    //    podstData関連
    var postData: PostData!
    var documentID = ""
    var postArray:[PostData] = []
    
    //   曜日、時間の変数
    var dayNum = 0
    var periodNum = 0
    
    //    時間割で表示するコマの色
    var colorNum = 0
    var appDetail: AppDetail!
    
        
    // Firestoreのリスナー
    var listener: ListenerRegistration!
    
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var registerTitleButton: UIButton!
    @IBOutlet weak var editTitleButton: UIButton!
    
    
    override func viewDidLoad() {
        
        //        上タブの設定
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        settings.style.buttonBarBackgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarMinimumLineSpacing = 15
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 14.0)
        
        
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }

        
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        registerTitleButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        registerTitleButton.layer.cornerRadius = 10
        registerTitleButton.clipsToBounds = true
        
        if checkSegue == 0 {
            self.documentID = task.documentID
            classNameLabel.text = task.className
            registerTitleButton.setTitle("時間割から削除", for: .normal)
            
        } else {
            classNameLabel.text = "\(postData.className!)"
            registerTitleButton.setTitle("時間割に登録", for: .normal)
        }
        
        editTitleButton.layer.borderWidth = 1.0
        editTitleButton.layer.borderColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1).cgColor
        editTitleButton.layer.cornerRadius = 15
        editTitleButton.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if editNum != 0 {
            
            if checkSegue == 0 {
                print(task!)
            } else {
                print(postData.faculty!)
            }
        }
    }
    
    //    子Viewの設定
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let classTop1VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClassTop1") as! ClassTop1ViewController
        let classTop2VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClassTop2") as! ClassTop2ViewController
        let classTop3VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClassTop3") as! ClassTop3ViewController
        
        
        classTop1VC.task = self.task
        classTop1VC.postData = self.postData
        classTop1VC.documentID = self.documentID
        classTop1VC.checkSegue = self.checkSegue
        
        classTop2VC.task = self.task
        classTop2VC.postData = self.postData
        classTop2VC.checkSegue = self.checkSegue
        
        classTop3VC.task = self.task
        classTop3VC.postData = self.postData
        classTop3VC.checkSegue = self.checkSegue
        
        
        if checkSegue == 0 {
            classTop2VC.documentID = task.documentID
            classTop3VC.documentID = task.documentID
        } else {
            classTop2VC.documentID = self.documentID
            classTop3VC.documentID = self.documentID
        }
        
        
        
        let childViewControllers:[UIViewController] = [classTop1VC, classTop2VC,classTop3VC]
        
        return childViewControllers
    }
    
    //    登録ボタン
    @IBAction func registerButton(_ sender: Any) {
        
        let time = Int(Date().timeIntervalSince1970)
        
        if postData != nil {
            switch postData.day {
            case "月曜":
                dayNum = 1
            case "火曜":
                dayNum = 2
            case "水曜":
                dayNum = 3
            case "木曜":
                dayNum = 4
            case "金曜":
                dayNum = 5
            case "土曜":
                dayNum = 6
            default:
                dayNum = 1
            }
            
            switch postData.period {
            case "1限":
                periodNum = 1
            case "2限":
                periodNum = 2
            case "3限":
                periodNum = 3
            case "4限":
                periodNum = 4
            case "5限":
                periodNum = 5
            case "6限":
                periodNum = 6
            default:
                periodNum = 1
            }
            
            var taskArray2 = try! Realm().objects(Task.self)
            if postData.season! != "通年" {
                let thisSeason = "\(postData.season!)"
                print(thisSeason)
                taskArray2 = try! Realm().objects(Task.self).filter("cellPoint == \((periodNum - 1) * 6 + dayNum)").filter("season == '\(postData.season!)' || season == '通年'")
            } else {
                taskArray2 = try! Realm().objects(Task.self).filter("cellPoint == \((periodNum - 1) * 6 + dayNum)")
                if taskArray2.count > 1 {
                    let tasks = taskArray2.last
                    try! self.realm.write {
                        self.realm.delete(tasks!)
                    }
                }
            }
            
            if taskArray2.count != 0 {
                task = taskArray2[0]
                if task.registerCount == 0 || time - task.time <= 2592000 {
                    try! realm.write {
                        self.task.className = postData.className!
                        self.task.career = postData.career!
                        self.task.season = postData.season!
                        self.task.day = postData.day!
                        self.task.period = postData.period!
                        self.task.documentID = documentID
                        self.task.faculty = postData.faculty!
                        self.task.teacher = postData.teacher!
                        self.task.classRoom = postData.classRoom!
                        self.task.cellPoint = (periodNum - 1) * 6 + dayNum
                        self.task.evaRate = postData.evaRate!
                        self.task.member = postData.member!
                        self.task.gradeS = postData.gradeS!
                        self.task.gradeA = postData.gradeA!
                        self.task.gradeB = postData.gradeB!
                        self.task.gradeC = postData.gradeC!
                        self.task.gradeD = postData.gradeD!
                        self.task.level4 = postData.level4!
                        self.task.level3 = postData.level3!
                        self.task.level2 = postData.level2!
                        self.task.level1 = postData.level1!
                        self.task.evaA = postData.evaA!
                        self.task.evaB = postData.evaB!
                        self.task.evaC = postData.evaC!
                        self.task.evaD = postData.evaD!
                        self.task.registerCount = 1
                        self.task.time = time
                        self.task.colorNum = colorNum
                        
                        self.realm.add(self.task, update: .modified)
                    }
                    
                    print(documentID)
                    let memberRef = Firestore.firestore().collection(loginApp.collegeNameData).document(documentID)
                    memberRef.updateData([
                        "member": FieldValue.increment(Int64(1))
                    ]) { err in
                        if let err = err {
                            print(err)
                        } else {
                            print("ok")
                        }
                    }
                    
                    //                画面を閉じる
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let dialog = UIAlertController(title: "授業評価回答にご協力ください", message: "当アプリでは、授業データの信頼性向上のため、授業評価を実施しております。お手数ですが、「授業評価」より\(task.className)の回答をお願いいたします。", preferredStyle: .alert)
                    
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                    
                }
            } else {
                task = Task()
                if taskArray.count != 0 {
                    task.id = taskArray.max(ofProperty: "id")! + 1
                    
                }
                
                try! realm.write {
                    self.task.className = postData.className!
                    self.task.career = postData.career!
                    self.task.season = postData.season!
                    self.task.day = postData.day!
                    self.task.period = postData.period!
                    self.task.documentID = documentID
                    self.task.faculty = postData.faculty!
                    self.task.teacher = postData.teacher!
                    self.task.classRoom = postData.classRoom!
                    self.task.cellPoint = (periodNum - 1) * 6 + dayNum
                    self.task.evaRate = postData.evaRate!
                    self.task.member = postData.member!
                    self.task.gradeS = postData.gradeS!
                    self.task.gradeA = postData.gradeA!
                    self.task.gradeB = postData.gradeB!
                    self.task.gradeC = postData.gradeC!
                    self.task.gradeD = postData.gradeD!
                    self.task.level4 = postData.level4!
                    self.task.level3 = postData.level3!
                    self.task.level2 = postData.level2!
                    self.task.level1 = postData.level1!
                    self.task.evaA = postData.evaA!
                    self.task.evaB = postData.evaB!
                    self.task.evaC = postData.evaC!
                    self.task.evaD = postData.evaD!
                    self.task.registerCount = 1
                    self.task.time = time
                    
                    if let obj = realm.objects(AppDetail.self).first {
                        appDetail = obj
                        self.task.colorNum = appDetail.colorNum
                    } else {
                        appDetail = AppDetail()
                        self.task.colorNum = appDetail.colorNum
                    }
                    
                    self.realm.add(self.task, update: .modified)
                }
                print(documentID)
                let memberRef = Firestore.firestore().collection(loginApp.collegeNameData).document(documentID)
                memberRef.updateData([
                    "member": FieldValue.increment(Int64(1))
                ]) { err in
                    if let err = err {
                        print(err)
                    } else {
                        print("ok")
                    }
                }
                
                //                画面を閉じる
                self.dismiss(animated: true, completion: nil)
            }
            
            
            
            
        } else {
            
            
            let realmTime = self.task.time
            if self.task.registerCount == 0 {
                let dialog = UIAlertController(title: "教科の削除", message: "この教科を時間割から削除しますか？", preferredStyle: .alert)
                
                
                dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    let memberRef = Firestore.firestore().collection(self.loginApp.collegeNameData).document(self.task.documentID)
                    
                    memberRef.updateData([
                        "member": FieldValue.increment(Int64(-1))
                    ]) { err in
                        if let err = err {
                            print(err)
                        } else {
                            print("PK")
                        }
                    }
                    
                    try! self.realm.write {
                        self.realm.delete(self.task)
                    }
                    
                    
                    //                画面を閉じる
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(dialog, animated: true, completion: nil)
            } else {
                if time - realmTime <= 2592000 {
                    let dialog = UIAlertController(title: "教科の削除", message: "この教科を時間割から削除しますか？", preferredStyle: .alert)
                    
                    dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        let memberRef = Firestore.firestore().collection(self.loginApp.collegeNameData).document(self.task.documentID)
                        
                        memberRef.updateData([
                            "member": FieldValue.increment(Int64(-1))
                        ]) { err in
                            if let err = err {
                                print(err)
                            } else {
                                print("PK")
                            }
                        }
                        
                        
                        try! self.realm.write {
                            self.realm.delete(self.task)
                        }
                        
                        //                画面を閉じる
                        self.dismiss(animated: true, completion: nil)
                        
                    }))
                    
                    self.present(dialog, animated: true, completion: nil)
                } else {
                    let dialog = UIAlertController(title: "授業評価回答にご協力ください", message: "当アプリでは、授業データの信頼性向上のため、授業評価を実施しております。お手数ですが、「授業評価」より回答をお願いいたします。", preferredStyle: .alert)
                    
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(dialog, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    //    編集ボタン
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "toEdit", sender: nil)
    }
    
    //    戻るボタン
    @IBAction func returnButon(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editClassViewController:EditClassViewController = segue.destination as! EditClassViewController
        if checkSegue == 0 {
            editClassViewController.task = task
            editClassViewController.checkSegue = 0
        } else {
            editClassViewController.postData = postData
            editClassViewController.documentID = documentID
            editClassViewController.checkSegue = 1
        }
    }
    
    
    
}



//授業詳細ページ
class ClassTop1ViewController: UIViewController, IndicatorInfoProvider, UIScrollViewDelegate {
    
    
    let scrollView = UIScrollView()
    let chartScrollView = UIScrollView()
    private var pageControl: UIPageControl!

    
    let teacherNameTitleLabel = UILabel()
    let teacherNameLabel = UILabel()
    let seasonTitleLabel = UILabel()
    let seasonLabel = UITextField()
    let dayPeriodTitleLabel = UILabel()
    let dayperiodLabel = UILabel()
    let facultyTitleLabel = UILabel()
    let facultyLabel = UILabel()
    let classRoomTitleLabel = UILabel()
    let classRoomLabel = UILabel()
    let evaTitleLabel = UILabel()
    let evaLabel = UILabel()
    let memberTitleLabel = UILabel()
    let memberLabel = UILabel()
    let careerTitleLabel = UILabel()
    let careerLabel = UILabel()
    
    let greenButton = UIButton()
    let redButton = UIButton()
    let blueButton = UIButton()
    let purpleButton = UIButton()
    let yellowButton = UIButton()
    let orangeButton = UIButton()
    
    let updateButton = UIButton()
    
    //    円グラフ
    let gradeChartsView = PieChartView()
    let levelChartsView = PieChartView()
    let evaChartsView = PieChartView()
    
    
    var itemInfo: IndicatorInfo = "授業詳細"
    
    //    ClassTopViewControllerからの値の受け取り
    let realm = try! Realm()
    var task: Task!
    var taskArray = try! Realm().objects(Task.self)
    var appDetail: AppDetail!
    var loginApp:LoginApp!
    
    
    //    どこから遷移したか　　0 = Home  1 = ClassList
    var checkSegue = 0
    
    var postData: PostData!
    var documentID = ""
    
    var colorNum = 0
    
    var dayNum = 0
    var periodNum = 0
    
    //    更新
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        講義コマの色関連
        if let obj = realm.objects(AppDetail.self).first {
            appDetail = obj
            
        } else {
            appDetail = AppDetail()
            
        }
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }
        
        let width = self.view.frame.size.width
        
        
        //        色ボタン作成
        createColorButton()
        
        
        let pageSize = 3
        chartScrollView.delegate = self
        
        //        pageControlの生成
        pageControl = UIPageControl(frame: CGRect(x: width / 2 - 100, y: width * 3 / 7 , width: 200, height: 20))
        
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        pageControl.numberOfPages = pageSize
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
        
        view.addSubview(chartScrollView)
        view.addSubview(scrollView)
        createLabel()
        
        if checkSegue == 0 {
            teacherNameLabel.text = "\(task.teacher)"
            dayperiodLabel.text = "\(task.day)\(task.period)"
            facultyLabel.text = "\(task.faculty)"
            classRoomLabel.text = "\(task.classRoom)"
            evaLabel.text = "\(task.evaRate)"
            seasonLabel.text = "\(task.season)"
            careerLabel.text = "\(task.career)"
            memberLabel.text = "\(task.member)人"
        } else {
            teacherNameLabel.text = "\(postData.teacher!)"
            dayperiodLabel.text = "\(postData.day!)\(postData.period!)"
            facultyLabel.text = "\(postData.faculty!)"
            classRoomLabel.text = "\(postData.classRoom!)"
            evaLabel.text = "\(postData.evaRate!)"
            seasonLabel.text = "\(postData.season!)"
            careerLabel.text = "\(postData.career!)"
            memberLabel.text = "\(postData.member!)人"
        }
        
        
        scrollView.contentSize = CGSize(width: width, height: 1000 )
        
        createGrafButton()
        
        self.chartScrollView.addSubview(gradeChartsView)
        self.chartScrollView.addSubview(levelChartsView)
        self.chartScrollView.addSubview(evaChartsView)
        self.view.addSubview(chartScrollView)
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(ClassTop1ViewController.refresh(sender:)), for: .valueChanged)
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    //    ボタンタップ
    @objc func greenButtonEvent(_ sender: UIButton) {
        greenButton.setTitle("✔︎", for: .normal)
        blueButton.setTitle("", for: .normal)
        redButton.setTitle("", for: .normal)
        purpleButton.setTitle("", for: .normal)
        yellowButton.setTitle("", for: .normal)
        orangeButton.setTitle("", for: .normal)
        
        if checkSegue == 0 {
            try! realm.write {
                task.colorNum = 0
                self.realm.add(task)
            }
        } else {
            try! realm.write {
                appDetail.colorNum = 0
                self.realm.add(appDetail)
            }
        }
    }
    
    @objc func blueButtonEvent(_ sender: UIButton) {
        greenButton.setTitle("", for: .normal)
        blueButton.setTitle("✔︎", for: .normal)
        redButton.setTitle("", for: .normal)
        purpleButton.setTitle("", for: .normal)
        yellowButton.setTitle("", for: .normal)
        orangeButton.setTitle("", for: .normal)
        if checkSegue == 0 {
            try! realm.write {
                task.colorNum = 1
                self.realm.add(task)
            }
        } else {
            try! realm.write {
                appDetail.colorNum = 1
                self.realm.add(appDetail)
            }
        }
    }
    
    @objc func redButtonEvent(_ sender: UIButton) {
        greenButton.setTitle("", for: .normal)
        blueButton.setTitle("", for: .normal)
        redButton.setTitle("✔︎", for: .normal)
        purpleButton.setTitle("", for: .normal)
        yellowButton.setTitle("", for: .normal)
        orangeButton.setTitle("", for: .normal)
        if checkSegue == 0 {
            try! realm.write {
                task.colorNum = 2
                self.realm.add(task)
            }
        } else {
            try! realm.write {
                appDetail.colorNum = 2
                self.realm.add(appDetail)
            }
        }
    }
    
    @objc func purpleButtonEvent(_ sender: UIButton) {
        greenButton.setTitle("", for: .normal)
        blueButton.setTitle("", for: .normal)
        redButton.setTitle("", for: .normal)
        purpleButton.setTitle("✔︎", for: .normal)
        yellowButton.setTitle("", for: .normal)
        orangeButton.setTitle("", for: .normal)
        if checkSegue == 0 {
            try! realm.write {
                task.colorNum = 3
                self.realm.add(task)
            }
        } else {
            try! realm.write {
                appDetail.colorNum = 3
                self.realm.add(appDetail)
            }
        }
    }
    
    @objc func yellowButtonEvent(_ sender: UIButton) {
        greenButton.setTitle("", for: .normal)
        blueButton.setTitle("", for: .normal)
        redButton.setTitle("", for: .normal)
        purpleButton.setTitle("", for: .normal)
        yellowButton.setTitle("✔︎", for: .normal)
        orangeButton.setTitle("", for: .normal)
        if checkSegue == 0 {
            try! realm.write {
                task.colorNum = 4
                self.realm.add(task)
            }
        } else {
            try! realm.write {
                appDetail.colorNum = 4
                self.realm.add(appDetail)
            }
        }
    }
    
    @objc func orangeButtonEvent(_ sender: UIButton) {
        greenButton.setTitle("", for: .normal)
        blueButton.setTitle("", for: .normal)
        redButton.setTitle("", for: .normal)
        purpleButton.setTitle("", for: .normal)
        yellowButton.setTitle("", for: .normal)
        orangeButton.setTitle("✔︎", for: .normal)
        
        if checkSegue == 0 {
            try! realm.write {
                task.colorNum = 5
                self.realm.add(task)
            }
        } else {
            try! realm.write {
                appDetail.colorNum = 5
                self.realm.add(appDetail)
            }
        }
    }
    
    
    //    Labelの作成
    func createLabel() {
        let width = view.frame.size.width
        teacherNameTitleLabel.frame = CGRect(x: 10, y: 10, width: width - 20, height: 30)
        teacherNameTitleLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        teacherNameTitleLabel.layer.cornerRadius = 5
        teacherNameTitleLabel.clipsToBounds = true
        teacherNameTitleLabel.text = "　教員名"
        teacherNameTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        teacherNameLabel.frame = CGRect(x: 10, y: 40, width: width - 20, height: 50)
        teacherNameLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        teacherNameLabel.layer.cornerRadius = 5
        teacherNameLabel.clipsToBounds = true
        teacherNameLabel.font = UIFont.systemFont(ofSize: 15.0)
        teacherNameLabel.textAlignment = .center
        
        seasonTitleLabel.frame = CGRect(x: 10, y: 90, width: width - 20, height: 30)
        seasonTitleLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        seasonTitleLabel.layer.cornerRadius = 5
        seasonTitleLabel.clipsToBounds = true
        seasonTitleLabel.text = "　学期"
        seasonTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        seasonLabel.frame = CGRect(x: 10, y: 120, width: width - 20, height: 50)
        seasonLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        seasonLabel.layer.cornerRadius = 5
        seasonLabel.clipsToBounds = true
        seasonLabel.font = UIFont.systemFont(ofSize: 15.0)
        seasonLabel.textAlignment = .center
        
        dayPeriodTitleLabel.frame = CGRect(x: 10, y: 170, width: width - 20, height: 30)
        dayPeriodTitleLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        dayPeriodTitleLabel.layer.cornerRadius = 5
        dayPeriodTitleLabel.clipsToBounds = true
        dayPeriodTitleLabel.text = "　時間"
        dayPeriodTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        dayperiodLabel.frame = CGRect(x: 10, y: 200, width: width - 20, height: 50)
        dayperiodLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        dayperiodLabel.layer.cornerRadius = 5
        dayperiodLabel.clipsToBounds = true
        dayperiodLabel.font = UIFont.systemFont(ofSize: 15.0)
        dayperiodLabel.textAlignment = .center
        
        facultyTitleLabel.frame = CGRect(x: 10, y: 250, width: width - 20, height: 30)
        facultyTitleLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        facultyTitleLabel.layer.cornerRadius = 5
        facultyTitleLabel.clipsToBounds = true
        facultyTitleLabel.text = "　学部"
        facultyTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        facultyLabel.frame = CGRect(x: 10, y: 280, width: width - 20, height: 50)
        facultyLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        facultyLabel.layer.cornerRadius = 5
        facultyLabel.clipsToBounds = true
        facultyLabel.font = UIFont.systemFont(ofSize: 15.0)
        facultyLabel.textAlignment = .center
        
        classRoomTitleLabel.frame = CGRect(x: 10, y: 330, width: width - 20, height: 30)
        classRoomTitleLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        classRoomTitleLabel.layer.cornerRadius = 5
        classRoomTitleLabel.clipsToBounds = true
        classRoomTitleLabel.text = "　教室"
        classRoomTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        classRoomLabel.frame = CGRect(x: 10, y: 360, width: width - 20, height: 50)
        classRoomLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        classRoomLabel.layer.cornerRadius = 5
        classRoomLabel.clipsToBounds = true
        classRoomLabel.font = UIFont.systemFont(ofSize: 15.0)
        classRoomLabel.textAlignment = .center
        
        memberTitleLabel.frame = CGRect(x: 10, y: 410, width: width - 20, height: 30)
        memberTitleLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        memberTitleLabel.layer.cornerRadius = 5
        memberTitleLabel.clipsToBounds = true
        memberTitleLabel.text = "　履修中人数"
        memberTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        memberLabel.frame = CGRect(x: 10, y: 440, width: width - 20, height: 50)
        memberLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        memberLabel.layer.cornerRadius = 5
        memberLabel.clipsToBounds = true
        memberLabel.font = UIFont.systemFont(ofSize: 15.0)
        memberLabel.textAlignment = .center
        
        evaTitleLabel.frame = CGRect(x: 10, y: 490, width: width - 20, height: 30)
        evaTitleLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        evaTitleLabel.layer.cornerRadius = 5
        evaTitleLabel.clipsToBounds = true
        evaTitleLabel.text = "　評価基準"
        evaTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        evaLabel.frame = CGRect(x: 10, y: 520, width: width - 20, height: 100)
        evaLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        evaLabel.layer.cornerRadius = 5
        evaLabel.clipsToBounds = true
        evaLabel.font = UIFont.systemFont(ofSize: 15.0)
        evaLabel.textAlignment = .center
        evaLabel.numberOfLines = 0
        
        careerTitleLabel.frame = CGRect(x: 10, y: 620, width: width - 20, height: 30)
        careerTitleLabel.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        careerTitleLabel.layer.cornerRadius = 5
        careerTitleLabel.clipsToBounds = true
        careerTitleLabel.text = "　教員のプロフィール"
        careerTitleLabel.font = UIFont.systemFont(ofSize: 15.0)
        careerLabel.frame = CGRect(x: 10, y: 650, width: width - 20, height: 100)
        careerLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        careerLabel.layer.cornerRadius = 5
        careerLabel.clipsToBounds = true
        careerLabel.font = UIFont.systemFont(ofSize: 15.0)
        careerLabel.textAlignment = .center
        careerLabel.numberOfLines = 0
        
        
        scrollView.addSubview(teacherNameTitleLabel)
        scrollView.addSubview(teacherNameLabel)
        scrollView.addSubview(dayPeriodTitleLabel)
        scrollView.addSubview(dayperiodLabel)
        scrollView.addSubview(facultyTitleLabel)
        scrollView.addSubview(facultyLabel)
        scrollView.addSubview(classRoomTitleLabel)
        scrollView.addSubview(classRoomLabel)
        scrollView.addSubview(evaTitleLabel)
        scrollView.addSubview(evaLabel)
        scrollView.addSubview(memberTitleLabel)
        scrollView.addSubview(memberLabel)
        scrollView.addSubview(seasonTitleLabel)
        scrollView.addSubview(seasonLabel)
        scrollView.addSubview(careerTitleLabel)
        scrollView.addSubview(careerLabel)
        
    }
    
    
    func scrollViewDidEndDecelerating(_ chartScrollView: UIScrollView) {
        if chartScrollView.contentOffset.x != 0.0 {
            let nowPage = chartScrollView.contentOffset.x / chartScrollView.frame.maxX
            if nowPage < 0.5 {
                pageControl.currentPage = 0
            } else if 0.5 <= nowPage && nowPage <= 1.5 {
                pageControl.currentPage = 1
            } else {
                pageControl.currentPage = 2
            }
            
        } else {
            pageControl.currentPage = 0
        }
        
    }
    
    //    内容の更新用関数
    @objc func refresh(sender: UIRefreshControl) {
        
        // ここが引っ張られるたびに呼び出される
        if checkSegue == 0 {
            Firestore.firestore().collection(loginApp.collegeNameData).document(task.documentID).getDocument { (snap, error) in
                if let error = error {
                    fatalError("\(error)")
                }
                guard let data = snap?.data() else { return }
                
                print(data["className"]!)
                print(data["member"]!)
                if data["day"]! as! String == self.task.day && data["period"]! as! String == self.task.period && data["season"]! as! String == self.task.season {
                    
                    switch data["day"]! as! String {
                    case "月曜":
                        self.dayNum = 1
                    case "火曜":
                        self.dayNum = 2
                    case "水曜":
                        self.dayNum = 3
                    case "木曜":
                        self.dayNum = 4
                    case "金曜":
                        self.dayNum = 5
                    case "土曜":
                        self.dayNum = 6
                    default:
                        self.dayNum = 1
                    }
                    
                    switch data["period"]! as! String {
                    case "1限":
                        self.periodNum = 1
                    case "2限":
                        self.periodNum = 2
                    case "3限":
                        self.periodNum = 3
                    case "4限":
                        self.periodNum = 4
                    case "5限":
                        self.periodNum = 5
                    case "6限":
                        self.periodNum = 6
                    default:
                        self.periodNum = 1
                    }
                    
                    try! self.realm.write {
                        
                        self.task.career = data["career"]! as! String
                        self.task.season = data["season"]! as! String
                        self.task.day = data["day"]! as! String
                        self.task.period = data["period"]! as! String
                        
                        self.task.faculty = data["faculty"]! as! String
                        
                        self.task.classRoom = data["classRoom"]! as! String
                        self.task.cellPoint = (self.periodNum - 1) * 6 + self.dayNum
                        self.task.evaRate = data["evaRate"]! as! String
                        self.task.member = data["member"]! as! Int
                        self.task.gradeS = data["gradeS"]! as! Int
                        self.task.gradeA = data["gradeA"]! as! Int
                        self.task.gradeB = data["gradeB"]! as! Int
                        self.task.gradeC = data["gradeC"]! as! Int
                        self.task.gradeD = data["gradeD"]! as! Int
                        self.task.level4 = data["level4"]! as! Int
                        self.task.level3 = data["level3"]! as! Int
                        self.task.level2 = data["level2"]! as! Int
                        self.task.level1 = data["level1"]! as! Int
                        self.task.evaA = data["evaA"]! as! Int
                        self.task.evaB = data["evaB"]! as! Int
                        self.task.evaC = data["evaC"]! as! Int
                        self.task.evaD = data["evaD"]! as! Int
                        
                        self.realm.add(self.task, update: .modified)
                    }
                    self.careerLabel.text = self.task.career
                    self.seasonLabel.text = self.task.season
                    self.dayperiodLabel.text = "\(self.task.day)\(self.task.period)"
                    self.facultyLabel.text = self.task.faculty
                    self.classRoomLabel.text = self.task.classRoom
                    self.evaLabel.text = self.task.evaRate
                    self.memberLabel.text = "\(self.task.member)人"
                    self.createGrafButton()
                } else {
                    let dialog = UIAlertController(title: "時間、学期に変更があります", message: "この講義は時間、学期に変更が加えられているため、データを更新すると時間割が一部更新されます", preferredStyle: .alert)
                    
                    
                    dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    
                    dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch data["day"]! as! String {
                        case "月曜":
                            self.dayNum = 1
                        case "火曜":
                            self.dayNum = 2
                        case "水曜":
                            self.dayNum = 3
                        case "木曜":
                            self.dayNum = 4
                        case "金曜":
                            self.dayNum = 5
                        case "土曜":
                            self.dayNum = 6
                        default:
                            self.dayNum = 1
                        }
                        
                        switch data["period"]! as! String {
                        case "1限":
                            self.periodNum = 1
                        case "2限":
                            self.periodNum = 2
                        case "3限":
                            self.periodNum = 3
                        case "4限":
                            self.periodNum = 4
                        case "5限":
                            self.periodNum = 5
                        case "6限":
                            self.periodNum = 6
                        default:
                            self.periodNum = 1
                        }
                        
                        try! self.realm.write {
                            
                            self.task.career = data["career"]! as! String
                            self.task.season = data["season"]! as! String
                            self.task.day = data["day"]! as! String
                            self.task.period = data["period"]! as! String
                            
                            self.task.faculty = data["faculty"]! as! String
                            
                            self.task.classRoom = data["classRoom"]! as! String
                            self.task.cellPoint = (self.periodNum - 1) * 6 + self.dayNum
                            self.task.evaRate = data["evaRate"]! as! String
                            self.task.member = data["member"]! as! Int
                            self.task.gradeS = data["gradeS"]! as! Int
                            self.task.gradeA = data["gradeA"]! as! Int
                            self.task.gradeB = data["gradeB"]! as! Int
                            self.task.gradeC = data["gradeC"]! as! Int
                            self.task.gradeD = data["gradeD"]! as! Int
                            self.task.level4 = data["level4"]! as! Int
                            self.task.level3 = data["level3"]! as! Int
                            self.task.level2 = data["level2"]! as! Int
                            self.task.level1 = data["level1"]! as! Int
                            self.task.evaA = data["evaA"]! as! Int
                            self.task.evaB = data["evaB"]! as! Int
                            self.task.evaC = data["evaC"]! as! Int
                            self.task.evaD = data["evaD"]! as! Int
                            
                            self.realm.add(self.task, update: .modified)
                        }
                        self.careerLabel.text = self.task.career
                        self.seasonLabel.text = self.task.season
                        self.dayperiodLabel.text = "\(self.task.day)\(self.task.period)"
                        self.facultyLabel.text = self.task.faculty
                        self.classRoomLabel.text = self.task.classRoom
                        self.evaLabel.text = self.task.evaRate
                        self.memberLabel.text = "\(self.task.member)人"
                        
                        let taskArrays = try! Realm().objects(Task.self).filter("cellPoint == \((self.periodNum - 1) * 6 + self.dayNum)").filter("season == '\(data["season"]! as! String)' || season == '通年'").filter("documentID != '\(self.task.documentID)'")
                        
                        if taskArrays.count != 0 {
                            let tasks = taskArrays[0]
                            try! self.realm.write {
                                self.realm.delete(tasks)
                            }
                        }
                    }))
                    
                    self.present(dialog, animated: true, completion: nil)
                    
                }
            }
            
        } else {
            self.careerLabel.text = postData.career!
            self.seasonLabel.text = postData.season!
            self.dayperiodLabel.text = "\(postData.day!)\(postData.period!)"
            self.facultyLabel.text = postData.faculty!
            self.classRoomLabel.text = postData.classRoom!
            self.evaLabel.text = postData.evaRate!
            self.memberLabel.text = "\(postData.member!)人"
        }
        // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        refreshControl.endRefreshing()
    }
    
    //    色指定ボタンの作成
    func createColorButton() {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        //        スクロールビューを作る
        chartScrollView.frame = CGRect(x:0, y: 0, width: width * 5 / 7, height: width * 3 / 7)
        scrollView.frame = CGRect(x: 0, y: width * 3 / 7 + 20, width: width, height: height - (width * 3 / 7 + 20))
        chartScrollView.isPagingEnabled = true
        chartScrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        //        色ボタン
        greenButton.frame = CGRect(x: width * 5 / 7 + width / 35, y: width * 1 / 16, width: width * 3 / 35, height: width * 3 / 35)
        greenButton.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        greenButton.layer.cornerRadius = 10
        greenButton.clipsToBounds = true
        greenButton.layer.borderWidth = 1
        greenButton.layer.borderColor = UIColor.lightGray.cgColor
        greenButton.addTarget(self, action: #selector(greenButtonEvent(_:)), for: .touchUpInside)
        view.addSubview(greenButton)
        
        
        blueButton.frame = CGRect(x: width * 5 / 7 + width * 6 / 35, y: width * 1 / 16, width: width * 3 / 35, height: width * 3 / 35)
        blueButton.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1)
        blueButton.layer.cornerRadius = 10
        blueButton.clipsToBounds = true
        blueButton.layer.borderWidth = 1
        blueButton.layer.borderColor = UIColor.lightGray.cgColor
        blueButton.addTarget(self, action: #selector(blueButtonEvent(_:)), for: .touchUpInside)
        
        view.addSubview(blueButton)
        
        redButton.frame = CGRect(x: width * 5 / 7 + width / 35, y: width * 3 / 16, width: width * 3 / 35, height: width * 3 / 35)
        redButton.backgroundColor = UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 1)
        redButton.layer.cornerRadius = 10
        redButton.clipsToBounds = true
        redButton.layer.borderWidth = 1
        redButton.layer.borderColor = UIColor.lightGray.cgColor
        redButton.addTarget(self, action: #selector(redButtonEvent(_:)), for: .touchUpInside)
        
        view.addSubview(redButton)
        
        purpleButton.frame = CGRect(x: width * 5 / 7 + width * 6 / 35, y: width * 3 / 16, width: width * 3 / 35, height: width * 3 / 35)
        purpleButton.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 1.0, alpha: 1)
        purpleButton.layer.cornerRadius = 10
        purpleButton.clipsToBounds = true
        purpleButton.layer.borderWidth = 1
        purpleButton.layer.borderColor = UIColor.lightGray.cgColor
        purpleButton.addTarget(self, action: #selector(purpleButtonEvent(_:)), for: .touchUpInside)
        
        view.addSubview(purpleButton)
        
        yellowButton.frame = CGRect(x: width * 5 / 7 + width / 35, y: width * 5 / 16, width: width * 3 / 35, height: width * 3 / 35)
        yellowButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1)
        yellowButton.layer.cornerRadius = 10
        yellowButton.clipsToBounds = true
        yellowButton.layer.borderWidth = 1
        yellowButton.layer.borderColor = UIColor.lightGray.cgColor
        yellowButton.addTarget(self, action: #selector(yellowButtonEvent(_:)), for: .touchUpInside)
        
        view.addSubview(yellowButton)
        
        orangeButton.frame = CGRect(x: width * 5 / 7 + width * 6 / 35, y: width * 5 / 16, width: width * 3 / 35, height: width * 3 / 35)
        orangeButton.backgroundColor = UIColor(red: 1.0, green: 0.7, blue: 0.6, alpha: 1)
        orangeButton.layer.cornerRadius = 10
        orangeButton.clipsToBounds = true
        orangeButton.layer.borderWidth = 1
        orangeButton.layer.borderColor = UIColor.lightGray.cgColor
        orangeButton.addTarget(self, action: #selector(orangeButtonEvent(_:)), for: .touchUpInside)
        
        view.addSubview(orangeButton)
        
        if checkSegue == 0 {
            switch task.colorNum {
            case 0:
                greenButton.setTitle("✔︎", for: .normal)
            case 1:
                blueButton.setTitle("✔︎", for: .normal)
            case 2:
                redButton.setTitle("✔︎", for: .normal)
            case 3:
                purpleButton.setTitle("✔︎", for: .normal)
            case 4:
                yellowButton.setTitle("✔︎", for: .normal)
            case 5:
                orangeButton.setTitle("✔︎", for: .normal)
            default:
                greenButton.setTitle("✔︎", for: .normal)
            }
        } else {
            greenButton.setTitle("✔︎", for: .normal)
        }
        
        
    }
    
    //    円グラフの作成
    func createGrafButton() {
        
        
        var gradeS = 0
        var gradeA = 0
        var gradeB = 0
        var gradeC = 0
        var gradeD = 0
        var level4 = 0
        var level3 = 0
        var level2 = 0
        var level1 = 0
        var evaA = 0
        var evaB = 0
        var evaC = 0
        var evaD = 0
        if checkSegue == 0 {
            gradeS = task.gradeS
            gradeA = task.gradeA
            gradeB = task.gradeB
            gradeC = task.gradeC
            gradeD = task.gradeD
            level4 = task.level4
            level3 = task.level3
            level2 = task.level2
            level1 = task.level1
            evaA = task.evaA
            evaB = task.evaB
            evaC = task.evaC
            evaD = task.evaD
        } else {
            gradeS = postData.gradeS!
            gradeA = postData.gradeA!
            gradeB = postData.gradeB!
            gradeC = postData.gradeC!
            gradeD = postData.gradeD!
            level4 = postData.level4!
            level3 = postData.level3!
            level2 = postData.level2!
            level1 = postData.level1!
            evaA = postData.evaA!
            evaB = postData.evaB!
            evaC = postData.evaC!
            evaD = postData.evaD!
        }
        //        円グラフ
        chartScrollView.delegate = self
        
        chartScrollView.contentSize = CGSize(width: chartScrollView.frame.size.width * 3, height: chartScrollView.frame.size.height)
        
        let contentSize = self.chartScrollView.frame.size.height
        let contentWidth = self.chartScrollView.frame.size.width
        
        self.gradeChartsView.centerText = "評定"
        self.levelChartsView.centerText = "難易度"
        self.evaChartsView.centerText = "満足度"
        
        createLegand()
        
        //        グラフに表示するデータのタイトルと値
        let gradeDataEntries = [
            PieChartDataEntry(value: Double(gradeS), label: "S"),
            PieChartDataEntry(value: Double(gradeA), label: "A"),
            PieChartDataEntry(value: Double(gradeB), label: "B"),
            PieChartDataEntry(value: Double(gradeC), label: "C"),
            PieChartDataEntry(value: Double(gradeD), label: "D")
        ]
        let levelDataEntries = [
            PieChartDataEntry(value: Double(level4), label: "高い"),
            PieChartDataEntry(value: Double(level3), label: "やや高い"),
            PieChartDataEntry(value: Double(level2), label: "やや低い"),
            PieChartDataEntry(value: Double(level1), label: "低い"),
        ]
        let evaDataEntries = [
            PieChartDataEntry(value: Double(evaA), label: "A"),
            PieChartDataEntry(value: Double(evaB), label: "B"),
            PieChartDataEntry(value: Double(evaC), label: "C"),
            PieChartDataEntry(value: Double(evaD), label: "D")
        ]
        
        let gradeDataSet = PieChartDataSet(entries: gradeDataEntries, label: "")
        let levelDataSet = PieChartDataSet(entries: levelDataEntries, label: "")
        let evaDataSet = PieChartDataSet(entries: evaDataEntries, label: "")
        
        gradeDataSet.colors = ChartColorTemplates.joyful()
        gradeDataSet.valueTextColor = UIColor.black
        gradeDataSet.entryLabelColor = UIColor.black
        gradeDataSet.drawValuesEnabled = false
        levelDataSet.colors = ChartColorTemplates.joyful()
        levelDataSet.valueTextColor = UIColor.black
        levelDataSet.entryLabelColor = UIColor.black
        levelDataSet.drawValuesEnabled = false
        evaDataSet.colors = ChartColorTemplates.joyful()
        evaDataSet.valueTextColor = UIColor.black
        evaDataSet.entryLabelColor = UIColor.black
        evaDataSet.drawValuesEnabled = false
        
        self.gradeChartsView.data = PieChartData(dataSet: gradeDataSet)
        self.levelChartsView.data = PieChartData(dataSet: levelDataSet)
        self.evaChartsView.data = PieChartData(dataSet: evaDataSet)
        
        // データを％表示にする
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        
        self.gradeChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        self.gradeChartsView.usePercentValuesEnabled = false
        self.gradeChartsView.legend.enabled = false
        self.gradeChartsView.rotationEnabled = false
        self.gradeChartsView.drawEntryLabelsEnabled = false
        
        
        gradeChartsView.frame = CGRect(x:contentWidth * 2 / 5, y:0, width: contentWidth * 3 / 5, height: contentSize)
        
        levelChartsView.frame = CGRect(x:contentWidth * 7 / 5, y:0, width: contentWidth * 3 / 5, height: contentSize)
        self.levelChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        self.levelChartsView.usePercentValuesEnabled = false
        self.levelChartsView.legend.enabled = false
        self.levelChartsView.rotationEnabled = false
        self.levelChartsView.drawEntryLabelsEnabled = false
        
        
        self.evaChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        self.evaChartsView.usePercentValuesEnabled = false
        self.evaChartsView.legend.enabled = false
        self.evaChartsView.rotationEnabled = false
        self.evaChartsView.drawEntryLabelsEnabled = false
        
        evaChartsView.frame = CGRect(x:contentWidth * 12 / 5, y:0, width: contentWidth * 3 / 5, height: contentSize)
        
    }
    
    func createLegand() {
        let gradeST = UILabel()
        let gradeAT = UILabel()
        let gradeBT = UILabel()
        let gradeCT = UILabel()
        let gradeDT = UILabel()
        let level4T = UILabel()
        let level3T = UILabel()
        let level2T = UILabel()
        let level1T = UILabel()
        let evaAT = UILabel()
        let evaBT = UILabel()
        let evaCT = UILabel()
        let evaDT = UILabel()
        
        let gradeSL = UILabel()
        let gradeAL = UILabel()
        let gradeBL = UILabel()
        let gradeCL = UILabel()
        let gradeDL = UILabel()
        let level4L = UILabel()
        let level3L = UILabel()
        let level2L = UILabel()
        let level1L = UILabel()
        let evaAL = UILabel()
        let evaBL = UILabel()
        let evaCL = UILabel()
        let evaDL = UILabel()
        
//        評定
        gradeST.frame = CGRect(x: self.chartScrollView.frame.size.width / 10, y: self.chartScrollView.frame.size.height / 2 - 50, width: 15, height: 15)
        gradeST.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.6, alpha: 1)
        chartScrollView.addSubview(gradeST)
        gradeSL.frame = CGRect(x: self.chartScrollView.frame.size.width / 10 + 20, y: self.chartScrollView.frame.size.height / 2 - 50, width: 40, height: 15)
        gradeSL.text = "S"
        chartScrollView.addSubview(gradeSL)
        
        gradeAT.frame = CGRect(x: self.chartScrollView.frame.size.width / 10, y: self.chartScrollView.frame.size.height / 2 - 25, width: 15, height: 15)
        gradeAT.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.4, alpha: 1)
        chartScrollView.addSubview(gradeAT)
        gradeAL.frame = CGRect(x: self.chartScrollView.frame.size.width / 10 + 20, y: self.chartScrollView.frame.size.height / 2 - 25, width: 40, height: 15)
        gradeAL.text = "A"
        chartScrollView.addSubview(gradeAL)
        
        gradeBT.frame = CGRect(x: self.chartScrollView.frame.size.width / 10, y: self.chartScrollView.frame.size.height / 2, width: 15, height: 15)
        gradeBT.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1)
        chartScrollView.addSubview(gradeBT)
        gradeBL.frame = CGRect(x: self.chartScrollView.frame.size.width / 10 + 20, y: self.chartScrollView.frame.size.height / 2, width: 40, height: 15)
        gradeBL.text = "B"
        chartScrollView.addSubview(gradeBL)
        
        gradeCT.frame = CGRect(x: self.chartScrollView.frame.size.width / 10, y: self.chartScrollView.frame.size.height / 2 + 25, width: 15, height: 15)
        gradeCT.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.4, alpha: 1)
        chartScrollView.addSubview(gradeCT)
        gradeCL.frame = CGRect(x: self.chartScrollView.frame.size.width / 10 + 20, y: self.chartScrollView.frame.size.height / 2 + 25, width: 40, height: 15)
        gradeCL.text = "C"
        chartScrollView.addSubview(gradeCL)
        
        gradeDT.frame = CGRect(x: self.chartScrollView.frame.size.width / 10, y: self.chartScrollView.frame.size.height / 2 + 50, width: 15, height: 15)
        gradeDT.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.8, alpha: 1)
        chartScrollView.addSubview(gradeDT)
        gradeDL.frame = CGRect(x: self.chartScrollView.frame.size.width / 10 + 20, y: self.chartScrollView.frame.size.height / 2 + 50, width: 40, height: 15)
        gradeDL.text = "D"
        chartScrollView.addSubview(gradeDL)
        
        //        難易度
        level4T.frame = CGRect(x: self.chartScrollView.frame.size.width * 11 / 10, y: self.chartScrollView.frame.size.height / 2 - 50, width: 15, height: 15)
        level4T.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.6, alpha: 1)
        chartScrollView.addSubview(level4T)
        level4L.frame = CGRect(x: self.chartScrollView.frame.size.width * 11 / 10 + 20, y: self.chartScrollView.frame.size.height / 2 - 50, width: 60, height: 15)
        level4L.text = "高い"
        level4L.font = UIFont.systemFont(ofSize: 15.0)
        chartScrollView.addSubview(level4L)
        
        level3T.frame = CGRect(x: self.chartScrollView.frame.size.width * 11 / 10, y: self.chartScrollView.frame.size.height / 2 - 25, width: 15, height: 15)
        level3T.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.4, alpha: 1)
        chartScrollView.addSubview(level3T)
        level3L.frame = CGRect(x: self.chartScrollView.frame.size.width * 11 / 10 + 20, y: self.chartScrollView.frame.size.height / 2 - 25, width: 60, height: 15)
        level3L.text = "やや高い"
        level3L.font = UIFont.systemFont(ofSize: 15.0)
        chartScrollView.addSubview(level3L)
        
        level2T.frame = CGRect(x: self.chartScrollView.frame.size.width * 11 / 10, y: self.chartScrollView.frame.size.height / 2, width: 15, height: 15)
        level2T.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1)
        chartScrollView.addSubview(level2T)
        level2L.frame = CGRect(x: self.chartScrollView.frame.size.width * 11 / 10 + 20, y: self.chartScrollView.frame.size.height / 2, width: 60, height: 15)
        level2L.text = "やや低い"
        level2L.font = UIFont.systemFont(ofSize: 15.0)
        chartScrollView.addSubview(level2L)
        
        level1T.frame = CGRect(x: self.chartScrollView.frame.size.width * 11 / 10, y: self.chartScrollView.frame.size.height / 2 + 25, width: 15, height: 15)
        level1T.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.4, alpha: 1)
        chartScrollView.addSubview(level1T)
        level1L.frame = CGRect(x: self.chartScrollView.frame.size.width * 11 / 10 + 20, y: self.chartScrollView.frame.size.height / 2 + 25, width: 60, height: 15)
        level1L.text = "低い"
        level1L.font = UIFont.systemFont(ofSize: 15.0)
        chartScrollView.addSubview(level1L)
        
        evaAT.frame = CGRect(x: self.chartScrollView.frame.size.width * 21 / 10, y: self.chartScrollView.frame.size.height / 2 - 50, width: 15, height: 15)
        evaAT.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.6, alpha: 1)
        chartScrollView.addSubview(evaAT)
        evaAL.frame = CGRect(x: self.chartScrollView.frame.size.width * 21 / 10 + 20, y: self.chartScrollView.frame.size.height / 2 - 50, width: 40, height: 15)
        evaAL.text = "S"
        chartScrollView.addSubview(evaAL)
        
        evaBT.frame = CGRect(x: self.chartScrollView.frame.size.width * 21 / 10, y: self.chartScrollView.frame.size.height / 2 - 25, width: 15, height: 15)
        evaBT.backgroundColor = UIColor(red: 1.0, green: 0.6, blue: 0.4, alpha: 1)
        chartScrollView.addSubview(evaBT)
        evaBL.frame = CGRect(x: self.chartScrollView.frame.size.width * 21 / 10 + 20, y: self.chartScrollView.frame.size.height / 2 - 25, width: 40, height: 15)
        evaBL.text = "A"
        chartScrollView.addSubview(evaBL)
        
        evaCT.frame = CGRect(x: self.chartScrollView.frame.size.width * 21 / 10, y: self.chartScrollView.frame.size.height / 2, width: 15, height: 15)
        evaCT.backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.3, alpha: 1)
        chartScrollView.addSubview(evaCT)
        evaCL.frame = CGRect(x: self.chartScrollView.frame.size.width * 21 / 10 + 20, y: self.chartScrollView.frame.size.height / 2, width: 40, height: 15)
        evaCL.text = "B"
        chartScrollView.addSubview(evaCL)
        
        evaDT.frame = CGRect(x: self.chartScrollView.frame.size.width * 21 / 10, y: self.chartScrollView.frame.size.height / 2 + 25, width: 15, height: 15)
        evaDT.backgroundColor = UIColor(red: 0.2, green: 0.5, blue: 0.4, alpha: 1)
        chartScrollView.addSubview(evaDT)
        evaDL.frame = CGRect(x: self.chartScrollView.frame.size.width * 21 / 10 + 20, y: self.chartScrollView.frame.size.height / 2 + 25, width: 40, height: 15)
        evaDL.text = "C"
        chartScrollView.addSubview(evaDL)
    }
    
}


//質問一覧ページ
class ClassTop2ViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //    ClassTopViewControllerからの値の受け取り
    let realm = try! Realm()
    var task: Task!
    var taskArray = try! Realm().objects(Task.self)
    var loginApp:LoginApp!
    var appDetail:AppDetail!
    
    //    どこから遷移したか　　0 = Home  1 = ClassList
    var checkSegue = 0
    
    var postData: PostData!
    var documentID = ""
    
    var questionCount = 0
    
    
    //        画像用
    var image:UIImage!
    var imageNumData = 1
    
    var indexNum = 0
    var questiionCount = 0
    
    //    質問用
    var uuidTimeArray:[String] = []
    var uuidTime = ""
    
    var itemInfo: IndicatorInfo = "質問"
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        if appDetail.apperQCount == 0 {
            getdata()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if appDetail.apperQCount != 0 {
            getdata()
            
            try! realm.write {
                appDetail.apperQCount = 0
                realm.add(appDetail)
            }
        }
        
    }
    
    func getdata() {
        
        //    質問用
         uuidTimeArray = []
         
        if Auth.auth().currentUser != nil {
            print("ドキュメント\(documentID)")
            //        質問数のカウント
            
            let storage = Storage.storage()
            let storageReference = storage.reference().child(loginApp.collegeNameData).child(Const.QuestionPath).child(documentID + "QE")
            storageReference.listAll { (result, error) in
                if let error = error {
                    // ...
                    print(error)
                    print("B")
                }
                for prefix in result.prefixes {
                    self.questiionCount += 1
                    
                    let prefixStr = "\(prefix)"
                    let arr:[String] = prefixStr.components(separatedBy: "/")
                    print("ここ\(arr[6])")
                    
                    
                    self.uuidTimeArray.append(arr[6])
                    print("配列\(self.uuidTimeArray)")
                    
                    self.tableView.reloadData()
                    
                }
                
                
            }
            
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uuidTimeArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row != 0 {
            let storage = Storage.storage()
            let textRef = storage.reference().child(loginApp.collegeNameData).child(Const.QuestionPath).child(documentID + "QE").child("\(uuidTimeArray[indexPath.row - 1])").child("title")
            
            let MAX_SIZE:Int64 = 1024 * 1024
            textRef.getData(maxSize: MAX_SIZE) { result, error in
                cell.textLabel?.text = String(data: result!, encoding: String.Encoding.utf32)
                
            }
        } else {
            cell.textLabel?.text = "＋  新しく質問をする"
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            cell.textLabel?.textColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toQuestion", sender: nil)
        } else {
            self.indexNum = indexPath.row
            self.uuidTime = uuidTimeArray[indexPath.row - 1]
            performSegue(withIdentifier: "toList", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestion" {
            let questionViewController:QuestionViewController = segue.destination as! QuestionViewController
            questionViewController.documentID = documentID
        } else {
            let questionListViewController:QuestionListViewController = segue.destination as! QuestionListViewController
            questionListViewController.documentID = documentID
            questionListViewController.childNum = indexNum
            questionListViewController.uuidTime = uuidTime
        }
    }
    
}


//クラス詳細データの編集ページ
class EditClassViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    //    ClassTopViewControllerからの値の受け取り
    let realm = try! Realm()
    var task: Task!
    var taskArray = try! Realm().objects(Task.self)
    var loginApp:LoginApp!
    
    let backButton = UIButton()
    let classNameTextLabel = UILabel()
    let facultyTextField = UITextField()
    let seasonTextField = UITextField()
    let dayTextField = UITextField()
    let teacherTextLabel = UILabel()
    let classTextField = UITextField()
    let evaRateTextView = UITextView()
    let careerTextView = UITextView()
    let postButton = UIButton()
    
    let classNameLabel = UILabel()
    let facultyLabel = UILabel()
    let seasonLabel = UILabel()
    let dayLabel = UILabel()
    let teacherLabel = UILabel()
    let classLabel = UILabel()
    let evaRateLabel = UILabel()
    let careerLabel = UILabel()
    
    
    //    どこから遷移したか　　0 = Home  1 = ClassList
    var checkSegue = 0
    
    var postData: PostData!
    var documentID = ""
    var day = ""
    var period = ""
    
    var dayPickerView = UIPickerView()
    var facultyPickerView = UIPickerView()
    var seasonPickerView = UIPickerView()
    
    let dataList = [["月曜","火曜","水曜","木曜","金曜", "土曜"],["1限","2限","3限","4限","5限","6限"]]
    let dataList2 = ["すべての学部","経済","社会","人文"]
    let dataList4 = ["春学期","秋学期","通年"]
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }
        
        let width = view.frame.size.width
        scrollView.contentSize = CGSize(width: width, height: 800 + view.frame.size.height / 2)
        
        //        戻るボタン
        backButton.frame = CGRect(x: 0, y: 0, width: 115, height: 40)
        backButton.setTitle("《 Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        backButton.addTarget(self, action: #selector(tapBackButton(_:)), for: .touchUpInside)
        backButton.setTitleColor(UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1), for: .normal)
        
        //        クラス名
        classNameLabel.frame = CGRect(x: 10, y: 60, width: width - 20, height: 20)
        classNameLabel.textAlignment = .center
        classNameLabel.text = "教科名"
        classNameTextLabel.frame = CGRect(x: 10, y: 90, width: width - 20, height: 30)
        classNameTextLabel.textAlignment = .center
        classNameTextLabel.font = UIFont.systemFont(ofSize: 16.0)
        classNameTextLabel.layer.borderColor = UIColor.lightGray.cgColor
        classNameTextLabel.layer.borderWidth = 1.0
        classNameTextLabel.layer.cornerRadius = 5
        classNameTextLabel.clipsToBounds = true
        
        
        
        
        //        教員名
        teacherLabel.frame = CGRect(x: 10, y: 140, width: width - 20, height: 20)
        teacherLabel.textAlignment = .center
        teacherLabel.text = "教員名"
        teacherTextLabel.frame = CGRect(x: 10, y: 170, width: width - 20, height: 30)
        teacherTextLabel.textAlignment = .center
        teacherTextLabel.font = UIFont.systemFont(ofSize: 16.0)
        teacherTextLabel.layer.borderColor = UIColor.lightGray.cgColor
        teacherTextLabel.layer.borderWidth = 1.0
        teacherTextLabel.layer.cornerRadius = 5
        teacherTextLabel.clipsToBounds = true
        
        //        学部
        facultyLabel.frame = CGRect(x: 10, y: 220, width: width - 20, height: 20)
        facultyLabel.textAlignment = .center
        facultyLabel.text = "学部名"
        facultyTextField.frame = CGRect(x: 10, y: 250, width: width - 20, height: 30)
        facultyTextField.textAlignment = .center
        facultyTextField.placeholder = "学部を入力してください"
        facultyTextField.font = UIFont.systemFont(ofSize: 16.0)
        facultyTextField.layer.borderColor = UIColor.lightGray.cgColor
        facultyTextField.layer.borderWidth = 1.0
        facultyTextField.layer.cornerRadius = 5
        facultyTextField.clipsToBounds = true
        
        //        学期
        seasonLabel.frame = CGRect(x: 10, y: 300, width: width - 20, height: 20)
        seasonLabel.textAlignment = .center
        seasonLabel.text = "学期"
        seasonTextField.frame = CGRect(x: 10, y: 330, width: width - 20, height: 30)
        seasonTextField.textAlignment = .center
        seasonTextField.placeholder = "学期を入力してください"
        seasonTextField.font = UIFont.systemFont(ofSize: 16.0)
        seasonTextField.layer.borderColor = UIColor.lightGray.cgColor
        seasonTextField.layer.borderWidth = 1.0
        seasonTextField.layer.cornerRadius = 5
        seasonTextField.clipsToBounds = true
        
        //        日時
        dayLabel.frame = CGRect(x: 10, y: 380, width: width - 20, height: 20)
        dayLabel.textAlignment = .center
        dayLabel.text = "曜日、日時"
        dayTextField.frame = CGRect(x: 10, y: 410, width: width - 20, height: 30)
        dayTextField.textAlignment = .center
        dayTextField.placeholder = "曜日、時間を入力してください"
        dayTextField.font = UIFont.systemFont(ofSize: 16.0)
        dayTextField.layer.borderColor = UIColor.lightGray.cgColor
        dayTextField.layer.borderWidth = 1.0
        dayTextField.layer.cornerRadius = 5
        dayTextField.clipsToBounds = true
        
        //        教室
        classLabel.frame = CGRect(x: 10, y: 460, width: width - 20, height: 20)
        classLabel.textAlignment = .center
        classLabel.text = "教室"
        classTextField.frame = CGRect(x: 10, y: 490, width: width - 20, height: 30)
        classTextField.textAlignment = .center
        classTextField.placeholder = "教室を入力してください"
        classTextField.font = UIFont.systemFont(ofSize: 16.0)
        classTextField.layer.borderColor = UIColor.lightGray.cgColor
        classTextField.layer.borderWidth = 1.0
        classTextField.layer.cornerRadius = 5
        classTextField.clipsToBounds = true
        
        //        評価基準
        evaRateLabel.frame = CGRect(x: 10, y: 540, width: width - 20, height: 20)
        evaRateLabel.textAlignment = .center
        evaRateLabel.text = "評価基準"
        evaRateTextView.frame = CGRect(x: 10, y: 570, width: width - 20, height: 90)
        
        evaRateTextView.font = UIFont.systemFont(ofSize: 16.0)
        evaRateTextView.layer.borderColor = UIColor.lightGray.cgColor
        evaRateTextView.layer.borderWidth = 1.0
        evaRateTextView.layer.cornerRadius = 5
        evaRateTextView.clipsToBounds = true
        
        //        経歴
        careerLabel.frame = CGRect(x: 10, y: 680, width: width - 20, height: 20)
        careerLabel.textAlignment = .center
        careerLabel.text = "教員の経歴"
        careerTextView.frame = CGRect(x: 10, y: 710, width: width - 20, height: 90)
        
        careerTextView.font = UIFont.systemFont(ofSize: 16.0)
        careerTextView.layer.borderColor = UIColor.lightGray.cgColor
        careerTextView.layer.borderWidth = 1.0
        careerTextView.layer.cornerRadius = 5
        careerTextView.clipsToBounds = true
        
        //        投稿
        postButton.frame = CGRect(x: 30, y: 860, width: width - 60, height: 40)
        postButton.setTitle("この内容で投稿", for: .normal)
        postButton.addTarget(self, action: #selector(tapPostButton(_:)), for: .touchUpInside)
        postButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        postButton.layer.cornerRadius = 10
        postButton.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
        createPickerView()
        
        view.addSubview(scrollView)
        scrollView.addSubview(backButton)
        scrollView.addSubview(classNameTextLabel)
        scrollView.addSubview(teacherTextLabel)
        scrollView.addSubview(facultyTextField)
        scrollView.addSubview(seasonTextField)
        scrollView.addSubview(dayTextField)
        scrollView.addSubview(classTextField)
        scrollView.addSubview(evaRateTextView)
        scrollView.addSubview(careerTextView)
        scrollView.addSubview(classNameLabel)
        scrollView.addSubview(teacherLabel)
        scrollView.addSubview(facultyLabel)
        scrollView.addSubview(seasonLabel)
        scrollView.addSubview(dayLabel)
        scrollView.addSubview(classLabel)
        scrollView.addSubview(evaRateLabel)
        scrollView.addSubview(careerLabel)
        scrollView.addSubview(postButton)
        
        if checkSegue == 0 {
            classNameTextLabel.text = "\(task.className) (編集不可)"
            facultyTextField.text = "\(task.faculty)"
            dayTextField.text = "\(task.day)\(task.period)"
            teacherTextLabel.text = "\(task.teacher) (編集不可)"
            classTextField.text = task.classRoom
            evaRateTextView.text = task.evaRate
            careerTextView.text = task.career
            seasonTextField.text = task.season
            day = task.day
            period = task.period
            
        } else {
            classNameTextLabel.text = "\(postData.className!) (編集不可)"
            facultyTextField.text = postData.faculty
            dayTextField.text = "\(postData.day!)\(postData.period!)"
            teacherTextLabel.text = "\(postData.teacher!) (編集不可)"
            classTextField.text = postData.classRoom
            evaRateTextView.text = postData.evaRate
            careerTextView.text = postData.career
            seasonTextField.text = postData.season
            day = postData.day!
            period = postData.period!
        }
        
        createPickerView()
        
    }
    
    
    
    @objc func tapPostButton(_ sender:UIButton) {
        if dayTextField.text != "" && classTextField.text != "" && seasonTextField.text != "" {
            
            let dialog = UIAlertController(title: "授業詳細の変更", message: "この内容で授業詳細を変更しますか？(この内容はユーザー全員に公開されます。必ず正確な情報を記載してください)", preferredStyle: .alert)
            
            dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                var nowDocumentID = ""
                if self.checkSegue == 0 {
                    nowDocumentID = self.task.documentID
                } else {
                    nowDocumentID = self.documentID
                }
                
                let postRef = Firestore.firestore().collection(self.loginApp.collegeNameData).document(nowDocumentID)
                postRef.updateData([
                    "faculty": self.facultyTextField.text!,
                    "day": self.day,
                    "period": self.period,
                    "classRoom": self.classTextField.text!,
                    "evaRate": self.evaRateTextView.text!,
                    "season": self.seasonTextField.text!,
                    "career": self.careerTextView.text!
                ]) { err in
                    if let err = err {
                        print(err)
                    } else {
                        print("OK")
                    }
                }
                
                var dayNum = 0
                var periodNum = 0
                
                if self.checkSegue == 0 {
                    
                    switch self.day {
                    case "月曜":
                        dayNum = 1
                    case "火曜":
                        dayNum = 2
                    case "水曜":
                        dayNum = 3
                    case "木曜":
                        dayNum = 4
                    case "金曜":
                        dayNum = 5
                    case "土曜":
                        dayNum = 6
                    default:
                        dayNum = 1
                    }
                    
                    switch self.period {
                    case "1限":
                        periodNum = 1
                    case "2限":
                        periodNum = 2
                    case "3限":
                        periodNum = 3
                    case "4限":
                        periodNum = 4
                    case "5限":
                        periodNum = 5
                    case "6限":
                        periodNum = 6
                    default:
                        periodNum = 1
                    }
                    //                Realmに書き込み
                    try! self.realm.write {
                        
                        self.task.career = self.careerTextView.text!
                        self.task.season = self.seasonTextField.text!
                        self.task.day = self.day
                        self.task.period = self.period
                        self.task.faculty = self.facultyTextField.text!
                        self.task.classRoom = self.classTextField.text!
                        self.task.cellPoint = (periodNum - 1) * 6 + dayNum
                        self.task.evaRate = self.evaRateTextView.text!
                        self.task.registerCount = 1
                        self.realm.add(self.task, update: .modified)
                    }
                    let preVC = self.presentingViewController as! ClassTopViewController
                    preVC.editNum = 1
                    preVC.task = self.task
                    
                } else {
                    self.postData.career = self.careerTextView.text!
                    self.postData.season = self.seasonTextField.text!
                    self.postData.day = self.day
                    self.postData.period = self.period
                    self.postData.faculty = self.facultyTextField.text!
                    self.postData.classRoom = self.classTextField.text!
                    self.postData.evaRate = self.evaRateTextView.text!
                    
                    let preVC = self.presentingViewController as! ClassTopViewController
                    preVC.editNum = 1
                    preVC.postData = self.postData
                    
                }
                
                
                
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(dialog, animated: true, completion: nil)
            
            
        } else {
            let dialog = UIAlertController(title: "空欄があります", message: "学期、時間、教室は空欄にできません", preferredStyle: .alert)
            
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(dialog, animated: true, completion: nil)
        }
        
    }
    
    @objc func tapBackButton(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //    pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == dayPickerView {
            return 2
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dayPickerView {
            return 6
        } else if pickerView == facultyPickerView {
            return dataList2.count
        } else {
            return dataList4.count
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
        
        dayTextField.inputAccessoryView = toolBar
        facultyTextField.inputAccessoryView = toolBar
        classTextField.inputAccessoryView = toolBar
        evaRateTextView.inputAccessoryView = toolBar
        seasonTextField.inputAccessoryView = toolBar
        careerTextView.inputAccessoryView = toolBar
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dayPickerView {
            return dataList[component][row]
        } else if pickerView == facultyPickerView {
            
            return dataList2[row]
        } else {
            return dataList4[row]
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
            }
            if data2 == "すべての時間" {
                data2 = ""
            }
            
            dayTextField.text = data1 + data2
        } else if pickerView == facultyPickerView {
            if row == 0 {
                facultyTextField.text = ""
            } else {
                facultyTextField.text = dataList2[row]
            }
        } else {
            seasonTextField.text = dataList4[row]
        }
    }
    @objc func donePicker() {
        
        dayTextField.endEditing(true)
        facultyTextField.endEditing(true)
        classTextField.endEditing(true)
        seasonTextField.endEditing(true)
        evaRateTextView.endEditing(true)
        careerTextView.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        dayTextField.endEditing(true)
        facultyTextField.endEditing(true)
        classTextField.endEditing(true)
        seasonTextField.endEditing(true)
        evaRateTextView.endEditing(true)
        careerTextView.endEditing(true)
    }
    
    
    
}

//ファイル共有ページ

class ClassTop3ViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate {
    
    struct File {
        var fileURLs = ""
        var titles = ""
        var dates = ""
        var uuidTimes = ""
    }
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    var fileArray = [File]()
    
    var itemInfo: IndicatorInfo = "ファイル"
    //    ClassTopViewControllerからの値の受け取り
    var task: Task!
    var taskArray = try! Realm().objects(Task.self)
    
    var noDataCount = 0
    let noDataLabel = UILabel()
    
    //    どこから遷移したか　　0 = Home  1 = ClassList
    var checkSegue = 0
    
    var postData: PostData!
    var documentID = ""
    @IBOutlet weak var tableView: UITableView!
    
    var uuidTime = ""
    
    var uuidTimeArray:[String] = []
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //    データがない時
        
        noDataLabel.frame = CGRect(x: self.tableView.frame.size.width / 2 - 100, y: self.tableView.frame.size.height / 3, width: 200, height: 100)
        noDataLabel.text = "Sorry,there is no data."
        noDataLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        noDataLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        noDataLabel.numberOfLines = 0
        noDataLabel.contentMode = .center
        
        
        
        
        if Auth.auth().currentUser != nil {
            print("ドキュメント\(documentID)")
            //        質問数のカウント
            
            let storage = Storage.storage()
            let storageReference = storage.reference().child(loginApp.collegeNameData).child(documentID)
            storageReference.listAll { (result, error) in
                if let error = error {
                    // ...
                    print(error)
                    print("B")
                }
                for prefix in result.prefixes {
                    
                    
                    let prefixStr = "\(prefix)"
                    let arr:[String] = prefixStr.components(separatedBy: "/")
                    
                    var file = File()
                    file.uuidTimes = arr[6]
                    
                    let storage = Storage.storage()
                    let fileURLRef = storage.reference().child(self.loginApp.collegeNameData).child(self.documentID).child("\(arr[6])").child("fileURL")
                    
                    let MAX_SIZE:Int64 = 1024 * 1024
                    fileURLRef.getData(maxSize: MAX_SIZE) { result, error in
                        let fileURL = String(data: result!, encoding: String.Encoding.utf32)!
                        file.fileURLs = fileURL
                        
                        
                        if file.titles != "" && file.dates != "" {
                            self.fileArray.append(file)
                            self.tableView.reloadData()
                            
                        }
                        
                    }
                    
                    let detailRef = storage.reference().child(self.loginApp.collegeNameData).child(self.documentID).child("\(arr[6])").child("detail")
                    
                    detailRef.getData(maxSize: MAX_SIZE) { result, error in
                        let title = String(data: result!, encoding: String.Encoding.utf32)!
                        file.titles = title
                        if file.fileURLs != "" && file.dates != "" {
                            self.fileArray.append(file)
                            self.tableView.reloadData()
                            
                        }
                        
                    }
                    
                    let dateRef = storage.reference().child(self.loginApp.collegeNameData).child(self.documentID).child("\(arr[6])").child("date")
                    
                    dateRef.getData(maxSize: MAX_SIZE) { result, error in
                        let date = String(data: result!, encoding: String.Encoding.utf32)!
                        file.dates = date
                        if file.titles != "" && file.fileURLs != "" {
                            self.fileArray.append(file)
                            self.tableView.reloadData()
                            
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    @IBAction func updateButton(_ sender: Any) {
        
        var alertTextField: UITextField?
        var detailTextField: UITextField?
        
        let alert = UIAlertController(
            title: "ファイルのアップロード", message: "空欄にアップロードしたいファイルのリンクをコピーしてください", preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
            alertTextField?.placeholder = "ファイルのURLをコピーしてください"
        })
        alert.addTextField(configurationHandler: {(textFields: UITextField!) in
            detailTextField = textFields
            detailTextField?.placeholder = "ファイルの内容について記載してください"
        })
        
        alert.addAction(
            UIAlertAction(
                title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil
            )
        )
        
        alert.addAction(
            UIAlertAction(
            title: "OK", style: UIAlertAction.Style.default) { _ in
                if alertTextField?.text != "" && detailTextField?.text != "" {
                    let deviceId = UIDevice.current.identifierForVendor!.uuidString
                    let time = Int(Date().timeIntervalSince1970)
                    self.uuidTime = "\(deviceId)\(time)"
                    let storage = Storage.storage()
                    let content = alertTextField?.text
                    let detail = detailTextField?.text
                    let dt = Date()
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
                    let date = dateFormatter.string(from: dt)
                    
                    let fileRef = storage.reference().child(self.loginApp.collegeNameData).child("\(self.documentID)").child("\(self.uuidTime)").child("fileURL")
                    fileRef.putData((content?.data(using: String.Encoding.utf32)!)!,
                                    metadata: nil) { metadata, error in
                                        print("yes")
                    }
                    
                    let detailRef = storage.reference().child(self.loginApp.collegeNameData).child("\(self.documentID)").child("\(self.uuidTime)").child("detail")
                    detailRef.putData((detail?.data(using: String.Encoding.utf32)!)!,
                                      metadata: nil) { metadata, error in
                                        print("yes")
                    }
                    
                    let dateRef = storage.reference().child(self.loginApp.collegeNameData).child("\(self.documentID)").child("\(self.uuidTime)").child("date")
                    dateRef.putData((date.data(using: String.Encoding.utf32)!),
                                    metadata: nil) { metadata, error in
                                        print("yes")
                    }
                    
                } else {
                    let alert = UIAlertController(
                        title: "空欄があります", message: "ファイルをアップロードするには２つのテキストフィールドを埋める必要があります", preferredStyle: UIAlertController.Style.alert)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fileArray.count == 0 {
            if noDataCount == 0 {
                self.tableView.addSubview(noDataLabel)
                noDataCount += 1
            }
        } else {
            noDataLabel.removeFromSuperview()
        }
        return fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //        Tag番号を使ってセット
        let contentTitleLabel = cell.contentView.viewWithTag(1) as! UILabel
        let fileURLLabel = cell.contentView.viewWithTag(2) as! TTTAttributedLabel
        let dateLabel = cell.contentView.viewWithTag(3) as! UILabel
        let view = cell.contentView.viewWithTag(4) as! UIView
        fileURLLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        fileURLLabel.delegate = self
        
        view.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        
        let file = fileArray[indexPath.row]
        
        contentTitleLabel.text = file.titles
        fileURLLabel.text = file.fileURLs
        dateLabel.text = file.dates
        
        return cell
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    
}

