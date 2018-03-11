//
//  TextFieldExtension.swift
//  SkyscannerApp
//
//  Created by Jennie  Chen on 3/10/18.
//  Copyright © 2018 Jennie Chen. All rights reserved.
//

import UIKit

extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        //self.borderStyle = UITextBorderStyle.none
        border.borderWidth = width
        self.backgroundColor = UIColor.clear
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
