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
    static func resizedImageWith(image: UIImage, targetSize: CGSize) -> UIImage {

        let imageSize = image.size
        let newWidth  = targetSize.width  / image.size.width
        let newHeight = targetSize.height / image.size.height
        var newSize: CGSize

        if(newWidth > newHeight) {
            newSize = CGSize(width: imageSize.width * newHeight, height: imageSize.height * newHeight)
        } else {
            newSize = CGSize(width: imageSize.width * newWidth,  height: imageSize.height * newWidth)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        image.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

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
    
    func styleInputTextField(imageName: String) {
        self.backgroundColor = .white
        self.addIcon(imageName: imageName)
        self.roundTextFieldBorder(cornerRadius: self.frame.size.height / 2)
        self.addShadow(opacity: 0.2, radius: 7.0, offset: CGSize(width: 0, height: 6.0))
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
    func addShadow(opacity : Float = 0.2, radius : CGFloat = 5.0, offset : CGSize = CGSize(width: 0, height: 0), color : CGColor = UIColor.black.cgColor) {
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
    func roundButtonBorder(cornerRadius: CGFloat) {
        //To apply corner radius
        self.layer.cornerRadius = cornerRadius
    }
    
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        let newImage = StyleUtility.resizedImageWith(image: image, targetSize: CGSize(width: 36.0, height: 36.0))
        self.setImage(newImage.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: newImage.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func googlify() {
        self.leftImage(image: UIImage(named: "google.png")!, renderMode: UIImage.RenderingMode.alwaysOriginal)
        self.backgroundColor = .white
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
        self.roundButtonBorder(cornerRadius: 10.0)
        self.addShadow(opacity: 0.2)
    }
    
    func registerStyle() {
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.addShadow(opacity: 0.2)
    }
}
