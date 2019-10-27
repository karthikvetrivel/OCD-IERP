//
//  StyleUtility.swift
//  OCD Therapy
//
//  Created by Adrian Avram on 10/12/19.
//  Copyright © 2019 KarsickKeep. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func addIcon(imageName : String) {
        let imageView = UIImageView();
        let image = UIImage(named: imageName)
        
        imageView.image = image;
        imageView.setImageColor(color: UIColor.gray)
        imageView.frame = CGRect(x: 13, y: ((self.frame.size.height - 20) / 2), width: 20, height: 20)
        self.addSubview(imageView)
        
        let leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        self.leftView = leftView;
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func roundTextFieldBorder(cornerRadius : CGFloat, borderWidth : CGFloat = 0.25, borderColor : CGColor = UIColor.white.cgColor) {
        //Basic texfield Setup
        self.borderStyle = .none
        
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
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
    
    func roundViewBorder(cornerRadius : CGFloat, borderWidth : CGFloat = 0.25) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
    }
}

extension UIButton {
    func roundButtonBorder() {
        //To apply corner radius
        self.layer.cornerRadius = self.frame.size.height / 2
        
    }
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}
