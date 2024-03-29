//
//  StudentSignInViewController.swift
//  Hancock
//
//  Created by Chase Franklin on 3/1/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class StudentSignInViewController: UIViewController {
    
    let StudentNames = Service().GetStudents()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
