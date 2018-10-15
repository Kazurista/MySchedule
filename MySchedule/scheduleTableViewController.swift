//
//  scheduleTableViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2018/08/08.
//  Copyright © 2018 Kazunari Watanabe. All rights reserved.
//

import UIKit
import Firebase

class scheduleTableViewController: UITableViewController, ViewControllerDelegate {
    
//    memo
//    expected declaration
//    クラスに書いていいのは
//    プロパティ...変数の宣言
//    メソッド・・・関数の宣言
    
    var giveDatas: GiveDatas?  // Struct.swiftで定義されているGiveData型を使って新たな変数を定義
    
    struct DateAndTodo {   // 日付とtoDoの文字列を変数にもつ構造体
        
        var date: String
        var toDo: String
        
        init(date: Date, toDo: String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd/EE"

            self.date = formatter.string(from: date)  // ここでDate型の値であるdateをString型に変えてる
//            self.toDo = toDo                          // 下で決められたtoDoの値が代入される
            self.toDo = "Nothing"                 // 今回はどのCellにも"Nothing"が表示されるようにした
        }
        
    }
    
    var dts: [DateAndTodo] = []   // 上で定義したDateAndTodo型の構造体を空の配列に代入
    
    var ref:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        for i:Int in 0...100 {
            dts += [DateAndTodo.init(date: Date().addingTimeInterval(TimeInterval(60*60*24*i)), toDo: "Nothing")]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.object(forKey: "check") != nil {
            
        }else{
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
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
        
        let cell = tableView.cellForRow(at: indexPath) as? scheduleTableViewCell
        
        giveDatas = GiveDatas.init(giveData: cell?.dateLabel.text, giveRow: indexPath.row, text: cell?.todoLabel.text)
        
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            
            let nav = segue.destination as! UINavigationController
            
            let vc = nav.topViewController as! ViewController
            
            vc.recieveDatas = giveDatas!
            
            vc.delegate = self as ViewControllerDelegate
        }
    }
    
    func testDelegate(info: String, number: Int) {
        
        self.dts[number].toDo = info
        
        tableView.reloadData()
        
        // add()関数の中身をここに書いた。
        //VCから日付データとtoDoデータを受け取り、それをサーバーへと保存する
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let dateData = self.dts[number].date
        let todoData = info
        
        let user: NSDictionary = ["dateData" : dateData, "todoData" : todoData]
        
        ref.child("present").childByAutoId().setValue(user)
    }
    
    @IBAction func backSegue(segue: UIStoryboardSegue) {
        
    }
    
    
    func loadAll(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://myschedule-28968.firebaseio.com/").child("present")
        
        ref.observeSingleEvent(of: .childAdded, with: { snapshot in
            
        })
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        let alertViewController = UIAlertController(title: "Sign out", message: "Would you like to sign out?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Sign out", style: .default, handler: { action in
            try! Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "check")
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated: true, completion: nil)
    }
    
    
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


}
