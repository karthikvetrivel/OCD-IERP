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
    
    // Background Constants
    let backgroundTop = UIColor(hexString: "#ff9a9e")!
    let backgroundBottom = UIColor(hexString: "fad0c4")!

    @IBOutlet weak var collectionView: UICollectionView!
    // Name Label --------------
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var dashboardBarItem: UITabBarItem!
    
    @IBOutlet weak var practiceIERP: UIButton!
    
    var collectionViewData = [Int:String]()
    //--------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        cacheAuthorization()
        setBackground()
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = true

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
//                    self.collectionView.numberOfItems(inSection: 2);
                    doc.collection("exposures").getDocuments() { (querySnapshot, err) in
                        let count = querySnapshot!.count
                        
                        var data : String = ""
                        let mainGroup = DispatchGroup()
                        mainGroup.enter()
                        let dispatchQueue = DispatchQueue(label: "consequences-effects")
                        let dispatchSemaphore = DispatchSemaphore(value: 0)
                        dispatchQueue.async {
                            for i in max(0, count - 2)..<count {
                                let index = String(count - 1 - i)
                                print(index)
                                doc.collection("exposures").document("exposure" + index).collection("consequences").document("consequence" + index).getDocument(source: .default) { (document, error) in
                                    data = document!.data()!["primaryConseq"] as! String
                                    doc.collection("exposures").document("exposure" + index).collection("effect").document("effect" + index).getDocument(source: .default) { (document, error) in
                                        data = data + " " + (document!.data()!["primaryEffect"] as! String)
                                        print("Gathered Data: " + data)
                                        self.collectionViewData[i] = data
                                        data = ""
                                        dispatchSemaphore.signal()
                                        if (i == count - 1) {
                                            mainGroup.leave()
                                        }
                                    }
                                }
                                dispatchSemaphore.wait()
                            }
                        }
                        mainGroup.notify(queue: DispatchQueue.main) {
                            print("got here")
                            self.collectionView.delegate = self
                            self.collectionView.dataSource = self
                        }
                    }
                } else {
                    print("Document does not exist in cache")
                }

            }
        }
    }
    
    func setBackground() {
        self.view.backgroundColor = UIColor(gradientStyle:UIGradientStyle.topToBottom, withFrame:self.view.frame, andColors:[backgroundTop, backgroundBottom])
    }
}

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.count;
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
        return UIEdgeInsets(top: 0, left: (collectionView.bounds.size.width - 100) / 2 - 105, bottom: 0, right: collectionView.bounds.size.width / 3)
    }

    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 100
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! HomeUICollectionViewCell
        cell.label.text = self.collectionViewData[indexPath.row]
        cell.backgroundColor = .clear
        cell.view.backgroundColor = .white
        cell.view.layer.cornerRadius = 25
        cell.view.layer.borderColor = UIColor.white.cgColor
        cell.view.layer.borderWidth = 0
        cell.view.addShadow(opacity: 0.20)
        return cell
    }
}
