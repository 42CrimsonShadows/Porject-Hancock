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
    
    @IBAction func SelectManagerPressed(_ sender: Any) {
        print("Attempting to Select Manager")
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        print("Attempting to Login")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
