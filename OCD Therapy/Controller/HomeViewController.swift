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
    let numRecent = 5;
    
    @IBOutlet weak var collectionView: UICollectionView!
    // Name Label --------------
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dashboardBarItem: UITabBarItem!
    
    @IBOutlet weak var practiceIERP: UIButton!
    
    var collectionViewData = [Int:NSAttributedString]()
    //--------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        cacheAuthorization()
        setBackground()
        
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = true
    }
    
    func cacheAuthorization() {
        let title: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 22),
            .foregroundColor: UIColor.black,
        ]
        if Auth.auth().currentUser != nil {
            let db = Firestore.firestore()
            let doc = db.collection("users").document(Auth.auth().currentUser!.uid)
            doc.getDocument(source: .default) { (document, error) in
                if let document = document {
                    let dataDescription = document.data() ?? nil
                    var userString : String = dataDescription!["name"] as? String ?? "user"
                    userString = userString.components(separatedBy: " ").first!
                    self.nameLabel.text  = "Welcome back " + userString + "!"
                    
                    doc.collection("exposures").getDocuments() { (querySnapshot, err) in
                        let description: [NSAttributedString.Key: Any] = [
                            .font: UIFont.systemFont(ofSize: 18),
                        ]
                        let count = querySnapshot!.count
                        let mainGroup = DispatchGroup()
                        mainGroup.enter()
                        let dispatchQueue = DispatchQueue(label: "consequences-effects")
                        let dispatchSemaphore = DispatchSemaphore(value: 0)
                        var iterations : Int
                        if (count >= self.numRecent) {
                            iterations = self.numRecent;
                        } else {
                            iterations = max(count, 0)
                        }
                        //                        print("Count: " + String(count))
                        if (count == 0) {
                            self.collectionViewData[0] = NSMutableAttributedString(string: "\nNo exposures added. Press the add exposure tab to get started!", attributes: title)
                            self.collectionView.delegate = self
                            self.collectionView.dataSource = self
                        }
                        dispatchQueue.async {
                            for i in 0..<iterations {
                                let index = String(count - 1 - i)
                                print(index)
                                var consequence : String = ""
                                var primaryFear : String = ""
                                var effect : String = ""
                                var anxietyLevel : String = ""
                                doc.collection("exposures").document("exposure" + index).collection("consequences").document("consequence" + index).getDocument(source: .default) { (document, error) in
                                    
                                    consequence = document!.data()!["primaryConseq"] as! String
                                    
                                    doc.collection("exposures").document("exposure" + index).getDocument(source: .default) { (document, error) in
                                        
                                        primaryFear = document!.data()!["primaryFear"] as! String
                                        anxietyLevel = String(document!.data()!["anxietyLevel"] as! Int)
                                        
                                        doc.collection("exposures").document("exposure" + index).collection("effect").document("effect" + index).getDocument(source: .default) { (document, error) in
                                            effect = document!.data()!["primaryEffect"] as! String
                                            
                                            let cardText = NSMutableAttributedString(string: "\nFear", attributes: title)
                                            cardText.append(NSAttributedString(string: "\n" + primaryFear, attributes: description))
                                            cardText.append(NSAttributedString(string: "\n\n" + "Consequence", attributes: title))
                                            cardText.append(NSAttributedString(string: "\n" + consequence, attributes: description))
                                            cardText.append(NSAttributedString(string: "\n\n" + "Effect", attributes: title))
                                            cardText.append(NSAttributedString(string: "\n" + effect, attributes: description))
                                            cardText.append(NSAttributedString(string: "\n\n" + "Anxiety Level", attributes: title))
                                            cardText.append(NSAttributedString(string: "\n" + anxietyLevel, attributes: description))
                                            self.collectionViewData[i] = cardText
                                            dispatchSemaphore.signal()
                                            if (i == iterations - 1) {
                                                mainGroup.leave()
                                            }
                                        }
                                    }
                                }
                                dispatchSemaphore.wait()
                            }
                        }
                        mainGroup.notify(queue: DispatchQueue.main) {
                            // Finished fetching the data. Make the collectionview
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
        return UIEdgeInsets(top: 0, left: (collectionView.bounds.size.width - 100) / 2 - 105, bottom: 0, right: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                               minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 100
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! HomeUICollectionViewCell
        cell.label.attributedText = self.collectionViewData[indexPath.row]
        cell.backgroundColor = .clear
        cell.view.backgroundColor = .white
        cell.view.layer.cornerRadius = 25
        cell.view.layer.borderColor = UIColor.white.cgColor
        cell.view.layer.borderWidth = 0
        cell.view.addShadow(opacity: 0.20)
        return cell
    }
}
