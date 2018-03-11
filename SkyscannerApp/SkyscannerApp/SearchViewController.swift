//
//  SearchViewController.swift
//  SkyscannerApp
//
//  Created by Jennie  Chen on 3/10/18.
//  Copyright © 2018 Jennie Chen. All rights reserved.
//

import UIKit

var gRound : String = ""
var gDepart : String = ""
var gArrive : String = ""
var gOrigin : String = ""
var gDest : String = ""
var gStops : String = ""
var gwishList : String = ""

class SearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var round: UIButton!
    @IBOutlet weak var one: UIButton!
    @IBOutlet weak var depart: UIDatePicker!
    @IBOutlet weak var arrive: UIDatePicker!
    
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var dest: UITextField!
    @IBOutlet weak var numStops: UITextField!
    @IBOutlet weak var wishList: UITextField!
    @IBOutlet weak var findFlights: UIButton!
    
    var roundTrip : Bool = true
    
    override func viewDidLoad() {
        self.origin.delegate = self
        self.dest.delegate = self
        self.numStops.delegate = self
        self.wishList.delegate = self
        origin.underlined()
        dest.underlined()
        numStops.underlined()
        wishList.underlined()
        round.layer.cornerRadius = round.frame.height / 2
        one.layer.cornerRadius = round.frame.height / 2
        round.setTitleColor(UIColor.black, for: .normal)
        one.setTitleColor(UIColor.black, for: .normal)
        round.backgroundColor = UIColor.white
        one.backgroundColor = UIColor.clear
        findFlights.layer.cornerRadius = findFlights.frame.height / 2
        findFlights.setTitleColor(UIColor.black, for: .normal)
        findFlights.backgroundColor = UIColor.white
        
        /*
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }*/
        super.viewDidLoad()
    }
    
    internal func textFieldShouldReturn(_ origin: UITextField) -> Bool {
        origin.resignFirstResponder()
        return true;
    }
    
    @IBAction func searchFlights(_ sender: Any) {
        self.performSegue(withIdentifier: "viewResults", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressRound(_ sender: Any) {
        round.backgroundColor = UIColor.white
        one.backgroundColor = UIColor.clear
        roundTrip = true 
    }
    
    @IBAction func pressOne(_ sender: Any) {
        round.backgroundColor = UIColor.clear
        one.backgroundColor = UIColor.white
        roundTrip = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        gRound = "true"
        gDepart = depart.date.description
        gArrive = arrive.date.description
        gOrigin = origin.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        gDest = dest.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        gStops = numStops.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        gwishList = wishList.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
