//
//  ConfirmDeleteStudentViewController.swift
//  Hancock
//
//  Created by Carter Jones on 4/12/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class ConfirmDeleteStudentViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func DeleteButtonPressed(_ sender: UIButton) {
        Service().DeleteStudent(studentName: Service().GetCurrentStudent(), pin: Service().GetPin())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "ToStudentDeleted", sender: self)
        }
    }
}
