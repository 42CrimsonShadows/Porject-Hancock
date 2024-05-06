//
//  LoggedInViewController.swift
//  Hancock
//
//  Created by Carter Jones on 4/12/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

private var selectedCharacter = "" // Renamed to be more descriptive

class StudentDataSelectionViewController: UIViewController {
    @IBOutlet weak var StudentLabel: UILabel!
    @IBOutlet weak var CharacterLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedCharacter = ""
        self.hideKeyboardWhenTappedAround() 
        let name = Service().GetCurrentStudent()
        if(StudentLabel != nil) {
            StudentLabel.text = name.split(separator: "_")[1] + " " + name.split(separator: "_")[0]
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func SelectCharacter(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Character", message: nil, preferredStyle: .actionSheet)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Irish Grover", size: 50) ?? UIFont.systemFont(ofSize: 50),
            .foregroundColor: UIColor.white
        ]
        
        possibleExercises.forEach { exercise in
            alertController.addAction(UIAlertAction(title: exercise, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                let attributedString = NSAttributedString(string: exercise, attributes: attributes)
                self.CharacterLabel.setAttributedTitle(attributedString, for: .normal)
                selectedCharacter = exercise
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
    @IBAction func ViewDataPressed(_ sender: UIButton) {
        //set Current Student
        if (selectedCharacter != ""){
        Service().SetCharacterToReport(character: selectedCharacter)
            Service().PrintAllReports()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "StudentDataReport", sender: self)
            }
        }
    }
}
