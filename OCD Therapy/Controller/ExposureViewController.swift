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
import PopupDialog

class ExposureViewController: UIViewController, UITextViewDelegate {
    
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
        addFloatingButton.layer.masksToBounds = true;
    }
    
    func configTextView() {
        exposureTextView.text = "Tell us about it!"
        exposureTextView.textColor =  UIColor.lightGray
        
        exposureTextView.layer.cornerRadius = 10;
        exposureTextView.backgroundColor = UIColor.flatWhite()
        
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
    
    
    @IBAction func initExposure(_ sender: Any) {
        if (exposureTextView.text != nil && exposureTextView.text != "" && exposureTextView!.text != "Tell us about it!"){
            let db = Firestore.firestore()
            let user = Auth.auth().currentUser
            let ref = db.collection("users").document(user!.uid);
          
            ref.collection("exposures").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for _ in querySnapshot!.documents {
                            DBUtility.documents.numUserExposures += 1;
                            // for each collection in the user document, add one to the constant.
                            // to find the # of exposures per user.
                        }
                    }
            }
            let queryExposure = "exposure" + String(DBUtility.documents.numUserExposures)
            // create individual collection 'keys' for each exposure
            
            ref.collection("exposures").document(queryExposure).setData(["primaryFear": exposureTextView.text as Any])
            // exposures > exposure0 > [primaryFear: fear]
            
            
            DBUtility.documents.numUserExposures = 0;
            // set count back to zero for future use

        } else {
            emptyTextBox();
        }
        
    }
    
    func emptyTextBox() {
        let alert = PopupDialog(title: "Error", message: "Please enter a fear into the text box.")
        let confirm = DefaultButton(title: "Ok") {}
        alert.addButton(confirm)
        self.present(alert, animated: true, completion: nil)
        
    }
}




