//
//  scheduleTableViewCell.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2018/08/08.
//  Copyright © 2018 Kazunari Watanabe. All rights reserved.
//

import UIKit

class scheduleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
