//
//  LoginViewController.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/14/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//
//  THIS FILE DEALS WITH LOGIN VIEW CONTROLLER, including Login Button and Button that goes to REGISTER VIEW CONTROLLER

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginEmailTextField.delegate = self
        self.loginPasswordTextField.delegate = self
        loginEmailTextField.tag = 0
        
        loginButton.backgroundColor = .clear
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.black.cgColor

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    /* Helper functions for textField and keyboard (adjusting textField position when keyboard show up) */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    func keyBoardWillShow(notification: NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    func keyBoardWillHide(notification: NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        var userInfo = notification.userInfo!

        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        
        scrollView.contentInset.bottom += changeInHeight
        
        scrollView.scrollIndicatorInsets.bottom += changeInHeight
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    @IBAction func loginButtonAction(_ sender: Any) {

        if self.loginEmailTextField.text == "" || self.loginPasswordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.loginEmailTextField.text!, password: self.loginPasswordTextField.text!) { (user, error) in
                
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainTabController")
                    self.present(vc!, animated: true, completion: nil)
                   
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    

}
