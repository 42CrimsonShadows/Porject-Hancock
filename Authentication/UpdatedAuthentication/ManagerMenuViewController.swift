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
        //clear current manager
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "managerSignOut", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

