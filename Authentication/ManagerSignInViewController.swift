//
//  ManagerSignInViewController.swift
//  Hancock
//
//  Created by Chase Franklin on 3/1/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class ManagerSignInViewController: UIViewController, UITextFieldDelegate {
    var username = ""
    var pin = ""
    
    //Temporary
    var ManagerNames = [
        "Option 1",
        "Option 2",
        "Option 3",
        "Option 4",
        "Option 5",
        "Option 6",
        "Option 7",
        "Option 8",
        "Option 9",
        "Option 10",
        "Option 11",
        "Option 12",
        "Option 13",
        "Option 14",
        "Option 15",
        "Option 16",
        "Option 17",
        "Option 18",
        "Option 19",
        "Option 20",
        "Option 21",
        "Option 22",
        "Option 23",
        "Option 24",
        "Option 25",
        "Option 26",
    ]
    
    @IBOutlet weak var EnterPin: UITextField!
    @IBOutlet weak var ManagerName: UIButton!
    @IBOutlet weak var FailedAttempt: UILabel!
    
    @IBAction func SelectManagerPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Manager", message: nil, preferredStyle: .actionSheet)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Irish Grover", size: 50) ?? UIFont.systemFont(ofSize: 50),
            .foregroundColor: UIColor.white
        ]
        //Add Manager Name Options
        ManagerNames.forEach { managerName in
                alertController.addAction(UIAlertAction(title: managerName, style: .default, handler: { [weak self] _ in
                    guard let self = self else { return }
                    let attributedString = NSAttributedString(string: managerName, attributes: attributes)
                    self.ManagerName.setAttributedTitle(attributedString, for: .normal)
                    username = managerName
                }))
            }

        // Include a Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // For iPad compatibility
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }

        // Present the alertController
        present(alertController, animated: true)
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        pin = EnterPin.text!
        print("username: " + username + " Pin: " + pin)
        if (Service().AttemptLogin(username: username, pin: pin) && !username.isEmpty){
            FailedAttempt.text = "Login Success"
            FailedAttempt.textColor = (UIColor.systemGreen)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "managerLoginSuccess", sender: self)
            }
        }
        else{
            FailedAttempt.textColor = (UIColor.systemRed)
            FailedAttempt.text = "username and pin do not match"
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
        EnterPin.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
