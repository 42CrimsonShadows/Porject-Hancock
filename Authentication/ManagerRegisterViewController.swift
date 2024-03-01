//
//  ManagerRegistrationViewController.swift
//  Hancock
//
//  Created by Chase Franklin on 3/1/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class ManagerRegistrationViewController: UIViewController {
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var SetPin: UITextField!
    
    var minLength: Int = 4
    var maxLength: Int = 6
    
    @IBAction func CreateManager(_ sender: Any) {
        //respond with error if any fields are empty
        if (FirstName.text == nil || LastName.text == nil || SetPin.text == nil) {
            //TODO
        }
        //check if pin is not within range
        else if (minLength...maxLength).contains(SetPin.text!.count) {
            //TODO
        }
        //otherwise good request
        else {
            Service().CreateManager(firstName: FirstName.text!, lastName: LastName.text!, pin: SetPin.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
