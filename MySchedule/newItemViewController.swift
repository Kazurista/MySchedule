//
//  newItemViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2019/02/20.
//  Copyright © 2019 Kazunari Watanabe. All rights reserved.
//

import UIKit
import os.log

class newItemViewController: UIViewController {
    

    var delegate: ViewControllerDelegate! = nil
    var dateAndTodo: DateAndTodo?
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var todoTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var recieveDatas: GiveDatas?
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let recieveDatas = recieveDatas {
            
            dateTextField.text = recieveDatas.giveDate
            todoTextView.text = recieveDatas.text
        }
        
        datePicker = UIDatePicker()
        datePicker!.datePickerMode = .date
        datePicker!.addTarget(self, action: #selector(newItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(newItemViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
        
    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        
        let isPresentingInAddItemMode = presentingViewController is UINavigationController
        
        if isPresentingInAddItemMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The newItemViewController is not inside a navigation controller.")
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation.
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        if (delegate != nil) {
            let information1: String = dateTextField.text!
            let information2: String = todoTextView.text!
            
            delegate!.delegate(info1: information1, info2: information2, num: (recieveDatas?.giveRow!)!)
            self.navigationController?.popViewController(animated: true)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        dateAndTodo = DateAndTodo.init(date: dateTextField.text!, todo: todoTextField.text!)
        
    }

}
