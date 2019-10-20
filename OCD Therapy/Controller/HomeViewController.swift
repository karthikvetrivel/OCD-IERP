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
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self

        
        cacheAuthorization()
        setBackground()
        // Sorry bub
//        styleMainButtons()
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
    
    func styleMainButtons() {
        exposureButton.layer.cornerRadius = 10
        practiceIERPButton.layer.cornerRadius = 10
        obsessButton.layer.cornerRadius = 10
        trackProgressButton.layer.cornerRadius = 10
        settingButton.layer.cornerRadius = 10
    }
  
}

extension UIViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // The number of items
        return 10;
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Take up full space
        return CGSize(width: collectionView.bounds.size.width - 100, height: collectionView.bounds.size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        let totalCellWidth = (collectionView.bounds.size.width - 100) * 10
//        let totalSpacingWidth = CGFloat(100 * (10 - 1))
//
//        let leftInset = (collectionView.bounds.size.width - totalCellWidth + totalSpacingWidth) / 2
//        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: (collectionView.bounds.size.width - 100) / 2 - 105, bottom: 0, right: 100 * 10 - (collectionView.bounds.size.width - 100) / 2 + 20)
    }

    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 100
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! HomeUICollectionViewCell

        cell.label.text = String(indexPath.row + 1)
        cell.backgroundColor = .clear
        cell.view.backgroundColor = .white
        cell.view.roundBorder(cornerRadius: 25)
        cell.view.addShadow()
        return cell
    }
}
