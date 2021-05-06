//
//  AnswerViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/08/19.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class AnswerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate {
    
    let realm = try! Realm()
    var loginApp:LoginApp!

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detaileLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView! {
        didSet {
            answerTextView.delegate = self
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var AButton: UIButton!
    
    
    var documentID = ""
    var titleText = ""
    var contentText = ""
    var answerText = ""
    var childNum = 0
    var uuidTime = ""
    
    var answerCount = 0
    
    var image: UIImage!
    var imageArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
        }
       
        // Do any additional setup after loading the view.
        titleLabel.text = titleText
        detaileLabel.text = contentText
        answerTextView.text = answerText
        
        view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        detaileLabel.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.2)
        detaileLabel.layer.cornerRadius = 10.0
        detaileLabel.clipsToBounds = true
        
        AButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        AButton.layer.cornerRadius = 10.0
        AButton.clipsToBounds = true
        
        answerTextView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.2)
        answerTextView.layer.cornerRadius = 10.0
        answerTextView.clipsToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
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
        self.configureObserver()
        print(imageArray.count)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.removeObserver()
    }
    
    
    @IBAction func imageButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            
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
            
           
            
            self.performSegue(withIdentifier: "tophoto", sender: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func answerButton(_ sender: Any) {
        
        
            if self.answerTextView.text != "" {
                
                let dialog = UIAlertController(title: "回答を送信", message: "この内容で回答を送信しますか？", preferredStyle: .alert)
                
                
                dialog.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    let name = Auth.auth().currentUser?.displayName
                    let storage = Storage.storage()
                    let textRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(self.documentID + "QE").child("\(self.uuidTime)").child("answer\(self.answerCount + 1)").child("content")
                    let str = self.answerTextView.text!
                    textRef.putData(str.data(using: String.Encoding.utf32)!,
                                    metadata: nil) { metadata, error in
                                        print("yes")
                    }
                    
                    let nameRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.QuestionPath).child(self.documentID + "QE").child("\(self.uuidTime)").child("answer\(self.answerCount + 1)").child("name")
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
                            let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.ImagePath).child(self.documentID + ".jpg").child("\(self.uuidTime)").child("answer\(self.answerCount + 1)").child("image\(i)")
                            let metadata = StorageMetadata()
                            metadata.contentType = "image/jpeg"
                            imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
                                if error != nil {
                                    print(error!)
                                    return
                                }
                            }
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(dialog, animated: true, completion: nil)
                
                
            } else {
                let dialog = UIAlertController(title: "空欄があります", message: "回答内容を入力してください", preferredStyle: .alert)
                
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
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
        postImageViewController.segueCount = 1
        postImageViewController.image = image

        postImageViewController.imageArray = imageArray

        
    }
    
    @IBAction func returnButton(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        answerTextView.endEditing(true)
        
    }
    
    //    textView関連
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    // Notificationを設定
    func configureObserver() {
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // Notificationを削除
    func removeObserver() {
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    
    // キーボードが現れた時に、画面全体をずらす。
    @objc func keyboardWillShow(notification: Notification?) {
        
        //        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let transform = CGAffineTransform(translationX: 0, y: -200)
            self.view.transform = transform
            
        })
    }
    
    // キーボードが消えたときに、画面を戻す
    @objc func keyboardWillHide(notification: Notification?) {
        
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
}
