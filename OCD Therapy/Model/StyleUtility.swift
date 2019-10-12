//
//  StyleUtility.swift
//  OCD Therapy
//
//  Created by Adrian Avram on 10/12/19.
//  Copyright © 2019 KarsickKeep. All rights reserved.
//

import Foundation
import UIKit

class StyleUtility {
    
}

extension UITextField {
    func addIcon(imageName : String, verticalMargin : Double = 9) {
        let imageView = UIImageView();
        let image = UIImage(named: imageName)
        imageView.image = image;
        imageView.setImageColor(color: UIColor.gray)
        imageView.frame = CGRect(x: 13, y: verticalMargin, width: 20, height: 20)
        self.addSubview(imageView)
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        self.leftView = leftView;
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func addShadow() {
            //Basic texfield Setup
        self.borderStyle = .none
        self.backgroundColor = UIColor.groupTableViewBackground // Use anycolor that give you a 2d look.

        //To apply corner radius
        self.layer.cornerRadius = self.frame.size.height / 2

        //To apply border
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.white.cgColor

        //To apply Shadow
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 10.0
        self.layer.shadowOffset = CGSize(width: 0, height: 5) // Use any CGSize
        self.layer.shadowColor = UIColor.black.cgColor
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }
}
