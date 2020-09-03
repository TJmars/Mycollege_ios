//
//  PostTableViewCell.swift
//  MyCollege
//
//  Created by Apple on 2020/07/23.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var facultyLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        

    }
    
//    PostDataの内容をセルに表示
    func setPostData(_ postData: PostData) {
        
        self.classNameLabel.text = "\(postData.className!)"
        self.facultyLabel.text = "\(postData.faculty!)"
        self.dayLabel.text = "\(postData.day!) \(postData.period!)"
    }
}
