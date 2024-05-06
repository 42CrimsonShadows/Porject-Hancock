//
//  ManagerMenuViewController.swift
//  Hancock
//
//  Created by Chase Franklin on 3/1/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class ManagerMenuViewController: UIViewController {
    @IBOutlet weak var ManagerLabel: UILabel!
    
    //ManagerLabel GetManager from Service
    
    @IBAction func SignOutPressed(_ sender: UIButton) {
        Service().LogOutManager()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "managerSignOut", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let name = Service().GetCurrentManager()
        if(ManagerLabel != nil) {
            ManagerLabel.text = name.split(separator: "_")[1] + " " + name.split(separator: "_")[0]
        }
    }
}

