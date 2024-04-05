//
//  ManagerDeleteViewController.swift
//  Hancock
//
//  Created by Mitchell Oliarny on 4/5/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//


import UIKit

class ManagerDeleteViewController: UIViewController {
 
    
    //ManagerLabel GetManager from Service

    @IBAction func DeleteTeacher(_ sender: UIButton) {
        let pin = Service().GetPin()
        print("tried. pin : " + pin);
        if (pin != "") {
            let result = Service().DeleteManager(pin: pin)
            if(result) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.performSegue(withIdentifier: "DeletedManager", sender: self)
                }
            }
            else {
                //failed
                print("failed");
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
