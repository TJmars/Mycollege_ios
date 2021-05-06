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
   
    var titleText = ""
    var contentText = ""
    var childNum = 0
    var answerText = ""
    var answerCount = 0
    var uuidTime = ""
    
//    0の時、questionViewControllerから、1の時answerViewControllerから
    var segueCount = 0
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var PButton: UIButton!
    
    var imageArray:[UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        imageView.image = image
        
        PButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        PButton.layer.cornerRadius = 10
        PButton.clipsToBounds = true
        
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
            let questionViewController = self.presentingViewController?.presentingViewController as! QuestionViewController
           questionViewController.imageArray = imageArray

            questionViewController.collectionView.reloadData()
           self.dismiss(animated: true, completion: nil)

        } else {
            let answerViewController = self.presentingViewController?.presentingViewController as! AnswerViewController
            answerViewController.imageArray = imageArray

            answerViewController.collectionView.reloadData()
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }

    }
    
    @IBAction func returnButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
