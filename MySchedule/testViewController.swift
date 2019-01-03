//
//  testViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2018/10/22.
//  Copyright © 2018 Kazunari Watanabe. All rights reserved.
//

import UIKit

class testViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var giveDatas: GiveDatas?
    
    struct DateAndTodo {
        var date: String
        var toDo: String
        
        init(date: Date, toDo: String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd/EE"
            
            self.date = formatter.string(from: date)
            self.toDo = "Nothing"
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var dts: [DateAndTodo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for i:Int in 0...100 {
            dts += [DateAndTodo.init(date: Date().addingTimeInterval(TimeInterval(60*60*24*i)), toDo: "Nothing")]
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? scheduleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.dateLabel.text = dts[indexPath.row].date
        cell.todoLabel.text = dts[indexPath.row].toDo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 91   // セルの高さ
        return UITableViewAutomaticDimension   // 自動設定
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
