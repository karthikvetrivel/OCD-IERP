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

class ConseqViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var addFloatingButton: UIButton!
    
    // Primary Textfield
 
    @IBOutlet weak var conseqTextView: UITextView!
    
    
    override func viewDidLoad() {
        conseqTextView.delegate = self;
        floatingButton()
        configTextView()
        
    }
    
    func floatingButton() {
        addFloatingButton.layer.cornerRadius = 30;
        addFloatingButton.layer.masksToBounds = true;
        // Centers the text vertically
        addFloatingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    func configTextView() {
        conseqTextView.text = "Tell us about it!"
        conseqTextView.textColor =  UIColor.lightGray
        
        conseqTextView.layer.cornerRadius = 10;
        conseqTextView.backgroundColor = UIColor.flatWhite()
        
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
    
    
    @IBAction func initConseq(_ sender: Any) {
        if (conseqTextView.text != nil && conseqTextView.text != "" && conseqTextView!.text != "Tell us about it!"){
            let db = Firestore.firestore()
            let user = Auth.auth().currentUser
            let ref = db.collection("users").document(user!.uid);

            print(DBUtility.documents.numUserExposures)
            let queryExposure = "exposure" + String(DBUtility.documents.numUserExposures - 1) // reference last exposure
            let queryConseq = "consequence" + String(DBUtility.documents.numUserExposures - 1) // finds the same relating consequence document
        ref.collection("exposures").document(queryExposure).collection("consequences").document(queryConseq).setData(["primaryConseq": conseqTextView.text as Any])
            // exposures > exposure0 > consequences > consequence0 > [primaryConseq: consequence]
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "lovedView") as! lovedViewController
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





