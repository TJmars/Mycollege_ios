//
//  QuestionViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/08/19.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class QuestionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detaileTextView: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var QButton: UIButton!
    
    @IBOutlet weak var PhotoButton: UIButton!
    @IBOutlet weak var CameraButton: UIButton!
    
    
    var documentID = ""
    var questionCount = 0
    var titleText = ""
    var detaileText = ""
   
    
//    画像
    var image: UIImage!
    var imageArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
        titleTextField.text = titleText
        detaileTextView.text = detaileText
        
        titleTextField.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.2)
        
        detaileTextView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.2)
        detaileTextView.layer.cornerRadius = 10.0
        detaileTextView.clipsToBounds = true
      
       
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
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
        if titleTextField.text != "" && detaileTextView.text != "" {
                    let name = Auth.auth().currentUser?.displayName
                    let storage = Storage.storage()
                    let textRef = storage.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(questionCount)").child("title")
                    let contentRef = storage.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(questionCount)").child("content")
                    let nameRef = storage.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(questionCount)").child("name")
                    let str = titleTextField.text!
                    let cont = detaileTextView.text!
                    textRef.putData(str.data(using: String.Encoding.utf32)!,
                                    metadata: nil) { metadata, error in
                                        print("yes")
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
                    if imageArray.count != 0 {
                        for i in 0 ..< imageArray.count {
                            print(i)
                            let postImage = imageArray.first
                            imageArray.removeFirst()
                            
                            let imageData = postImage?.jpegData(compressionQuality: 0.75)
                            let imageRef = storage.reference().child(Const.ImagePath).child(documentID + ".jpg").child("\(questionCount)").child("image\(i)")
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
             UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
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
        postImageViewController.questionCount = questionCount
        postImageViewController.titleText = titleTextField.text!
        postImageViewController.contentText = detaileTextView.text!
    }
    
    @IBAction func returnButton(_ sender: Any) {
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}




