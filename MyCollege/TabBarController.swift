//
//  TabBarController.swift
//  MyCollege
//
//  Created by Apple on 2020/07/20.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        タブバーの背景
        self.tabBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
//            ログインしていない時
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }
  

}
