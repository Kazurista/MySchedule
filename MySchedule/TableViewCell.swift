//
//  TableViewCell.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2019/01/25.
//  Copyright © 2019 Kazunari Watanabe. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLable: UILabel!
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
