//
//  DetailClassViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift
import Charts
import Firebase
import FirebaseUI
import XLPagerTabStrip

class DetailClassViewController: ButtonBarPagerTabStripViewController {
    
//
//
//
//    var collectionView: UICollectionView!
//    var tableView: UITableView = UITableView()
//    var questiionCount = 0
////
//    @IBOutlet weak var RButton: UIButton!
//    @IBOutlet weak var classNameLabel: UILabel!
//    @IBOutlet weak var dayLabel: UILabel!
//    @IBOutlet weak var facultyLabel: UILabel!
//    @IBOutlet weak var teacherTextField: UILabel!
//    @IBOutlet weak var classRoomTextField: UILabel!
//    @IBOutlet weak var backgroundLabel: UILabel!
//    @IBOutlet weak var evaRateLabel: UILabel!
//    @IBOutlet weak var yearLabel: UILabel!
//    @IBOutlet weak var numberLabel: UILabel!
//
//    @IBOutlet weak var labelA: UILabel!
//    @IBOutlet weak var labelB: UILabel!
//    @IBOutlet weak var labelC: UILabel!
//    @IBOutlet weak var labelD: UILabel!
//    @IBOutlet weak var labelE: UILabel!
//    @IBOutlet weak var labelF: UILabel!
//    @IBOutlet weak var labelG: UILabel!
//
//
//
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var pageControl: UIPageControl!
//    @IBOutlet weak var bigScrollView: UIScrollView!
//
////
//    @IBOutlet weak var registerButtonTitle: UIButton!
//
//    var view1 = UIView()
//    var view2 = UIView()
//
//
//    //    画像用
//    var image:UIImage!
//    var imageNumData = 1
//    var segumentCount = 0
//
//    var indexNum = 0
//
////    質問用
//    var uuidTimeArray:[String] = []
//    var uuidTime = ""
//
//    //    円グラフ
//    let gradeChartsView = PieChartView()
//    let levelChartsView = PieChartView()
//    let evaChartsView = PieChartView()
//
//
//
//    var dayNum = 0
//    var periodNum = 0
//
    //    Realm

    let realm = try! Realm()
    var task: Task!
    var taskArray = try! Realm().objects(Task.self)

    //    どこから遷移したか　　0 = Home  1 = ClassList
    var checkSegue = 0


    var postData: PostData!
    var documentID = ""

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//
//        labelA.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        labelB.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        labelC.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        labelD.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        labelE.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        labelF.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        labelG.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//
//
//        dayLabel.layer.cornerRadius = 5
//        dayLabel.clipsToBounds = true
//        facultyLabel.layer.cornerRadius = 5
//        facultyLabel.clipsToBounds = true
//        teacherTextField.layer.cornerRadius = 5
//        teacherTextField.clipsToBounds = true
//        classRoomTextField.layer.cornerRadius = 5
//        classRoomTextField.clipsToBounds = true
//        evaRateLabel.layer.cornerRadius = 5
//        evaRateLabel.clipsToBounds = true
//        yearLabel.layer.cornerRadius = 5
//        yearLabel.clipsToBounds = true
//        numberLabel.layer.cornerRadius = 5
//        numberLabel.clipsToBounds = true
//
//        labelA.layer.cornerRadius = 5
//        labelA.clipsToBounds = true
//        labelB.layer.cornerRadius = 5
//        labelB.clipsToBounds = true
//        labelC.layer.cornerRadius = 5
//        labelC.clipsToBounds = true
//        labelD.layer.cornerRadius = 5
//        labelD.clipsToBounds = true
//        labelE.layer.cornerRadius = 5
//        labelE.clipsToBounds = true
//        labelF.layer.cornerRadius = 5
//        labelF.clipsToBounds = true
//        labelG.layer.cornerRadius = 5
//        labelG.clipsToBounds = true
//
//
//        RButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
//        RButton.layer.cornerRadius = 10
//        RButton.clipsToBounds = true
//
//        if checkSegue == 0 {
//            self.documentID = task.documentID
//        }
//
//
//
//        view1.frame = CGRect(x: view.frame.size.width, y: 0, width: bigScrollView.frame.size.width , height: bigScrollView.frame.size.height)
//        view1.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        bigScrollView.addSubview(view1)
//
//        view2.frame = CGRect(x: view.frame.size.width * 2, y: 0, width: bigScrollView.frame.size.width , height: bigScrollView.frame.size.height)
//        view2.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        bigScrollView.addSubview(view2)
//
//        backgroundLabel.backgroundColor = .white
    
    //        if checkSegue == 0 {
    //            classNameLabel.text = task.className
    //            dayLabel.text = "\(task.day + task.period)"
    //            facultyLabel.text = "\(task.faculty)"
    //            teacherTextField.text = "\(task.teacher)"
    //            classRoomTextField.text = "\(task.classRoom)"
    //
    //        } else {
    //
    //            classNameLabel.text = "\(postData.className!)"
    //            dayLabel.text = "\(postData.day!) \(postData.period!)"
    //            facultyLabel.text = "\(postData.faculty!)"
    //            teacherTextField.text = "\(postData.teacher!)"
    //            classRoomTextField.text = "\(postData.classRoom!)"
    //
    //        }
        
//
//
//        scrollView.delegate = self
//        bigScrollView.delegate = self
//        scrollView.showsHorizontalScrollIndicator = false
//        bigScrollView.showsHorizontalScrollIndicator = false
//        self.view.addSubview(bigScrollView)
//
//        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 3, height: scrollView.frame.size.height)
//        bigScrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: bigScrollView.frame.size.height)
//        self.view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)

    
//        self.gradeChartsView.centerText = "評定"
//        self.levelChartsView.centerText = "難易度"
//        self.evaChartsView.centerText = "満足度"
//
//        // グラフに表示するデータのタイトルと値
//        let dataEntries = [
//            PieChartDataEntry(value: 40, label: "A"),
//            PieChartDataEntry(value: 35, label: "B"),
//            PieChartDataEntry(value: 25, label: "C")
//        ]
//
//        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
//
//
//        // グラフの色
//        dataSet.colors = ChartColorTemplates.liberty()
//        // グラフのデータの値の色
//        dataSet.valueTextColor = UIColor.black
//        // グラフのデータのタイトルの色
//        dataSet.entryLabelColor = UIColor.black
//
//        self.gradeChartsView.data = PieChartData(dataSet: dataSet)
//        self.levelChartsView.data = PieChartData(dataSet: dataSet)
//        self.evaChartsView.data = PieChartData(dataSet: dataSet)
//
//        // データを％表示にする
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .percent
//        formatter.maximumFractionDigits = 2
//        formatter.multiplier = 1.0
//        self.gradeChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
//        self.gradeChartsView.usePercentValuesEnabled = true
//        self.gradeChartsView.legend.enabled = false
//        self.gradeChartsView.rotationEnabled = false
//
//
//        gradeChartsView.frame = CGRect(x:0, y:0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
//
//        self.levelChartsView.usePercentValuesEnabled = true
//        self.levelChartsView.legend.enabled = false
//        self.levelChartsView.rotationEnabled = false
//
//        levelChartsView.frame = CGRect(x:self.scrollView.frame.size.width, y:0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
//
//        self.evaChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
//        self.evaChartsView.usePercentValuesEnabled = true
//        self.evaChartsView.legend.enabled = false
//        self.evaChartsView.rotationEnabled = false
//
//        evaChartsView.frame = CGRect(x:self.scrollView.frame.size.width * 2, y:0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
//
//
//        self.scrollView.addSubview(gradeChartsView)
//        self.scrollView.addSubview(levelChartsView)
//        self.scrollView.addSubview(evaChartsView)
//
//        self.bigScrollView.addSubview(scrollView)
//
//        //       登録ボタンのタイトル
//        if checkSegue == 0 {
//            registerButtonTitle.setTitle("時間割から削除", for: .normal)
//        } else {
//            registerButtonTitle.setTitle("時間割に登録", for: .normal)
//        }
//
//        if Auth.auth().currentUser != nil {
//            Firestore.firestore().collection(Const.PostPath).document(documentID).getDocument { (snap, error) in
//                if let error = error {
//                    print(error)
//                    return
//                }
//
//                guard let data = snap?.data() else { return }
//                self.imageNumData = data["imageNum"] as! Int
//
//
//            }
//
//            //        質問数のカウント
//
//            let storage = Storage.storage()
//            let storageReference = storage.reference().child(Const.QuestionPath).child(documentID + "QE")
//            storageReference.listAll { (result, error) in
//                if let error = error {
//                    // ...
//                }
//                for prefix in result.prefixes {
//                    self.questiionCount += 1
//
//                    let prefixStr = "\(prefix)"
//                    let arr:[String] = prefixStr.components(separatedBy: "/")
//                    print("ここ\(arr[5])")
//
//
//                    self.uuidTimeArray.append(arr[5])
//                    print("配列\(self.uuidTimeArray)")
//
//                    self.tableView.reloadData()
//
//                }
//
//
//            }
//
//        }
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super .viewWillAppear(true)
//
//        if collectionView != nil {
//            collectionView.reloadData()
//        }
//
//    }
//
//    @IBAction func segumented(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            self.bigScrollView.contentOffset.x = 0
//        case 1:
//            self.bigScrollView.contentOffset.x = bigScrollView.frame.size.width
//            createTableView()
//        default:
//            self.bigScrollView.contentOffset.x = bigScrollView.frame.size.width * 2
//            createCollectionView()
//        }
//    }
//
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.x != 0.0 {
//            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX + 1)
//        } else {
//            pageControl.currentPage = 0
//        }
//
//
//    }
//
//    @IBAction func registerButton(_ sender: Any) {
//
//        if postData != nil {
//            switch postData.day {
//            case "月曜":
//                dayNum = 1
//            case "火曜":
//                dayNum = 2
//            case "水曜":
//                dayNum = 3
//            case "木曜":
//                dayNum = 4
//            case "金曜":
//                dayNum = 5
//            case "土曜":
//                dayNum = 6
//            default:
//                dayNum = 1
//            }
//
//            switch postData.period {
//            case "1限":
//                periodNum = 1
//            case "2限":
//                periodNum = 2
//            case "3限":
//                periodNum = 3
//            case "4限":
//                periodNum = 4
//            case "5限":
//                periodNum = 5
//            case "6限":
//                periodNum = 6
//            default:
//                periodNum = 1
//            }
//
//
//            let taskArray2 = try! Realm().objects(Task.self).filter("cellPoint == \((periodNum - 1) * 6 + dayNum)")
//            if taskArray2.count != 0 {
//                task = taskArray2[0]
//            } else {
//                task = Task()
//                if taskArray.count != 0 {
//                    task.id = taskArray.max(ofProperty: "id")! + 1
//                }
//            }
//
//            try! realm.write {
//                self.task.className = postData.className!
//                self.task.day = postData.day!
//                self.task.period = postData.period!
//                self.task.documentID = documentID
//                self.task.faculty = postData.faculty!
//                self.task.teacher = postData.teacher!
//                self.task.classRoom = postData.classRoom!
//                self.task.cellPoint = (periodNum - 1) * 6 + dayNum
//                self.task.gradeS = postData.gradeS!
//                self.task.gradeA = postData.gradeA!
//                self.task.gradeB = postData.gradeB!
//                self.task.gradeC = postData.gradeC!
//                self.task.gradeD = postData.gradeD!
//                self.task.level4 = postData.level4!
//                self.task.level3 = postData.level3!
//                self.task.level2 = postData.level2!
//                self.task.level1 = postData.level1!
//                self.task.evaA = postData.evaA!
//                self.task.evaB = postData.evaB!
//                self.task.evaC = postData.evaC!
//                self.task.evaD = postData.evaD!
//
//                self.realm.add(self.task, update: .modified)
//            }
//
//            //                画面を閉じる
//            self.dismiss(animated: true, completion: nil)
//
//
//        } else {
//
//
//            let dialog = UIAlertController(title: "教科の削除", message: "この教科を時間割から削除しますか？", preferredStyle: .alert)
//
//
//             dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//
//             dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//
//                try! self.realm.write {
//                    self.realm.delete(self.task)
//                }
//
//                //                画面を閉じる
//                self.dismiss(animated: true, completion: nil)
//
//             }))
//
//             self.present(dialog, animated: true, completion: nil)
//        }
//
//    }
//
//    @IBAction func returnButton(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//
//
//    //    コレクションビュー
//
//    func createCollectionView() {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: self.view1.frame.size.width / 3 - 1, height: self.view1.frame.size.width / 3 - 1)
//        flowLayout.scrollDirection = .vertical
//        flowLayout.minimumInteritemSpacing = 1
//        flowLayout.minimumLineSpacing = 1
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: flowLayout)
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = .clear
//        self.view2.addSubview(collectionView)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(imageNumData)
//        return imageNumData
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        let imageView = UIImageView()
//
//        imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
//        cell.addSubview(imageView)
//
//
//        if indexPath.row == 0 {
//            cell.backgroundColor = .gray
//            imageView.backgroundColor = .gray
//            imageView.image = UIImage(named: "camera")
//
//        } else {
//
//            imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(documentID + ".jpg").child("\(indexPath.row)")
//
//
//            imageView.sd_setImage(with: imageRef)
//
//        }
//
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//                let pickerController = UIImagePickerController()
//                pickerController.delegate = self
//                pickerController.sourceType = .photoLibrary
//                self.present(pickerController, animated: true, completion: nil)
//            }
//        } else {
//            let imageViews = UIImageView()
//            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(documentID + ".jpg").child("\(indexPath.row)")
//            imageViews.sd_setImage(with: imageRef)
//            image = imageViews.image
//            performSegue(withIdentifier: "toPost", sender: nil)
//        }
//    }
//
//
//    //    テーブルビュー
//
//    func createTableView() {
//
//        tableView.frame = CGRect(x: 0, y: 0, width: self.view2.frame.size.width, height: self.view2.frame.size.height)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        tableView.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//        tableView.rowHeight = 60
//        self.view1.addSubview(tableView)
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return uuidTimeArray.count + 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // 再利用可能な cell を得る
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
//
//        if indexPath.row != 0 {
//            let storage = Storage.storage()
//            let textRef = storage.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(uuidTimeArray[indexPath.row - 1])").child("title")
//
//            let MAX_SIZE:Int64 = 1024 * 1024
//            textRef.getData(maxSize: MAX_SIZE) { result, error in
//                cell.textLabel?.text = String(data: result!, encoding: String.Encoding.utf32)
//
//            }
//        } else {
//            cell.textLabel?.text = "＋  新しく質問をする"
//            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
//            cell.textLabel?.textColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if indexPath.row == 0 {
//            performSegue(withIdentifier: "toQuestion", sender: nil)
//        } else {
//            self.indexNum = indexPath.row
//            self.uuidTime = uuidTimeArray[indexPath.row - 1]
//            performSegue(withIdentifier: "toList", sender: nil)
//        }
//         tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    //    写真の処理
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if info[.originalImage] != nil {
//            //            画像を取得
//            image = info[.originalImage] as? UIImage
//
//
//
//
//            self.performSegue(withIdentifier: "toPost", sender: nil)
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toPost" {
//            let postImageViewController:PostImageViewController = segue.destination as! PostImageViewController
//            postImageViewController.image = image
//            postImageViewController.documentID = documentID
//            postImageViewController.imageNumData = imageNumData
//        } else if segue.identifier == "toQuestion" {
//            let questionViewController:QuestionViewController = segue.destination as! QuestionViewController
//            questionViewController.documentID = documentID
//
//        } else {
//            let questionListViewController:QuestionListViewController = segue.destination as! QuestionListViewController
//            questionListViewController.documentID = documentID
//            questionListViewController.childNum = indexNum
//            questionListViewController.uuidTime = uuidTime
//        }
//
//    }
//
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

