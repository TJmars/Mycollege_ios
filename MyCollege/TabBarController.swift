//
//  TabBarController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/20.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class TabBarController: UITabBarController {
    
    let realm = try! Realm()
    var loginApp: LoginApp!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        タブバーの背景
        self.tabBar.barTintColor = UIColor(red: 0.5, green: 0.8, blue: 0.8, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        if let obj = realm.objects(LoginApp.self).first {
            loginApp = obj
            
        } else {
            loginApp = LoginApp()
            
        }
//        currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil || loginApp.deleateApp == 0 {
//            ログインしていない時
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
  

}
