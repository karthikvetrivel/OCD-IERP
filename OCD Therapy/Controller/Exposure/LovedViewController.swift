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

class LovedViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var addFloatingButton: UIButton!
    
    // Primary Textfield
    
    @IBOutlet weak var lovedTextView: UITextView!
    
    
    override func viewDidLoad() {
        lovedTextView.delegate = self;
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
        lovedTextView.text = "Tell us about it!"
        lovedTextView.textColor =  UIColor.lightGray
        
        lovedTextView.layer.cornerRadius = 10;
        lovedTextView.backgroundColor = UIColor.flatWhite
        
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
    
    
    @IBAction func initLoved(_ sender: Any) {
        if (lovedTextView.text != nil && lovedTextView.text != "" && lovedTextView!.text != "Tell us about it!"){
            let db = Firestore.firestore()
            let user = Auth.auth().currentUser
            let ref = db.collection("users").document(user!.uid);
            
            let queryExposure = "exposure" + String(DBUtility.documents.numUserExposures) // reference last exposure
            let queryEffect = "effect" + String(DBUtility.documents.numUserExposures) // finds the relating effect document
         ref.collection("exposures").document(queryExposure).collection("effect").document(queryEffect).setData(["primaryEffect": lovedTextView.text as Any])
            // exposures > exposure0 > consequences > consequence0 > [primaryConseq: consequence]
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "anxietyView") as! AnxietyViewController
            present(controller, animated: true, completion: nil)
         
            
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






