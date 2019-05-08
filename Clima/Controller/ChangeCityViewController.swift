//
//  ChangeCityViewController.swift
//  Clima
//
//  Created by Ketan Choyal on 22/11/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    
    func userEnteredLocation(city : String)
    
}

class ChangeCityViewController: UIViewController {

    @IBOutlet weak var changeCityTextField: UITextField!
    
    var delegate : ChangeCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func getWeatherPressed(_ sender: Any) {
        
        let cityName = changeCityTextField.text
        
        //Call the delegate method
        delegate?.userEnteredLocation(city: cityName!)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backButtomPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
