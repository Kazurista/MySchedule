//
//  ViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2018/08/08.
//  Copyright © 2018 Kazunari Watanabe. All rights reserved.
//

import UIKit

protocol ViewControllerDelegate {
    func testDelegate(info: String, number: Int)
}

class ViewController: UIViewController {
    
    var delegate: ViewControllerDelegate! = nil
    
    @IBOutlet weak var DateLabel: UILabel!
    
    var recieveDatas: GiveDatas?
    
    @IBOutlet weak var writeSomething: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateLabel.text = recieveDatas?.giveData
        writeSomething.text = recieveDatas?.text
        
        writeSomething.layer.borderColor = UIColor.lightGray.cgColor
        writeSomething.layer.borderWidth = 0.7
        writeSomething.layer.cornerRadius = 10.0
        writeSomething.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (delegate != nil) {
            let information: String = writeSomething.text!
            
            delegate!.testDelegate(info: information, number: (recieveDatas?.giveRow!)!)
            self.navigationController?.popViewController(animated: true)
            
            self.dismiss(animated: true, completion: nil)
        }

    }
    
    
}

