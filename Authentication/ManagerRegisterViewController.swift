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
    
    @IBAction func CreateManager(_ sender: Any) {
        print("Attempting to Register")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
