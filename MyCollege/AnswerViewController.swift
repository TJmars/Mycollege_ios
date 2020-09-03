//
//  AnswerViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/08/19.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class AnswerViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detaileLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var AButton: UIButton!
    
    
    var documentID = ""
    var titleText = ""
    var contentText = ""
    var answerText = ""
    var childNum = 0
    
    var answerCount = 0
    
    var image: UIImage!
    var imageArray:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func imageButton(_ sender: Any) {
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
                  
                 
                  self.performSegue(withIdentifier: "tophoto", sender: nil)
              }
          }
          
          func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
              self.dismiss(animated: true, completion: nil)
          }
    
    
    @IBAction func answerButton(_ sender: Any) {
        if answerTextView.text != "" {
             let storage = Storage.storage()
                    let textRef = storage.reference().child(Const.QuestionPath).child(documentID + "QE").child("\(childNum)").child("answer\(answerCount - 2)")
                    let str = answerTextView.text!
                    textRef.putData(str.data(using: String.Encoding.utf32)!,
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
                            let imageRef = storage.reference().child(Const.ImagePath).child(documentID + ".jpg").child("\(childNum)").child("answer\(answerCount - 2)").child("image\(i)")
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
            UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
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
        postImageViewController.documentID = documentID
        postImageViewController.imageArray = imageArray
        postImageViewController.childNum = childNum
        postImageViewController.titleText = titleText
        postImageViewController.contentText = contentText
        postImageViewController.answerText = answerTextView.text!
        postImageViewController.answerCount = answerCount
        
    }
    
    @IBAction func returnButton(_ sender: Any) {
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
