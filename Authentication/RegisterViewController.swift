//
//  RegisterViewController.swift
//  Hancock
//
//  Created by Casey on 5/29/19.
//  Copyright © 2019 Chris Ross. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {


    @IBOutlet weak var FirstNameField: UITextField!
    @IBOutlet weak var LastNameField: UITextField!
    @IBOutlet weak var UsernameField: UITextField!
    @IBOutlet weak var PassField: UITextField!
    @IBOutlet weak var CPassField: UITextField!
    @IBOutlet weak var PEmailField: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    var success = false
    
    
    @IBAction func RequestRegistration(_ sender: Any) {
        print("Attempting to Register")
        // check for empty fields
        if((UsernameField.text == "") || (FirstNameField.text == "") || (LastNameField.text == "") || (PassField.text == "") || (CPassField.text == "") || (PEmailField.text == ""))
        {
            print("Empty fields")
            ErrorLabel.text = "Must fill out all fields"
        }else {
            if(PassField.text != CPassField.text) // check to make sure passwords match
            {
                print("Passwords don't match")
                ErrorLabel.text = "Passwords need to match"
            }
            else{
                guard let username = UsernameField.text else { return }
                guard let email = PEmailField.text else { return }
                guard let password = PassField.text else { return }
                guard let first = FirstNameField.text else { return }
                guard let last = LastNameField.text else { return }
                
                // api calls run on a background thread, so we use this lambda to get the result from Service and use it in main thread
                // call register and set success, call segue on main thread

            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //lock rotation
        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    func doSegue(username: String, password: String)
    {
        // check for successful registration, and send to login
        if(success)
        {
            print("REGISTER")
            ErrorLabel.text = ""
            self.performSegue(withIdentifier: "toLogin", sender: self)
        }
        else
        {
            print("Username already exists")
            ErrorLabel.text = "Username already exists"
        }
    }

}

