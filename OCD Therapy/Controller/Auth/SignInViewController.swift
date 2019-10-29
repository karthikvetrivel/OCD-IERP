//
//  SignInViewController.swift
//  
//
//  Created by Adrian Avram on 10/5/19.
//

import UIKit
import FirebaseAuth
import PopupDialog
import ChameleonFramework
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var gSignIn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInUIButton: UIButton!
    @IBOutlet weak var createAccountUIButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // MARK: Aesthetics Initialization
        initializeView()
        initializeButtons()
    }
    
    func initializeView() {
        let backgroundTop = UIColor(hexString: "#ff9a9e")!
        let backgroundBottom = UIColor(hexString: "fad0c4")!
        
        self.view.backgroundColor = UIColor(gradientStyle:UIGradientStyle.topToBottom, withFrame:self.view.frame, andColors:[backgroundTop, backgroundBottom])
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func initializeButtons() {
        emailTextField.styleInputTextField(imageName: "email")
        passwordTextField.styleInputTextField(imageName: "lock")
        signInUIButton.registerStyle()
        gSignIn.googlify()
        
        
        // Underline and make the string red
        let createAccountAttributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.foregroundColor: UIColor(red:0.89, green:0.33, blue:0.42, alpha:1.0), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let accountCreateString = NSMutableAttributedString(string: "Don't Have An Account? ")
        
        accountCreateString.append(NSAttributedString(string: "Create One", attributes: createAccountAttributes))

        // Set attributed text on a UILabel
        createAccountUIButton.setAttributedTitle(accountCreateString, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: Handle Sign In
    @IBAction func signInPressed(_ sender: Any) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!ParseUtility.verifyEmail(email: email)) {
            emailTextField.layer.borderColor = UIColor.red.cgColor
            emailTextField.layer.borderWidth = 1.0
            return
        } else {
            emailTextField.layer.borderColor = UIColor.lightGray.cgColor
            emailTextField.layer.borderWidth = 0.25
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!ParseUtility.verifyPassword(password: password)) {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            passwordTextField.layer.borderWidth = 1.0
            return
        } else {
            passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
            passwordTextField.layer.borderWidth = 0.25
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if (error != nil) {
                ErrorHandle.handleError(error!, viewController: self as UIViewController)
                return
            } else {
                self.routeToHomeScreen()
            }
        }
    }
    
    @IBAction func gSignInPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func routeToHomeScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: NavigationConstants.Storyboard.tabBarController) as! TabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
