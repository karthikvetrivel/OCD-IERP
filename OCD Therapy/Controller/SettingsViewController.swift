//
//  HomeViewController.swift
//  OCD Therapy
//
//  Created by Adrian Avram on 10/5/19.
//  Copyright © 2019 KarsickKeep. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import ChameleonFramework
import AIFlatSwitch

class SettingsViewController: UIViewController {
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var notificationSwitch: AIFlatSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLogOutButton()
    }
    
    func styleLogOutButton() {
        logOutButton.leftImage(image: UIImage(named: "logout.png")!, renderMode: UIImage.RenderingMode.alwaysOriginal)
        logOutButton.backgroundColor = .white
        logOutButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
        logOutButton.roundButtonBorder(cornerRadius: 10.0)
        logOutButton.addShadow(opacity: 0.2)
    }
    @IBAction func logOutPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: NavigationConstants.Storyboard.signInViewController) as! SignInViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = nextViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}



