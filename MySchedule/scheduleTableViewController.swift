//
//  scheduleTableViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2018/08/08.
//  Copyright © 2018 Kazunari Watanabe. All rights reserved.
//

import UIKit

class scheduleTableViewController: UITableViewController, ViewControllerDelegate {
    
//    memo
//    expected declaration
//    クラスに書いていいのは
//    プロパティ...変数の宣言
//    メソッド・・・関数の宣言
    
//    struct GiveDatas {
//        
//        var giveData: String?
//        var giveRow: Int?
//        var text: String?
//        
//    }
    
    var giveDatas: GiveDatas?
    
    
//    var giveData: String?
//    var giveRow: Int?
//    var text: String?
    
    struct DateAndTodo {
        
        var date: String
        var toDo: String
        
        init(date: Date, toDo: String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd/EE"

            self.date = formatter.string(from: date)  // ここでDate型の値であるdateをString型に変えてる
//            self.toDo = toDo                          // 下で決められたtoDoの値が代入される
            self.toDo = "Nothing"                 // 今回はどのCellにもWrite ToDo Listsが表示されるようにした
        }
        
    }
    
    var dts: [DateAndTodo] = []

//      ここで初期値を決めて、この初期値がStructの中のinit関数に渡される(dateはDate型、toDoはString型)
//    var dts: [DateAndTodo] = [DateAndTodo.init(date: Date(), toDo: ""),
//                              DateAndTodo.init(date: Date().addingTimeInterval(60*60*24), toDo: ""),
//                              DateAndTodo.init(date: Date().addingTimeInterval(60*60*24*2), toDo: ""),
//                              DateAndTodo.init(date: Date().addingTimeInterval(60*60*24*3), toDo: ""),
//                              DateAndTodo.init(date: Date().addingTimeInterval(60*60*24*4), toDo: "")
//                             ]

    override func viewDidLoad() {
        super.viewDidLoad()

        for i:Int in 0...100 {
            dts += [DateAndTodo.init(date: Date().addingTimeInterval(TimeInterval(60*60*24*i)), toDo: "Nothing")]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dts.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 見えなくなったCellを消して、それを使いまわしている。その使いまわしたいCellは自分で設定したscheduleTableViewCellだから、それをas？でチェックしている。
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? scheduleTableViewCell else {
            return UITableViewCell()
        }
        
        cell.dateLabel.text = dts[indexPath.row].date
        cell.todoLabel.text = dts[indexPath.row].toDo
        
//        giveData = cell.dateLabel.text
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 91   // セルの高さ
        return UITableViewAutomaticDimension   // 自動設定
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath) as? scheduleTableViewCell else {
//            fatalError("The dequeued cell is not an instance of scheduleTableViewCell.")
//        }
        let cell = tableView.cellForRow(at: indexPath) as? scheduleTableViewCell
        
//        giveData = cell?.dateLabel.text
//        giveRow = indexPath.row
//
//        text = cell?.todoLabel.text!
        
        giveDatas = GiveDatas.init(giveData: cell?.dateLabel.text, giveRow: indexPath.row, text: cell?.todoLabel.text)
        
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            
            let nav = segue.destination as! UINavigationController
            
            let vc = nav.topViewController as! ViewController
//            vc.recieveData = giveData!
//            vc.recieveRow = giveRow!
//
//            vc.recieveToDo = text!
//            vc.recieveDatas?.recieveData = GiveDatas.giveData!
//            vc.recieveDatas?.recieveRow = GiveDatas.giveRow!
//            vc.recieveDatas?.recieveToDo = GiveDatas.text!
            
            vc.recieveDatas = giveDatas!
            
            vc.delegate = self as ViewControllerDelegate
        }
    }
    
    func testDelegate(info: String, number: Int) {
        
        self.dts[number].toDo = info
        
//        userDefaults.set(dts, forKey: "todo")
//        userDefaults.synchronize()
        
        tableView.reloadData()
    }
    
    @IBAction func backSegue(segue: UIStoryboardSegue) {}
    
//    8/9/Thu
//    最初は下のように書いていたが、うまくいかなかった。
//    エラーメッセージはExpected declaration → クラス(構造体)の中に直接処理を書いちゃいけない。
//    対応として、Structの中でinitializerを定義し、その中に最初にやっておきたい処理を書いた(日付のformat)。
//    struct DateAndTodo{
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd"
//        var date = formatter.string(from: Date())
//        var toDo: String = "Write ToDo Lists"
//    }
//
//    配列の書き方
//
//    indexPath.row
//
//    Date().addingTimeInterval(60*60*24) //今日の日付から24時間後の日付が取得される　//UNIX time


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
