//
//  LoggedInViewController.swift
//  Hancock
//
//  Created by Carter Jones on 4/12/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//

import UIKit

private var selectedCharacter = "" // Renamed to be more descriptive

private let characters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "-", "/", "\\", "|", "cross+", "crossx", "square", "circle", "triangle"]

class StudentDataSelectionViewController: UIViewController {
    @IBOutlet weak var StudentLabel: UILabel!
    @IBOutlet weak var CharacterLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let name = Service().GetCurrentStudent()
        if(StudentLabel != nil) {
            StudentLabel.text = name.split(separator: "_")[1] + " " + name.split(separator: "_")[0]
        }
    }
    @IBAction func SelectCharacter(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Character", message: nil, preferredStyle: .actionSheet)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Irish Grover", size: 50) ?? UIFont.systemFont(ofSize: 50),
            .foregroundColor: UIColor.white
        ]
        
        characters.forEach { character in
            alertController.addAction(UIAlertAction(title: character, style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                let attributedString = NSAttributedString(string: character, attributes: attributes)
                self.CharacterLabel.setAttributedTitle(attributedString, for: .normal)
                selectedCharacter = character
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "StudentDataReport", sender: self)
            }
        }
    }
}
