//
//  Task.swift
//  MyCollege
//
//  Created by Apple on 2020/07/26.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import RealmSwift

class Task: Object {

    @objc dynamic var id = 0
    @objc dynamic var className = ""
    @objc dynamic var season = ""
    @objc dynamic var day = ""
    @objc dynamic var period = ""
    @objc dynamic var cellPoint = 0
    @objc dynamic var faculty = ""
    @objc dynamic var documentID = ""
    @objc dynamic var teacher = ""
    @objc dynamic var classRoom = ""
    @objc dynamic var evaRate = ""
    @objc dynamic var career = ""
    @objc dynamic var member = 0
    @objc dynamic var gradeS = 0
    @objc dynamic var gradeA = 0
    @objc dynamic var gradeB = 0
    @objc dynamic var gradeC = 0
    @objc dynamic var gradeD = 0
    @objc dynamic var level4 = 0
    @objc dynamic var level3 = 0
    @objc dynamic var level2 = 0
    @objc dynamic var level1 = 0
    @objc dynamic var evaA = 0
    @objc dynamic var evaB = 0
    @objc dynamic var evaC = 0
    @objc dynamic var evaD = 0
    @objc dynamic var registerCount = 0
    @objc dynamic var time = 0
    @objc dynamic var colorNum = 0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
   
    
}

class AppDetail: Object {
    @objc dynamic var colorNum = 0
    
    @objc dynamic var count1 = 0
    @objc dynamic var count2 = 0
    @objc dynamic var count3 = 0
    @objc dynamic var count4 = 0
    @objc dynamic var count5 = 0
    
    @objc dynamic var apperQCount = 0
    
}

class LoginApp: Object {
    @objc dynamic var deleateApp = 0
    @objc dynamic var facultyData = ""
    @objc dynamic var collegeNameData = ""
}
