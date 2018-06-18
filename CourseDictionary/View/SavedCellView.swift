//
//  SavedCellView.swift
//  CourseDictionary
//
//  Created by Yoli Meydan on 6/15/18.
//  Copyright © 2018 Yoli Meydan. All rights reserved.
//

import UIKit

class SavedCellView: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        containerView.layer.cornerRadius = 11
        containerView.layer.borderColor = UIColor.DarkBlue.cgColor
        containerView.layer.borderWidth = 1
        containerView.backgroundColor = UIColor.clear
        
        letterLabel.textColor = UIColor.DarkBlue
        numberLabel.textColor = UIColor.DarkBlue
        ratingLabel.textColor = UIColor.ThemeGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
