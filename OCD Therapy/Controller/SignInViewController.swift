//
//  SignInViewController.swift
//  
//
//  Created by Adrian Avram on 10/5/19.
//

import UIKit
import FirebaseAuth
import PopupDialog

@available(iOS 13.0, *)
class SignInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signInUIButton: UIButton!
    @IBOutlet weak var createAccountUIButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        
        emailTextField.addIcon(imageName: "email")
        passwordTextField.addIcon(imageName: "lock")
        
        emailTextField.roundBorder()
        passwordTextField.roundBorder()
        
        emailTextField.addShadow(radius: 7.0, offset: CGSize(width: 0, height: 6.0))
        passwordTextField.addShadow(radius: 7.0, offset: CGSize(width: 0, height: 6.0))
        
        signInUIButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        signInUIButton.backgroundColor = UIColor(red:0.89, green:0.33, blue:0.42, alpha:1.0)
        signInUIButton.layer.cornerRadius = 5
        
        signInUIButton.addShadow(opacity: 0.7, radius: 5.0, offset: CGSize(width: 0, height: 5.0), color: UIColor(red:0.89, green:0.33, blue:0.42, alpha:1.0).cgColor)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
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
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: NavigationConstants.Storyboard.homeViewController) as! HomeViewController
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
    }
}
