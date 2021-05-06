//
//  MakeAdViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/09/08.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import CLImageEditor
import Firebase
import RealmSwift


class MakeAdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    //    @IBOutlet weak var imageView: UIImageView!
    //    @IBOutlet weak var textField: UITextField!
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    var appDetail:AppDetail!
  
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let contentView = UIView()
    let teamNameLabel = UILabel()
    let teamNameTextField = UITextField()
    let genreLabel = UILabel()
    let genreTextField = UITextField()
    let facultyLabel = UILabel()
    let facultyTextView = UITextView()
    let actLabel = UILabel()
    let actTextView = UITextView()
    let dayPlaceLabel = UILabel()
    let dayPlaceTextView = UITextView()
    let costLabel = UILabel()
    let costTextView = UITextView()
    let memberLabel = UILabel()
    let memberTextView = UITextView()
    let contactLabel = UILabel()
    let contactTextView = UITextView()
    let passWordLabel = UILabel()
    let passWordTextField = UITextField()
    let checkPassWordLabel = UILabel()
    let checkPassWordTextField = UITextField()
    let imageLabel = UILabel()
    let imageButton = UIButton()
    let imageView = UIImageView()
    let postButton = UIButton()
    let backButton = UIButton()
    
    let dataList = ["球技","その他スポーツ","音楽、ダンス","ボランティア","その他"]
    
    var categoryPickerView = UIPickerView()
    
    //    編集遷移からの受け取り
    var checkSegue = 0
    var teamName = ""
    var uuidTime = ""
    var genre = ""
    var password = ""
    
    var image:UIImage!
    
    
    
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

        
        let width = view.frame.size.width
        
        
        scrollView.contentSize = CGSize(width: width, height: 1920)
        
        //        戻るボタン
        backButton.frame = CGRect(x: 0, y: 0, width: 115, height: 40)
        backButton.setTitle("《 Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        backButton.addTarget(self, action: #selector(tapBackButton(_:)), for: .touchUpInside)
        backButton.setTitleColor(UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1), for: .normal)
        
        
        
        //        団体名
        teamNameLabel.frame = CGRect(x: 10, y: 60, width: width - 20, height: 20)
        teamNameLabel.textAlignment = .center
        teamNameLabel.text = "団体名"
        teamNameTextField.frame = CGRect(x: 10, y: 100, width: width - 20, height: 30)
        teamNameTextField.textAlignment = .center
        teamNameTextField.placeholder = "団体名を入力してください"
        teamNameTextField.font = UIFont.systemFont(ofSize: 16.0)
        teamNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        teamNameTextField.layer.borderWidth = 1.0
        teamNameTextField.layer.cornerRadius = 5
        teamNameTextField.clipsToBounds = true
        
        //        ジャンル
        genreLabel.frame = CGRect(x: 10, y: 150, width: width - 20, height: 20)
        genreLabel.textAlignment = .center
        genreLabel.text = "ジャンル"
        genreTextField.frame = CGRect(x: 10, y: 190, width: width - 20, height: 30)
        genreTextField.textAlignment = .center
        genreTextField.placeholder = "ジャンルを選択してください"
        genreTextField.font = UIFont.systemFont(ofSize: 16.0)
        genreTextField.layer.borderColor = UIColor.lightGray.cgColor
        genreTextField.layer.borderWidth = 1.0
        genreTextField.layer.cornerRadius = 5
        genreTextField.clipsToBounds = true
        
        //        対象学部
        facultyLabel.frame = CGRect(x: 10, y: 240, width: width - 20, height: 20)
        facultyLabel.textAlignment = .center
        facultyLabel.text = "対象学部、キャンパスなど"
        facultyTextView.frame = CGRect(x: 10, y: 280, width: width - 20, height: 60)
        facultyTextView.font = UIFont.systemFont(ofSize: 16.0)
        facultyTextView.layer.borderColor = UIColor.lightGray.cgColor
        facultyTextView.layer.borderWidth = 1.0
        facultyTextView.layer.cornerRadius = 5
        facultyTextView.clipsToBounds = true
        
        //        活動内容
        actLabel.frame = CGRect(x: 10, y: 360, width: width - 20, height: 20)
        actLabel.textAlignment = .center
        actLabel.text = "活動内容"
        actTextView.frame = CGRect(x: 10, y: 400, width: width - 20, height: 150)
        actTextView.font = UIFont.systemFont(ofSize: 16.0)
        actTextView.layer.borderColor = UIColor.lightGray.cgColor
        actTextView.layer.borderWidth = 1.0
        actTextView.layer.cornerRadius = 5
        actTextView.clipsToBounds = true
        
        //        活動日時、場所
        dayPlaceLabel.frame = CGRect(x: 10, y: 570, width: width - 20, height: 20)
        dayPlaceLabel.textAlignment = .center
        dayPlaceLabel.text = "活動日時　場所など"
        dayPlaceTextView.frame = CGRect(x: 10, y: 610, width: width - 20, height: 100)
        dayPlaceTextView.font = UIFont.systemFont(ofSize: 16.0)
        dayPlaceTextView.layer.borderColor = UIColor.lightGray.cgColor
        dayPlaceTextView.layer.borderWidth = 1.0
        dayPlaceTextView.layer.cornerRadius = 5
        dayPlaceTextView.clipsToBounds = true
        
        //        費用
        costLabel.frame = CGRect(x: 10, y: 730, width: width - 20, height: 20)
        costLabel.textAlignment = .center
        costLabel.text = "費用"
        costTextView.frame = CGRect(x: 10, y: 770, width: width - 20, height: 100)
        costTextView.font = UIFont.systemFont(ofSize: 16.0)
        costTextView.layer.borderColor = UIColor.lightGray.cgColor
        costTextView.layer.borderWidth = 1.0
        costTextView.layer.cornerRadius = 5
        costTextView.clipsToBounds = true
        
        //        人数構成
        memberLabel.frame = CGRect(x: 10, y: 890, width: width - 20, height: 20)
        memberLabel.textAlignment = .center
        memberLabel.text = "人数構成など"
        memberTextView.frame = CGRect(x: 10, y: 930, width: width - 20, height: 80)
        memberTextView.font = UIFont.systemFont(ofSize: 16.0)
        memberTextView.layer.borderColor = UIColor.lightGray.cgColor
        memberTextView.layer.borderWidth = 1.0
        memberTextView.layer.cornerRadius = 5
        memberTextView.clipsToBounds = true
        
        //        連絡先
        contactLabel.frame = CGRect(x: 10, y: 1030, width: width - 20, height: 20)
        contactLabel.textAlignment = .center
        contactLabel.text = "連絡先、SNSなど"
        contactTextView.frame = CGRect(x: 10, y: 1070, width: width - 20, height: 80)
        contactTextView.font = UIFont.systemFont(ofSize: 16.0)
        contactTextView.layer.borderColor = UIColor.lightGray.cgColor
        contactTextView.layer.borderWidth = 1.0
        contactTextView.layer.cornerRadius = 5
        contactTextView.clipsToBounds = true
        
        //        パスワード
        passWordLabel.frame = CGRect(x: 10, y: 1170, width: width - 20, height: 20)
        passWordLabel.textAlignment = .center
        passWordLabel.text = "編集用パスワード"
        passWordTextField.frame = CGRect(x: 10, y: 1210, width: width - 20, height: 30)
        passWordTextField.textAlignment = .center
        passWordTextField.placeholder = "パスワードを設定してください(6字以上推奨)"
        passWordTextField.font = UIFont.systemFont(ofSize: 16.0)
        passWordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passWordTextField.layer.borderWidth = 1.0
        passWordTextField.layer.cornerRadius = 5
        passWordTextField.clipsToBounds = true
        
        //        パスワード(確認用)
        checkPassWordLabel.frame = CGRect(x: 10, y: 1260, width: width - 20, height: 20)
        checkPassWordLabel.textAlignment = .center
        checkPassWordLabel.text = "編集用パスワード(確認)"
        checkPassWordTextField.frame = CGRect(x: 10, y: 1300, width: width - 20, height: 30)
        checkPassWordTextField.textAlignment = .center
        checkPassWordTextField.placeholder = "パスワードを設定してください(6字以上推奨)"
        checkPassWordTextField.font = UIFont.systemFont(ofSize: 16.0)
        checkPassWordTextField.layer.borderColor = UIColor.lightGray.cgColor
        checkPassWordTextField.layer.borderWidth = 1.0
        checkPassWordTextField.layer.cornerRadius = 5
        checkPassWordTextField.clipsToBounds = true
        
        
        //        画像
        imageLabel.frame = CGRect(x: 10, y: 1350, width: width - 20, height: 20)
        imageLabel.textAlignment = .center
        imageLabel.text = "ホーム画像"
        imageButton.frame = CGRect(x: width - 90, y: 1390, width: 60, height: 60)
        let buttonImage = UIImage(named: "photo")
        imageButton.setBackgroundImage(buttonImage, for: .normal)
        imageButton.addTarget(self, action: #selector(buttonEvent(_:)), for: .touchUpInside)
        imageView.frame = CGRect(x: 10, y: 1470, width: width - 20, height: 350)
        imageView.image = UIImage(named: "NoImage")
        imageView.contentMode = .scaleAspectFit
        
        //        投稿
        postButton.frame = CGRect(x: 30, y: 1850, width: width - 60, height: 40)
        postButton.setTitle("この内容で投稿", for: .normal)
        postButton.addTarget(self, action: #selector(tapPostButton(_:)), for: .touchUpInside)
        postButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        postButton.layer.cornerRadius = 10
        postButton.clipsToBounds = true
        
        //        画像初期値
        if checkSegue == 0 {
            image = UIImage(named: "NoImage")
        } else {
            teamNameTextField.text = teamName
            imageView.image = image
            passWordTextField.text = password
            genreTextField.text = genre
            checkPassWordTextField.text = password
            setTextField()
        }
        
        
        
        
        scrollView.addSubview(teamNameLabel)
        scrollView.addSubview(teamNameTextField)
        scrollView.addSubview(genreLabel)
        scrollView.addSubview(genreTextField)
        scrollView.addSubview(facultyLabel)
        scrollView.addSubview(facultyTextView)
        scrollView.addSubview(actLabel)
        scrollView.addSubview(actTextView)
        scrollView.addSubview(dayPlaceLabel)
        scrollView.addSubview(dayPlaceTextView)
        scrollView.addSubview(costLabel)
        scrollView.addSubview(costTextView)
        scrollView.addSubview(memberLabel)
        scrollView.addSubview(memberTextView)
        scrollView.addSubview(contactLabel)
        scrollView.addSubview(contactTextView)
        scrollView.addSubview(passWordLabel)
        scrollView.addSubview(passWordTextField)
        scrollView.addSubview(checkPassWordLabel)
        scrollView.addSubview(checkPassWordTextField)
        scrollView.addSubview(imageLabel)
        scrollView.addSubview(imageButton)
        scrollView.addSubview(imageView)
        scrollView.addSubview(postButton)
        scrollView.addSubview(backButton)
        
        createPickerView()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @objc func buttonEvent(_ sender: UIButton) {
        //        ライブラリを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            image = info[.originalImage] as? UIImage
            dismiss(animated: true, completion: nil)
            self.imageView.image = image
            
//            let editor = CLImageEditor(image: image)!
//            editor.delegate = self
//            editor.modalPresentationStyle = .fullScreen
//            picker.present(editor, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
//        dismiss(animated: true, completion: nil)
//        self.imageView.image = image
//    }
//
//    func imageEditorDidCancel(_ editor: CLImageEditor!) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
    
    
    @objc func tapPostButton(_ sender:UIButton) {
        
        if teamNameTextField.text != "" && genreTextField.text != "" && actTextView.text != "" && passWordTextField.text != "" {
            if passWordTextField.text == checkPassWordTextField.text {
                let dialog = UIAlertController(title: "送信", message: "この内容で送信しますか？", preferredStyle: .alert)
                
                dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    //            ここから処理内容
                    
                    let teamName = self.teamNameTextField.text!
                    let genre = self.genreTextField.text!
                    let act = self.actTextView.text!
                    var deviceIdTime = ""
                    if self.checkSegue == 0 {
                        let deviceId = UIDevice.current.identifierForVendor!.uuidString
                        let time = Int(Date().timeIntervalSince1970)
                        deviceIdTime = "\(deviceId)\(time)"
                    } else {
                        deviceIdTime = "\(self.uuidTime)"
                    }
                    
                    let storage = Storage.storage()
                    let teamNameRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("teamName")
                    let genreRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("genre")
                    let actRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("act")
                    
                    teamNameRef.putData(teamName.data(using: String.Encoding.utf32)!,
                                        metadata: nil) { metadata, error in
                                            print("yes")
                    }
                    genreRef.putData(genre.data(using: String.Encoding.utf32)!,
                                     metadata: nil) { metadata, error in
                                        print("yes")
                    }
                    actRef.putData(act.data(using: String.Encoding.utf32)!,
                                   metadata: nil) { metadata, error in
                                    print("yes")
                    }
                    
                    
                    if self.facultyTextView.text != "" {
                        let faculty = self.facultyTextView.text!
                        
                        let facultyRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("faculty")
                        facultyRef.putData(faculty.data(using: String.Encoding.utf32)!,
                                           metadata: nil) { metadata, error in
                                            print("yes")
                        }
                    }
                    
                    if self.dayPlaceTextView.text != "" {
                        let dayPlace = self.dayPlaceTextView.text!
                        let dayPlaceRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("dayPlace")
                        dayPlaceRef.putData(dayPlace.data(using: String.Encoding.utf32)!,
                                            metadata: nil) { metadata, error in
                                                print("yes")
                        }
                    }
                    
                    if self.costTextView.text != "" {
                        let cost = self.costTextView.text!
                        let costRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("cost")
                        costRef.putData(cost.data(using: String.Encoding.utf32)!,
                                        metadata: nil) { metadata, error in
                                            print("yes")
                        }
                    }
                    
                    if self.memberTextView.text != "" {
                        let member = self.memberTextView.text!
                        let memberRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("member")
                        memberRef.putData(member.data(using: String.Encoding.utf32)!,
                                          metadata: nil) { metadata, error in
                                            print("yes")
                        }
                    }
                    
                    if self.contactTextView.text != "" {
                        let contact = self.contactTextView.text!
                        let contactRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("contact")
                        contactRef.putData(contact.data(using: String.Encoding.utf32)!,
                                           metadata: nil) { metadata, error in
                                            print("yes")
                        }
                        
                    }
                    
                    if self.passWordTextField.text != "" {
                        let passWord = self.passWordTextField.text!
                        let passWordRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("passWord")
                        passWordRef.putData(passWord.data(using: String.Encoding.utf32)!,
                                           metadata: nil) { metadata, error in
                                            print("yes")
                        }
                        
                    }

                    
                    if self.image != nil {
                        
                        //                    リサイズ
                        let originalWidth:Float = Float(self.image.size.width)
                        let originalHeight:Float = Float(self.image.size.height)
                        
                        var scale:Float = 1.0
                        var maxsize:Float = 800.0
                        
                        if originalWidth > originalHeight {
                            if originalWidth > maxsize {
                                scale = maxsize / originalWidth
                            }
                        } else {
                            if originalHeight > maxsize {
                                scale = maxsize / originalHeight
                            }
                        }
                        
                        
                        let resizeImage = self.image?.resized(withPercentage: CGFloat(scale))
                        self.image = resizeImage
                        
                        //                    投稿
                        
                        let imageData = self.image?.jpegData(compressionQuality: 0.75)
                        
                        let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(self.genreTextField.text!).child("\(deviceIdTime)").child("image")
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                            if error != nil {
                                //                        アップロード失敗
                                print(error!)
                                return
                            }
                            try! self.realm.write {
                                self.appDetail.count1 = 1
                                self.appDetail.count2 = 1
                                self.appDetail.count3 = 1
                                self.appDetail.count4 = 1
                                self.appDetail.count5 = 1
                                self.realm.add(self.appDetail)
                            }
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                    
                   
                    //            ここまで処理内容
                }))
                self.present(dialog, animated: true, completion: nil)
            } else {
                let dialog = UIAlertController(title: "パスワードの不一致", message: "パスワードが確認用と一致していません。もう一度確認してください。", preferredStyle: .alert)
                
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
                
            }
            
        } else {
            let dialog = UIAlertController(title: "空欄があります", message: "団体名、ジャンル、活動内容、パスワードは空欄にできません", preferredStyle: .alert)
            
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
    }
    
    @objc func tapBackButton(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    //    pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func createPickerView() {
        categoryPickerView.delegate = self
        genreTextField.inputView = categoryPickerView
        
        //        ツールバー作成
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
        genreTextField.inputAccessoryView = toolBar
        teamNameTextField.inputAccessoryView = toolBar
        genreTextField.inputAccessoryView = toolBar
        facultyTextView.inputAccessoryView = toolBar
        actTextView.inputAccessoryView = toolBar
        dayPlaceTextView.inputAccessoryView = toolBar
        costTextView.inputAccessoryView = toolBar
        memberTextView.inputAccessoryView = toolBar
        contactTextView.inputAccessoryView = toolBar
        passWordTextField.inputAccessoryView = toolBar
        checkPassWordTextField.inputAccessoryView = toolBar
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genreTextField.text = dataList[row]
    }
    
    @objc func donePicker() {
        genreTextField.endEditing(true)
        teamNameTextField.endEditing(true)
        genreTextField.endEditing(true)
        facultyTextView.endEditing(true)
        actTextView.endEditing(true)
        dayPlaceTextView.endEditing(true)
        costTextView.endEditing(true)
        memberTextView.endEditing(true)
        contactTextView.endEditing(true)
        passWordTextField.endEditing(true)
        checkPassWordTextField.endEditing(true)
    }
    
    //    編集遷移時
    func setTextField() {
        let storage = Storage.storage()
        let MAX_SIZE:Int64 = 1024 * 1024
        
       
        
        let facultyRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("faculty")
        
        facultyRef.getData(maxSize: MAX_SIZE) { result, error in
            self.facultyTextView.text = String(data: result!, encoding: String.Encoding.utf32)!
            
        }
        
        let actRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("act")
        
        actRef.getData(maxSize: MAX_SIZE) { result, error in
            self.actTextView.text = String(data: result!, encoding: String.Encoding.utf32)!
            
        }
        
        let dayPlaceRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("dayPlace")
        
        dayPlaceRef.getData(maxSize: MAX_SIZE) { result, error in
            self.dayPlaceTextView.text = String(data: result!, encoding: String.Encoding.utf32)!
            
        }
        
        let costRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("cost")
        
        costRef.getData(maxSize: MAX_SIZE) { result, error in
            self.costTextView.text = String(data: result!, encoding: String.Encoding.utf32)!
            
        }
        
        let memberRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("member")
        
        memberRef.getData(maxSize: MAX_SIZE) { result, error in
            self.memberTextView.text = String(data: result!, encoding: String.Encoding.utf32)!
            
        }
        
        let contactRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.CirclePath).child(genre).child(uuidTime).child("contact")
        
        contactRef.getData(maxSize: MAX_SIZE) { result, error in
            self.contactTextView.text = String(data: result!, encoding: String.Encoding.utf32)!
            
        }
    }
    
}


