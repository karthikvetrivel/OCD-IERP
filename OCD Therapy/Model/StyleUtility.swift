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
    func addIcon(imageName : String) {
        let imageView = UIImageView();
        let image = UIImage(named: imageName)
        imageView.image = image;
        imageView.setImageColor(color: UIColor.gray)
        imageView.frame = CGRect(x: 13, y: (self.frame.size.height - 20) / 2, width: 20, height: 20)
        self.addSubview(imageView)
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        self.leftView = leftView;
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func roundBorder() {
        //Basic texfield Setup
        self.borderStyle = .none

        //To apply corner radius
        self.layer.cornerRadius = self.frame.size.height / 2

        //To apply border
        self.layer.borderWidth = 0.25
        self.layer.borderColor = UIColor.white.cgColor
    }

}

extension UIImageView {
    func setImageColor(color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }
}

extension UIView {
    func addShadow(opacity : Float = 0.5, radius : CGFloat = 5.0, offset : CGSize = CGSize(width: 0, height: 0), color : CGColor = UIColor.black.cgColor) {
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color
    }
}
