//
//  scheduleViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2018/10/22.
//  Copyright © 2018 Kazunari Watanabe. All rights reserved.
//

import UIKit
import Firebase

class scheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    var dts: [DateAndTodo] = []
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var myScheduleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? scheduleTableViewCell
        
        giveDatas = GiveDatas.init(giveData: cell?.dateLabel.text, giveRow: indexPath.row, text: cell?.todoLabel.text)
        
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            
            let nav = segue.destination as! UINavigationController
            
            let vc = nav.topViewController as! ViewController
            
            vc.recieveDatas = giveDatas!
            
            vc.delegate = self as! ViewControllerDelegate
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
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
        
        present(alertViewController, animated: true, completion: nil)
        
    }
}
