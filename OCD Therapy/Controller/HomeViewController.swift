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

class HomeViewController: UIViewController {

    
    // Primary Variable Declaration:
    
    // Background Constants
    let backgroundTop = UIColor(hexString: "#ff9a9e")!
    let backgroundBottom = UIColor(hexString: "fad0c4")!
    
    // Button Constants -----------
    @IBOutlet weak var exposureButton: UIButton!
    @IBOutlet weak var practiceIERPButton: UIButton!
    @IBOutlet weak var obsessButton: UIButton!
    @IBOutlet weak var trackProgressButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    // Name Label --------------
    @IBOutlet weak var nameLabel: UILabel!
    
    //--------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    

        
        cacheAuthorization();
        setBackground();
        styleMainButtons()
        // Do any additional setup after loading the view.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func cacheAuthorization() {

        if Auth.auth().currentUser != nil {
            let db = Firestore.firestore()
            let doc = db.collection("users").document(Auth.auth().currentUser!.uid)
            doc.getDocument(source: .default) { (document, error) in
                if let document = document {
                    let dataDescription = document.data() ?? nil
                    var userString : String = dataDescription!["name"] as? String ?? "user"
                    userString = userString.components(separatedBy: " ").first!
                    self.nameLabel.text  = "Welcome back " + userString + "!"
                } else {
                    print("Document does not exist in cache")
                }

            }
        }
    }

    
    func setBackground() {
        self.view.backgroundColor = UIColor(gradientStyle:UIGradientStyle.topToBottom, withFrame:self.view.frame, andColors:[backgroundTop, backgroundBottom])
    }
    
    func styleMainButtons() {
        exposureButton.layer.cornerRadius = 10
        practiceIERPButton.layer.cornerRadius = 10
        obsessButton.layer.cornerRadius = 10
        trackProgressButton.layer.cornerRadius = 10
        settingButton.layer.cornerRadius = 10
    }
  
}
