//
//  EvaViewController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/31.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

class EvaViewController: UIViewController {
    
    //    Realm
    let realm = try! Realm()
    var task: Task!
    
    var gradeValue = 0
    var levelValue = 0
    var evaValue = 0
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var Ebutton: UIButton!
    
    
    //    Firebaseのリスナー
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
        
        // Do any additional setup after loading the view.
        classNameLabel.text = task.className
        Ebutton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
        Ebutton.layer.cornerRadius = 10.0
        Ebutton.clipsToBounds = true
        
    }
    
    
    @IBAction func postButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            //            ログイン済
            if listener == nil {
                
                // listener未登録なら、登録してスナップショットを受信する
                let postsRef = Firestore.firestore().collection(Const.PostPath).document(task.documentID)
                switch gradeValue {
                case 0:
                    postsRef.updateData([
                        "gradeS": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                    case 1:
                    postsRef.updateData([
                        "gradeA": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                    case 2:
                    postsRef.updateData([
                        "gradeB": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                    case 3:
                    postsRef.updateData([
                        "gradeC": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                    case 4:
                    postsRef.updateData([
                        "gradeD": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                default:
                    postsRef.updateData([
                        "gradeS": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                }
                
                switch levelValue {
                case 0:
                postsRef.updateData([
                    "level4": +1
                ]) { err in
                    if let err = err {
                        print("err:\(err)")
                    } else {
                        print("ok")
                    }
                }
                    case 0:
                    postsRef.updateData([
                        "level3": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                    case 0:
                    postsRef.updateData([
                        "level2": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                    case 0:
                    postsRef.updateData([
                        "level1": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                default:
                    postsRef.updateData([
                        "level1": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }

                }
                
                switch evaValue {
                case 0:
                postsRef.updateData([
                    "evaA": +1
                ]) { err in
                    if let err = err {
                        print("err:\(err)")
                    } else {
                        print("ok")
                    }
                }
                    case 1:
                    postsRef.updateData([
                        "evaB": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                    case 2:
                    postsRef.updateData([
                        "evaC": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                    case 3:
                    postsRef.updateData([
                        "evaD": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                default:
                    postsRef.updateData([
                        "evaA": +1
                    ]) { err in
                        if let err = err {
                            print("err:\(err)")
                        } else {
                            print("ok")
                        }
                    }
                }
            }
            
        } else {
            //            ログイン未
            if listener != nil {
                listener.remove()
                listener = nil
                
            }
        }
    }
    
    
    @IBAction func gradeSegument(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gradeValue = 0
        case 1:
            gradeValue = 1
        case 2:
            gradeValue = 2
        case 3:
            gradeValue = 3
        case 4:
            gradeValue = 4
        default:
            gradeValue = 0
        }
    }
    
    @IBAction func levelSegument(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            levelValue = 0
        case 1:
            levelValue = 1
        case 2:
            levelValue = 2
        case 3:
            levelValue = 3
        default:
            levelValue = 0
        }
    }
    
    @IBAction func evaSegument(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            evaValue = 0
        case 1:
            evaValue = 1
        case 2:
            evaValue = 2
        case 3:
            evaValue = 3
        default:
            evaValue = 0
        }
    }
    
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
