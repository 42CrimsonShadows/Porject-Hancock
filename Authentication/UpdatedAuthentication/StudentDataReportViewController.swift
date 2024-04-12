//
//  StudentDataReportViewController.swift
//  Hancock
//
//  Created by Carter Jones on 4/12/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class StudentDataReportViewController: UIViewController {
    @IBOutlet weak var StudentLabel: UILabel!
    @IBOutlet weak var CharacterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let name = Service().GetCurrentStudent()
        if(StudentLabel != nil) {
            StudentLabel.text = name.split(separator: "_")[1] + " " + name.split(separator: "_")[0]
        }
        let character = Service().GetCharacterToReport()
        if(CharacterLabel != nil) {
            CharacterLabel.text = character
        }
        
    }
}
