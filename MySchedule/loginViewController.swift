//
//  loginViewController.swift
//  MySchedule
//
//  Created by Kazunari Watanabe on 2018/09/28.
//  Copyright © 2018 Kazunari Watanabe. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTextField.isSecureTextEntry = true
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if emailTextField.text == nil || passwordTextField.text == nil {
            
            let alertViewController = UIAlertController(title: "Empty", message: "Please write your empty items", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewController.addAction(okAction)
            
            present(alertViewController, animated: true, completion: nil)
            
        }else{
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                
                guard (authResult?.user) != nil else {return}
                
                if error == nil {
                    
                    UserDefaults.standard.set("check", forKey: "check")
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    
                    let alertViewController = UIAlertController(title: "Empty", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertViewController.addAction(okAction)
                    
                    self.present(alertViewController, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        
        if self.emailTextField.text == nil || self.passwordTextField.text == nil {
            
            let alertViewController = UIAlertController(title: "Empty", message: "Please write your empty items", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertViewController.addAction(okAction)
            
            self.present(alertViewController, animated: true, completion: nil)
            
        }else{
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    UserDefaults.standard.set("check", forKey: "check")
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    
                    let alertViewController = UIAlertController(title: "Empty", message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertViewController.addAction(okAction)
                    
                    self.present(alertViewController, animated: true, completion: nil)
                }
                
            }
          
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
