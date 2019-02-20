//
//  mainViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2019/01/25.
//  Copyright © 2019 Kazunari Watanabe. All rights reserved.
//

import UIKit
import Firebase

class mainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    struct DateAndTodo {     // 日付とtodoのデータを格納する構造体
        
        var date: String?
        var todo: String?
        
        init(date: Date, todo: String) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/EE"   // Date()をStringへ
            
            self.date = formatter.string(from: date)
            self.todo = todo
        }
        
    }
    
    var dts: [DateAndTodo] = []
    var givedatas: GiveDatas?
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        for i: Int in 0...10 {
            dts += [DateAndTodo.init(date: Date().addingTimeInterval(TimeInterval(60*60*24*i)), todo: "nothing")]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let _ = Auth.auth().currentUser?.uid else {
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
            return
        }
        loadAll()
//        delete_data()
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
        
        // 見えなくなったCellを消して、それを使いまわしている。その使いまわしたいCellは自分で設定したscheduleTableViewCellだから、それをas？でチェックしている。
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.dateLable.text = dts[indexPath.row].date
        cell.todoLabel.text = dts[indexPath.row].todo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 86
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? TableViewCell
        
        givedatas = GiveDatas.init(giveDate: cell?.dateLable.text, giveRow: indexPath.row, text: cell?.todoLabel.text)
        
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toViewController" {
            
            let nav = segue.destination as! UINavigationController
            
            let vc = nav.topViewController as! ViewController
            
            vc.recieveDatas = givedatas!
            
            vc.delegate = self as ViewControllerDelegate
        }
    }
    
    func testDelegate(info: String, number: Int) {
        
        self.dts[number].todo = info
        
        tableView.reloadData()
        
        delete_data()
    }
    
    func delete_data() {
        
        var defaultStore: Firestore!
        defaultStore = Firestore.firestore()
        
        let userid = Auth.auth().currentUser!.uid
        
        defaultStore.collection(userid).document().delete()
    }
    
    func add_data_to_firestore() {
        
        var defaultStore: Firestore!
        defaultStore = Firestore.firestore()
        
        let userid = Auth.auth().currentUser!.uid
        
        for i: Int in 0...dts.count-1 {
            
            defaultStore.collection(userid).addDocument(data: [
                
                "date": self.dts[i].date!,
                "todo": self.dts[i].todo!,
                "cell_num": i
            ])
            { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfullly written!")
                }
            }
        }
    }
    
    
    @IBAction func backSegue(segue: UIStoryboardSegue) {
        
    }
    
    func loadAll(){
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var defaultStore: Firestore!
        defaultStore = Firestore.firestore()
        
        let userid = Auth.auth().currentUser!.uid
        
        defaultStore.collection(userid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let date = document.data()["date"]! as? String
                    let todo = document.data()["todo"]! as? String
                    let num = document.data()["cell_num"]! as? Int
                    let df = DateFormatter()
                    df.dateFormat = "MM/dd/EE"
                    if df.date(from: date!) != nil {
                        self.dts[num!].date = date
                        self.dts[num!].todo = todo
                    } else {
                        print("error")
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        let alertViewController = UIAlertController(title: "Sign out", message: "Would you like to sign out?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Sign out", style: .default, handler: { action in
            try! Auth.auth().signOut()
//            UserDefaults.standard.removeObject(forKey: "check")
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "login")
            self.present(loginViewController!, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
        
        present(alertViewController, animated: true, completion: nil)
        
        add_data_to_firestore()
    }

}
