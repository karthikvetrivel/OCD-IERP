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
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpUIButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        fullNameTextField.backgroundColor = .white
        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        confirmPasswordTextField.backgroundColor = .white
        
        fullNameTextField.roundBorder()
        emailTextField.roundBorder()
        passwordTextField.roundBorder()
        confirmPasswordTextField.roundBorder()
        
        fullNameTextField.addShadow(opacity: 0.3, radius: 7.0, offset: CGSize(width: 0, height: 6.0))
        emailTextField.addShadow(opacity: 0.3, radius: 7.0, offset: CGSize(width: 0, height: 6.0))
        passwordTextField.addShadow(opacity: 0.3, radius: 7.0, offset: CGSize(width: 0, height: 6.0))
        confirmPasswordTextField.addShadow(opacity: 0.3, radius: 7.0, offset: CGSize(width: 0, height: 6.0))
        
        signUpUIButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        signUpUIButton.backgroundColor = UIColor(red:0.89, green:0.33, blue:0.42, alpha:1.0)
        signUpUIButton.layer.cornerRadius = 10

        signUpUIButton.addShadow(opacity: 0.7, radius: 5.0, offset: CGSize(width: 0, height: 5.0), color: UIColor(red:0.89, green:0.33, blue:0.42, alpha:1.0).cgColor)
        
        let createAccountAttributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.foregroundColor: UIColor(red:0.89, green:0.33, blue:0.42, alpha:1.0), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let accountCreateString = NSMutableAttributedString(string: "Already Have An Account? ")
        accountCreateString.append(NSAttributedString(string: "Sign In", attributes: createAccountAttributes))

        // set attributed text on a UILabel
        signInButton.setAttributedTitle(accountCreateString, for: .normal)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    @IBAction func signInUIButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpUIButtonPressed(_ sender: Any) {
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

                dataBase.collection("users").document(result!.user.uid).setData(["name": fullName, "email": email]) {
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
