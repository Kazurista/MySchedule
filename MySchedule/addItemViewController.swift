//
//  addItemViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2019/02/15.
//  Copyright © 2019 Kazunari Watanabe. All rights reserved.
//

import UIKit

class addItemViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!

    private var datePicker: UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        datePicker!.datePickerMode = .date
        datePicker!.addTarget(self, action: #selector(addItemViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addItemViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
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
    

}
