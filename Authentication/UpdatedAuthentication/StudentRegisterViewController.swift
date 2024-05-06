//
//  StudentRegisterViewController.swift
//  Hancock
//
//  Created by Chase Franklin on 3/1/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class StudentRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var StudentFirstName: UITextField!
    @IBOutlet weak var StudentLastName: UITextField!
    @IBOutlet weak var FailedAttempt: UILabel!
    
    
    @IBAction func CreateStudent(_ sender: UIButton) {
        // Immediately disable the button to prevent multiple taps
        sender.isEnabled = false
        
        //respond with error if any fields are empty
        if (!StudentFirstName.hasText || !StudentLastName.hasText) {
            FailedAttempt.text = "Please fill out all fields."
            FailedAttempt.textColor = (UIColor.systemRed)
            print("failed attempt")
            sender.isEnabled = true
        }
        //otherwise good request
        else {
            print("successful attempt")
            print("\(StudentFirstName.text!) \(StudentLastName.text!)")
            Service().CreateStudent(firstName: StudentFirstName.text!, lastName: StudentLastName.text!)
            FailedAttempt.text = "Student Created"
            FailedAttempt.textColor = (UIColor.systemGreen)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "LoggedInMenu", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
