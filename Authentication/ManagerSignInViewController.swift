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
    
    @IBAction func SelectManagerPressed(_ sender: Any) {
        print("Attempting to Select Manager")
        //TODO pop up manager list received from service.swift
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        Service().AttemptLogin(username: ManagerName.titleLabel!.text!, pin: EnterPin.text!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
