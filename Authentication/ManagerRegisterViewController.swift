//
//  ManagerRegistrationViewController.swift
//  Hancock
//
//  Created by Chase Franklin on 3/1/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class ManagerRegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var SetPin: UITextField!
    @IBOutlet weak var FailedAttempt: UILabel!
    
    @IBAction func CreateManager(_ sender: UIButton) {
        // Immediately disable the button to prevent multiple taps
        sender.isEnabled = false
        
        //respond with error if any fields are empty
        if (!FirstName.hasText || !LastName.hasText || !SetPin.hasText || SetPin.text!.count != 4) {
            FailedAttempt.text = "please fill out all fields."
            FailedAttempt.textColor = (UIColor.systemRed)
            print("failed attempt")
            sender.isEnabled = true
        }
        //otherwise good request
        else {
            print("successful attempt")
            print("\(FirstName.text!) \(LastName.text!) \(SetPin.text!)")
            Service().CreateManager(firstName: FirstName.text!, lastName: LastName.text!, pin: SetPin.text!)
            FailedAttempt.text = "Manager Created"
            FailedAttempt.textColor = (UIColor.systemGreen)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "managerCreationSuccess", sender: self)
            }
        }
    }
    
    // UITextFieldDelegate method to enforce numeric input and limit length to 4
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Allow only numeric input and limit the length to 4 characters
        return updatedText.count <= 4 && updatedText.allSatisfy({ $0.isNumber })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetPin.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
