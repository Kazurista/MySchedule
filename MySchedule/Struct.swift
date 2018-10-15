//
//  Struct.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2018/08/22.
//  Copyright © 2018 Kazunari Watanabe. All rights reserved.
//

import Foundation

struct GiveDatas {
    
    var giveData: String?
    var giveRow: Int?
    var text: String?
    
}

struct ToDo {
    
    var key = ""
    var dates = ""
    var todo = ""
    
    init(key: String = "", dates: String, todo: String) {
        self.key = key
        self.dates = dates
        self.todo = todo
    }
}
