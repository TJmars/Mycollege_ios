//
//  ModalViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/08/28.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import RealmSwift

class ModalViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let realm = try! Realm()
    var loginApp:LoginApp!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var documentID = ""
    var childNum = 0
    var answerCount = 0
    var imageCount = 0
    var indexNum = 0
    var checkSegue = 0
    var imageArray:[UIImage] = []
    var uuidTime = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
        }
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
        let storage = Storage.storage()
        if checkSegue == 0 {
            let storageReference = storage.reference().child(self.loginApp.collegeNameData).child(Const.ImagePath).child(documentID + ".jpg").child("\(uuidTime)")
            storageReference.listAll { (result, error) in
                if let error = error {
                    // ...
                }
                
                
                for (count, item) in result.items.enumerated() {
                    
                    let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.ImagePath).child(self.documentID + ".jpg").child("\(self.uuidTime)").child("image\(count)")
                    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        
                        if let error = error {
                            print("エラー\(error)")
                        } else {
                            let image = UIImage(data: data!)
                            self.imageArray.append(image!)
                            print(self.imageArray)
                            self.collectionView.reloadData()
                        }
                    }
                   
                }
                
                
            }
        } else {
            let storageReference = storage.reference().child(self.loginApp.collegeNameData).child(Const.ImagePath).child(documentID + ".jpg").child("\(uuidTime)").child("answer\(indexNum)")
            storageReference.listAll { (result, error) in
                if let error = error {
                    // ...
                }
                
                for (count, item) in result.items.enumerated() {
                    
                    let imageRef = storage.reference().child(self.loginApp.collegeNameData).child(Const.ImagePath).child(self.documentID + ".jpg").child("\(self.uuidTime)").child("answer\(self.indexNum)").child("image\(count)")
                    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        
                        if let error = error {
                            print("エラー\(error)")
                        } else {
                            let image = UIImage(data: data!)
                            self.imageArray.append(image!)
                            print(self.imageArray)
                            self.collectionView.reloadData()
                        }
                    }
                    
                }
                
                
            }
            
        }
        
        //       CollectionViewのレイアウト
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
    }
    
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        let imageView = UIImageView()
        
        
        
        imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)
        imageView.contentMode = .scaleAspectFit
        cell.addSubview(imageView)
        
        
            imageView.image = imageArray[indexPath.row]
            
       
        
        return cell
    }
    
    //   セルのレイアウトを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.layer.bounds.width
        let height = self.collectionView.layer.bounds.height / 1.5
        
        
        
        return CGSize(width: width, height: height)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        for i in 0 ..< imageArray.count {
            UIImageWriteToSavedPhotosAlbum(imageArray[i], self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    
    // 保存結果をアラートで表示
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {

           var title = "保存完了"
           var message = "カメラロールに保存しました"

           if error != nil {
               title = "エラー"
               message = "保存に失敗しました"
           }

           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

           // OKボタンを追加
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

           // UIAlertController を表示
           self.present(alert, animated: true, completion: nil)
       }

    
    
}
