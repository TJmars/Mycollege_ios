//
//  QuestionTableViewCell.swift
//  MyCollege
//
//  Created by Apple on 2020/08/25.
//  Copyright © 2020 ryotaro.tsuji. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imagesButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.backgroundColor = .clear
        contentLabel.layer.cornerRadius = 10.0
        contentLabel.clipsToBounds = true
        contentLabel.numberOfLines = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
   
    
    
}
