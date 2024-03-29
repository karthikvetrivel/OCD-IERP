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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func floatingButton() {
        addFloatingButton.layer.cornerRadius = 30;
        addFloatingButton.layer.masksToBounds = true;
        // Centers the text vertically
        addFloatingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
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
    
    
    @IBAction func initExposure(_ sender: Any) {
        if (exposureTextView.text != nil && exposureTextView.text != "" && exposureTextView!.text != "Tell us about it!"){
            let db = Firestore.firestore()
            let user = Auth.auth().currentUser
            let ref = db.collection("users").document(user!.uid);
            
            DBUtility.documents.numUserExposures = 0;
            
            
            ref.collection("exposures").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            print(DBUtility.documents.numUserExposures);
                            DBUtility.documents.numUserExposures += 1;
                            
                        }
                        
                     
                        let queryExposure = "exposure" + String(DBUtility.documents.numUserExposures)
                        // create individual collection 'keys' for each exposure
                        
                        ref.collection("exposures").document(queryExposure).setData(["primaryFear": self.exposureTextView.text as Any])
                        // exposures > exposure0 > [primaryFear: fear]
                        
                        
                        
                        
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "conseqView") as! ConseqViewController
                        self.present(controller, animated: true, completion: nil)
                        // set count back to zero for future use
                        
                    }
                
            }
            
            
            
            

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




