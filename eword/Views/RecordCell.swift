//
//  RecordCell.swift
//  eword
//
//  Created by Admin on 01/11/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var date: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
