//
//  QuestionViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/08/19.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class QuestionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    var appDetail:AppDetail!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detaileTextView: UITextView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var QButton: UIButton!
    
    @IBOutlet weak var PhotoButton: UIButton!
    @IBOutlet weak var CameraButton: UIButton!
    
    
    var documentID = ""
    
    var titleText = ""
    var detaileText = ""
    
    
    //    画像
    var image: UIImage!
    var imageArray:[UIImage] = []
    
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
        
        self.view.backgroundColor = .white
        
        titleTextField.text = titleText
        detaileTextView.text = detaileText
        
        
        titleTextField.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.2)
        
        detaileTextView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.2)
        detaileTextView.layer.cornerRadius = 10.0
        detaileTextView.clipsToBounds = true
        
        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        QButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        QButton.layer.cornerRadius = 10
        QButton.clipsToBounds = true
        
        
        
        //       CollectionViewのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
        
    }
    
    
    
    //    画像処理
    @IBAction func pictureButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            pickerController
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    
    
    //    写真の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if info[.originalImage] != nil {
            //            画像を取得
            image = info[.originalImage] as? UIImage
            
            
            self.performSegue(withIdentifier: "toPicture", sender: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func questionButton(_ sender: Any) {
        
       
            if self.titleTextField.text != "" && self.detaileTextView.text != "" {
                
                let dialog = UIAlertController(title: "質問を送信", message: "この内容で質問を送信しますか？", preferredStyle: .alert)
                
                dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    let deviceId = UIDevice.current.identifierForVendor!.uuidString
                    let time = Int(Date().timeIntervalSince1970)
                    let deviceIdTime = "\(deviceId)\(time)"
                    
                    
                    
                    let name = Auth.auth().currentUser?.displayName
                    
                    let storage = Storage.storage()
                    let textRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(self.documentID + "QE").child("\(deviceIdTime)").child("title")
                    let contentRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(self.documentID + "QE").child("\(deviceIdTime)").child("content")
                    let nameRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(self.documentID + "QE").child("\(deviceIdTime)").child("name")
                    let str = self.titleTextField.text!
                    let cont = self.detaileTextView.text!
                    textRef.putData(str.data(using: String.Encoding.utf32)!,
                                    metadata: nil) { metadata, error in
                                        print("yes")
                        try! self.realm.write {
                            self.appDetail.apperQCount = 1
                            self.realm.add(self.appDetail)
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                    contentRef.putData(cont.data(using: String.Encoding.utf32)!,
                                       metadata: nil) { metadata, error in
                                        print("yes")
                    }
                    
                    nameRef.putData(name!.data(using: String.Encoding.utf32)!,
                                    metadata: nil) { metadata, error in
                                        print("yes")
                    }
                    
                    //        画像アップロード
                    if self.imageArray.count != 0 {
                        for i in 0 ..< self.imageArray.count {
                            print(i)
                            let postImage = self.imageArray.first
                            self.imageArray.removeFirst()
                            
                            let imageData = postImage?.jpegData(compressionQuality: 0.75)
                            let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.ImagePath).child(self.documentID + ".jpg").child("\(deviceIdTime)").child("image\(i)")
                            let metadata = StorageMetadata()
                            metadata.contentType = "image/jpeg"
                            imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                                if error != nil {
                                    //                        アップロード失敗
                                    print(error!)
                                    return
                                }
                            }
                            
                        }
                    }
                    
                }))
                self.present(dialog, animated: true, completion: nil)
                
            } else {
                let dialog = UIAlertController(title: "空欄があります", message: "タイトル、詳細のいずれの空欄も入力してください", preferredStyle: .alert)
                
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = UIImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
        cell.addSubview(imageView)
        
        imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    //   セルのレイアウトを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.layer.bounds.width
        let height = self.collectionView.layer.bounds.height
        
        let widthcellSize : CGFloat = width / 5 - 2
        
        return CGSize(width: widthcellSize, height: height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let postImageViewController:PostImageViewController = segue.destination as! PostImageViewController
        postImageViewController.image = image
        postImageViewController.documentID = documentID
        postImageViewController.imageArray = imageArray
       
        postImageViewController.titleText = titleTextField.text!
        postImageViewController.contentText = detaileTextView.text!
    }
    
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.endEditing(true)
        detaileTextView.endEditing(true)
        
    }
    
    
}



