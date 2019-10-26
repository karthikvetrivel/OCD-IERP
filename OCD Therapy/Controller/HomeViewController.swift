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
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Background Constants
    let backgroundTop = UIColor(hexString: "#ff9a9e")!
    let backgroundBottom = UIColor(hexString: "fad0c4")!

    // Name Label --------------
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var dashboardBarItem: UITabBarItem!
    
    //--------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        cacheAuthorization()
        setBackground()
        styleBarItem()
        
    }
    
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

    
    func styleBarItem() {
//        let appearance = UITabBarItem.appearance()
//        let attributes: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue):UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular) NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.gray]
//        appearance.setTitleTextAttributes(attribute_set, for: .normal)
        
        dashboardBarItem.image = UIImage(named: "icons8-home-50")

       
    }
    
    
    
    
    
  
}


