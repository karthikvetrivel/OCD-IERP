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

class MoreViewController: UIViewController, UITextViewDelegate {
    
// Buttons
    @IBOutlet weak var exposureTabItem: UITabBarItem!
    @IBOutlet weak var addFloatingButton: UIButton!
    
// Primary Textfield
    @IBOutlet weak var exposureTextView: UITextView!
    
    
    override func viewDidLoad() {
        exposureTextView.delegate = self;
        floatingButton()
        configTextView()
    }
    

    
    
    func floatingButton() {
        addFloatingButton.layer.cornerRadius = 30;
    }
    
    func configTextView() {
        exposureTextView.text = "Tell us about it!"
        exposureTextView.textColor =  UIColor.lightGray
        
        exposureTextView.layer.cornerRadius = 10;
        exposureTextView.backgroundColor = UIColor.flatWhite
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
        
        
    }
    
    
    
    
    
    
    
    
    
}




