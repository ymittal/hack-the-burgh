//
//  ViewController.swift
//  SkyscannerApp
//
//  Created by Jennie  Chen on 3/10/18.
//  Copyright © 2018 Jennie Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        email.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSForegroundColorAttributeName: UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.white])
        email.underlined()
        password.underlined()
        
        image.image = UIImage(named: "plane")
        
        self.email.delegate = self
        self.password.delegate = self
        
        login.backgroundColor = UIColor.white
        create.backgroundColor = UIColor.white
        login.setTitleColor(UIColor.black, for: .normal)
        create.setTitleColor(UIColor.black, for: .normal)
        login.layer.cornerRadius = login.frame.height / 2
        create.layer.cornerRadius = create.frame.height / 2
        
        /*
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }*/
        
        super.viewDidLoad()
    }
    
    internal func textFieldShouldReturn(_ email: UITextField) -> Bool {
        email.resignFirstResponder()
        return true;
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        if ((email.text?.isEmpty)! || (password.text?.isEmpty)!) {
            self.showFailedLoginAlert()
        } else {
            Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                
                if (error != nil) {
                    print(error.debugDescription)
                    self.showFailedLoginAlert()
                } else {
                    self.performSegue(withIdentifier: "login1", sender: nil)
                }
            })
        }
    }
    
    func showFailedLoginAlert() {
        var alert : UIAlertController
        alert = UIAlertController(title: "Login Failed", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

