//
//  ResultsViewController.swift
//  SkyscannerApp
//
//  Created by Jennie  Chen on 3/10/18.
//  Copyright © 2018 Jennie Chen. All rights reserved.
//
import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var book: UIButton!
    
    var info : [String] = []
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        back.layer.cornerRadius = back.frame.height / 2
        back.setTitleColor(UIColor.black, for: .normal)
        back.backgroundColor = UIColor.white
        
        book.layer.cornerRadius = back.frame.height / 2
        book.setTitleColor(UIColor.black, for: .normal)
        book.backgroundColor = UIColor.white
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        if let image = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        print(gOrigin)
        let json: [String: Any] = [
            "country": "FR",
            "currency": "eur",
            "locale": "en-US",
            "origin": gOrigin,
            "destination": gDest,
            "num_stops": gStops,
            "wish_list": gwishList,
            "start_date": gDepart.prefix(10),
            "end_date": gArrive.prefix(10)
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        
       
        
        // create post request
        let url = URL(string: "http://94593deb.ngrok.io/createItinerary")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    
        // insert json data to the request
        request.httpBody = jsonData
        
        var str : String = ""
        var cost : Int = 0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON)
            
            
            if let flights = responseJSON as? NSArray {
                for i in 0 ... Int(gStops)! {
                    if let flight1 = flights[i] as? [String : Any] {
                        print(flight1)
                        if let flight_data = flight1["flight_data"] as? [String : Any] {
                            if let origin = flight_data["origin"] as? [String : Any] {
                                if let iataCode = origin["IataCode"] as? String {
                                    str = str + iataCode + " - "
                                }
                            }
                            if let destination = flight_data["destination"] as? [String: Any]{
                                if let iataCode = destination["IataCode"] as? String{
                                    if (i != Int(gStops)) {
                                        str = str + iataCode + " | "
                                    } else {
                                        str = str + iataCode
                                    }
                                    print("reaches")
                                }
                            }
                            if let price = flight_data["price"] as? Int {
                                print(cost)
                                cost += price
                            }
                        }
                    }
                }
            }
            print(str)
            
            DispatchQueue.main.async {
                self.label1.text = str
                self.label2.text = "Cost: £" + String(cost)
            }
            
        }
        
        self.info.append(str)
        //str = str + String(cost)
        //self.label1.text = str
        task.resume()
        
        super.viewDidLoad()
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
