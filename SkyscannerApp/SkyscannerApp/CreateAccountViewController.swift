//
//  CreateAccountViewController.swift
//  SkyscannerApp
//
//  Created by Jennie  Chen on 3/10/18.
//  Copyright © 2018 Jennie Chen. All rights reserved.
//

import UIKit
import FirebaseAuth

class CreateAccountViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var currency: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var create: UIButton!
    @IBOutlet weak var back: UIButton!
    
    override func viewDidLoad() {
        name.underlined()
        currency.underlined()
        country.underlined()
        email.underlined()
        password.underlined()
        self.name.delegate = self
        self.currency.delegate = self
        self.country.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        super.viewDidLoad()
        
        back.backgroundColor = UIColor.white
        create.backgroundColor = UIColor.white
        back.setTitleColor(UIColor.black, for: .normal)
        create.setTitleColor(UIColor.black, for: .normal)
        back.layer.cornerRadius = back.frame.height / 2
        create.layer.cornerRadius = create.frame.height / 2
        
        /*
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }*/
    }
    
    internal func textFieldShouldReturn(_ name: UITextField) -> Bool {
        name.resignFirstResponder()
        return true;
    }

    
    @IBAction func createAccount(_ sender: Any) {
        if (name.text!.isEmpty || currency.text!.isEmpty || country.text!.isEmpty || email.text!.isEmpty
            || password.text!.isEmpty) {
            self.showFailedCreateAlert()
        } else {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!)
            {
                (user, error) in
                if (error != nil) {
                    print(error.debugDescription);
                } else {
                    self.performSegue(withIdentifier: "login2", sender: nil)
                }
                
            }
        }
    }
    
    
    func showFailedCreateAlert() {
        var alert : UIAlertController
        alert = UIAlertController(title: "Failed to Create Account", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
