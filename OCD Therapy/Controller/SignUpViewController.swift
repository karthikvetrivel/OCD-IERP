//
//  SignUpViewController.swift
//  OCD Therapy
//
//  Created by Adrian Avram on 10/5/19.
//  Copyright © 2019 KarsickKeep. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!ParseUtility.verifyEmail(email: email)) {
            // TODO: Prompt a proper email must be entered
            return
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!ParseUtility.verifyPassword(password: password)) {
            // TODO: A proper password must be entered. Display requirements
            return
        }
        
        let fullName = fullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (fullName.isEmpty) {
            // TODO: Display error message
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                ErrorHandle.handleError(error!, viewController: self as UIViewController)
            } else {
                let dataBase = Firestore.firestore()

                dataBase.collection("users").addDocument(data: ["name": fullName, "email": email, "uid": result!.user.uid]) {
                    (error) in
                    
                    if (error != nil) {
                        // TODO: Error message
                    }
                }
                
                self.homeScreen()
            }
        }
    }
    
    @IBAction func emailTextFieldEditEnded(_ sender: Any) {
        let email = emailTextField.text!
        if (!ParseUtility.verifyEmail(email: email) && !email.isEmpty) {
            emailTextField.layer.borderColor = UIColor.red.cgColor
            emailTextField.layer.borderWidth = 1.0
        } else {
            emailTextField.layer.borderColor = UIColor.lightGray.cgColor
            emailTextField.layer.borderWidth = 0.25
        }
    }
    
    @IBAction func confirmPasswordEditChanged(_ sender: Any) {
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        
        if (password != confirmPassword) {
            confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
            confirmPasswordTextField.layer.borderWidth = 1.0
        } else {
            confirmPasswordTextField.layer.borderColor = UIColor.lightGray.cgColor
            confirmPasswordTextField.layer.borderWidth = 0.25
        }
    }
    
    func homeScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: NavigationConstants.Storyboard.homeViewController) as! HomeViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
}
