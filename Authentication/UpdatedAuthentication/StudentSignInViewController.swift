//
//  StudentSignInViewController.swift
//  Hancock
//
//  Created by Chase Franklin on 3/1/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

class StudentSignInViewController: UIViewController, UITextFieldDelegate {
    public var username = ""
    
    let StudentNames = Service().GetStudents()
    @IBOutlet weak var StudentName: UIButton!
    
    @IBAction func SelectStudentPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Student", message: nil, preferredStyle: .actionSheet)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Irish Grover", size: 50) ?? UIFont.systemFont(ofSize: 50),
            .foregroundColor: UIColor.white
        ]
        //Add Manager Name Options
        StudentNames.forEach { studentName in
            alertController.addAction(UIAlertAction(title: String(studentName.split(separator: "_")[1]) + " " + studentName.split(separator: "_")[0], style: .default, handler: { [weak self] _ in
                    guard let self = self else { return }
                    let attributedString = NSAttributedString(string: String( studentName.split(separator: "_")[1] + " " + studentName.split(separator: "_")[0]), attributes: attributes)
                    self.StudentName.setAttributedTitle(attributedString, for: .normal)
                    username = studentName
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
    @IBAction func LoginPressed(_ sender: UIButton) {
        //set Current Student
        if (true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "studentSignedIn", sender: self)
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
