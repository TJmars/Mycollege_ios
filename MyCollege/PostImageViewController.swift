//
//  PostImageViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/08/08.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class PostImageViewController: UIViewController {
    
    var image: UIImage!
    var documentID = ""
    var postData:PostData! = nil
    var imageNumData = 0
    var questionCount = 0
    var titleText = ""
    var contentText = ""
    var childNum = 0
    var answerText = ""
    var answerCount = 0
    
//    0の時、questionViewControllerから、1の時answerViewControllerから
    var segueCount = 0
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    var imageArray:[UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imageView.image = image
        
        
        
    }
    
    
    @IBAction func registerButton(_ sender: Any) {
        
        let originalWidth:Float = Float(image.size.width)
        let originalHeight:Float = Float(image.size.height)
        
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
        
        
//       let resizedImage = pickerImage?.resized(withPercentage: 0.1)
        let resizeImage = image?.resized(withPercentage: CGFloat(scale))
      image = resizeImage
        
        imageArray.append(image)
        
        if segueCount == 0 {
            performSegue(withIdentifier: "returnQ", sender: nil)

        } else {
            performSegue(withIdentifier: "returnA", sender: nil)
        }
//        if Auth.auth().currentUser != nil {
//
//            //            let postsRef = Firestore.firestore().collection(Const.PostPath).document(documentID)
//            //        画像をJPEG形式に変換
//            let imageData = image.jpegData(compressionQuality: 0.75)
//            //        画像の保存場所を定義
//            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(documentID + ".jpg").child("\(imageNumData)")
//            print(imageNumData)
//
//            //        データをアップロード
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//            imageRef.putData(imageData!, metadata: metadata) { (metadata, error) in
//                if error != nil {
//                    print(error!)
//                    UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
//                    return
//                }
//                UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
//
//                postsRef.updateData([
//                    "imageNum": self.imageNumData + 1
//
//                ]) { err in
//                    if let err = err {
//                        print("err:\(err)")
//                    } else {
//                        print("ok")
//
//                    }
//                }
//
//            }
//
//        }
    }
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnQ" {
            let questionViewController:QuestionViewController = segue.destination as! QuestionViewController
                   questionViewController.imageArray = imageArray
                   questionViewController.documentID = documentID
                   questionViewController.questionCount = questionCount
                   questionViewController.titleText = titleText
                   questionViewController.detaileText = contentText
        } else {
            let answerViewController:AnswerViewController = segue.destination as! AnswerViewController
            answerViewController.imageArray = imageArray
            answerViewController.documentID = documentID
            answerViewController.childNum = childNum
            answerViewController.titleText = titleText
            answerViewController.contentText = contentText
            answerViewController.answerCount = answerCount
            answerViewController.answerText = answerText
            
        }
    }
}

extension UIImage {
    //データサイズを変更する
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
