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


class TabBarController: UITabBarController {
    
    @IBOutlet weak var homeTabBar: UITabBar!
    
   
    override func viewDidLoad() {
        homeTabBar.barTintColor = UIColor.white;
        
        self.homeTabBar.tintColor = UIColor.darkGray;
        
     
    }
}




