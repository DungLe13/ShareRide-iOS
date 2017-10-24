//
//  RegisterViewController.swift
//  ShareRide
//
//  Created by Le, Dung Tien on 4/14/17.
//  Copyright © 2017 Dung Le. All rights reserved.
//  THIS FILE IS REGISTER VIEW CONTROLLER, inlcuding storing users' data on database, register button, and lots of text fields for user to complete their info

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reEnterPasswordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var cancelRegistratioButtonPressed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.reEnterPasswordTextField.delegate = self
        emailTextField.tag = 0
        
        registerButton.backgroundColor = .clear
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.black.cgColor

        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Helper functions to textField and keyboard (same as in login)
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
        // 1
        var userInfo = notification.userInfo!
        // 3
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        
        scrollView.contentInset.bottom += changeInHeight
        
        scrollView.scrollIndicatorInsets.bottom += changeInHeight
        
    }
    
    
    @IBAction func cancelRegistrationAction(_ sender: Any) {
        cancelRegistratioButtonPressed = true
    }
        
    
    @IBAction func registerButtonAction(_ sender: Any) {
        //in case the user presses register before while the fields are still empty
    
        if cancelRegistratioButtonPressed {
            self.performSegue(withIdentifier: "cancelRegistrationSegue", sender: nil)
        }
        else if (emailTextField.text == "" || firstNameTextField.text == "" || lastNameTextField.text == "" || passwordTextField.text == "" || reEnterPasswordTextField.text == "") {
            let alertController = UIAlertController(title: "Error", message: "Please fill out every field", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        } else if (self.emailTextField.text!.range(of:"@middlebury.edu") == nil){
            let emailAlertController = UIAlertController(title: "Error", message: "Please enter a Middlebury email", preferredStyle: .alert)
            
            let emailDefaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            emailAlertController.addAction(emailDefaultAction)
            
            self.present(emailAlertController, animated: true, completion: nil)
   
        } else if (passwordTextField.text != reEnterPasswordTextField.text){
            let passwordMatchAlertController = UIAlertController(title: "Error", message: "Please ensure that the passwords match", preferredStyle: .alert)
            
            let passwordMatchDefaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            passwordMatchAlertController.addAction(passwordMatchDefaultAction)
            
            self.present(passwordMatchAlertController, animated: true, completion: nil)

        } else {

            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in

                print(error as Any)
                if error == nil {
                    let userData = ["firstName": self.firstNameTextField.text, "lastName": self.lastNameTextField.text]
                    let ref = FIRDatabase.database().reference()
                    ref.child("users").child(user!.uid).setValue(userData)

                    print("You have successfully signed up")

                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "mainTabController")
                    self.present(vc!, animated: true, completion: nil)
 
                
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
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
