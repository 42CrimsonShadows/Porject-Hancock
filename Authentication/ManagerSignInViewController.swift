//
//  ManagerSignInViewController.swift
//  Hancock
//
//  Created by Chase Franklin on 3/1/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class ManagerSignInViewController: UIViewController {
    
    @IBOutlet weak var EnterPin: UITextField!
    @IBOutlet weak var ManagerName: UIButton!
    
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
    ]
    
    @IBAction func SelectManagerPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Item", message: nil, preferredStyle: .actionSheet)
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
        
        //print("username: " + ManagerName.attributedTitle(for: .normal) + " Pin: " + EnterPin.text!)
        //Service().AttemptLogin(username: ManagerName.attributedTitle(for: .normal), pin: EnterPin.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
