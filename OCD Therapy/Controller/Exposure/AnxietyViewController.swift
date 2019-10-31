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

class AnxietyViewController: UIViewController{
    
    
    @IBOutlet weak var addFloatingButton: UIButton!
    
    
    @IBOutlet weak var anxietySlider: UISlider!
    
    
    override func viewDidLoad() {
        floatingButton()
        
    }
    
    func floatingButton() {
        addFloatingButton.layer.cornerRadius = 30;
        addFloatingButton.layer.masksToBounds = true;
        // Centers the text vertically
        addFloatingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
    }
    
    
    func configAnxietySlider() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        let ref = db.collection("users").document(user!.uid);

        let anxietyLevel : Int = Int(round(anxietySlider.value));
        
        
        let queryExposure = "exposure" + String(DBUtility.documents.numUserExposures) // reference last exposure

         ref.collection("exposures").document(queryExposure).setData(["anxietyLevel": anxietyLevel], merge: true)
        // exposures > exposure0 > consequences > consequence0 > [primaryConseq: consequence]
        
    }
    

    
    @IBAction func initAnxiety(_ sender: Any) {
        configAnxietySlider();
            completionTextBox();
        
        
    }
    
    
    func completionTextBox() {
        let alert = PopupDialog(title: "Completed!", message: "Great job on adding a exposure!")
        let confirm = DefaultButton(title: "Ok") {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            self.present(controller, animated: true, completion: nil)
        }
        alert.addButton(confirm)
        self.present(alert, animated: true, completion: nil)
        
    }
}







