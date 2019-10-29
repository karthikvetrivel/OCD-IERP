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
        
        // MARK: Aesthetics Initialization
        GIDSignIn.sharedInstance()?.presentingViewController = self
        gSignIn.googlify()
        
        let backgroundTop = UIColor(hexString: "#ff9a9e")!
        let backgroundBottom = UIColor(hexString: "fad0c4")!
        
        self.view.backgroundColor = UIColor(gradientStyle:UIGradientStyle.topToBottom, withFrame:self.view.frame, andColors:[backgroundTop, backgroundBottom])
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        // Initialize aesthetic changes
        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        
        emailTextField.addIcon(imageName: "email")
        passwordTextField.addIcon(imageName: "lock")
        
        emailTextField.roundTextFieldBorder(cornerRadius: emailTextField.frame.size.height / 2)
        passwordTextField.roundTextFieldBorder(cornerRadius: passwordTextField.frame.size.height / 2)
        
        emailTextField.addShadow(opacity: 0.3, radius: 7.0, offset: CGSize(width: 0, height: 6.0))
        passwordTextField.addShadow(opacity: 0.3, radius: 7.0, offset: CGSize(width: 0, height: 6.0))
        
        signInUIButton.registerStyle();
        
        // Underline and make the string red
        let createAccountAttributes: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.foregroundColor: UIColor(red:0.89, green:0.33, blue:0.42, alpha:1.0), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue ]
        let accountCreateString = NSMutableAttributedString(string: "Don't Have An Account? ")
        
        accountCreateString.append(NSAttributedString(string: "Create One", attributes: createAccountAttributes))

        // set attributed text on a UILabel
        createAccountUIButton.setAttributedTitle(accountCreateString, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: Sign In

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
