//
//  PostData.swift
//  MyCollege
//
//  Created by Apple on 2020/07/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class PostData: NSObject {
    var id: String
    var className: String?
    var day: String?
    var period: String?
    var faculty: String?
    var teacher: String?
    var classRoom: String?
    var evaRate: String?
    var career: String?
    var season: String?
    var member: Int?
    var gradeS: Int?
    var gradeA: Int?
    var gradeB: Int?
    var gradeC: Int?
    var gradeD: Int?
    var level4: Int?
    var level3: Int?
    var level2: Int?
    var level1: Int?
    var evaA: Int?
    var evaB: Int?
    var evaC: Int?
    var evaD: Int?
    var imageNum: Int?
    
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        self.className = postDic["className"] as? String
        self.day = postDic["day"] as? String
        self.period = postDic["period"] as? String
        self.faculty = postDic["faculty"] as? String
        self.teacher = postDic["teacher"] as? String
        self.classRoom = postDic["classRoom"] as? String
        self.evaRate = postDic["evaRate"] as? String
        self.career = postDic["career"] as? String
        self.season = postDic["season"] as? String
        self.member = postDic["member"] as? Int
        self.gradeS = postDic["gradeS"] as? Int
        self.gradeA = postDic["gradeA"] as? Int
        self.gradeB = postDic["gradeB"] as? Int
        self.gradeC = postDic["gradeC"] as? Int
        self.gradeD = postDic["gradeD"] as? Int
        self.level4 = postDic["level4"] as? Int
        self.level3 = postDic["level3"] as? Int
        self.level2 = postDic["level2"] as? Int
        self.level1 = postDic["level1"] as? Int
        self.evaA = postDic["evaA"] as? Int
        self.evaB = postDic["evaB"] as? Int
        self.evaC = postDic["evaC"] as? Int
        self.evaD = postDic["evaD"] as? Int
        
        self.imageNum = postDic["imageNum"] as? Int
        
        
       
    }
}


