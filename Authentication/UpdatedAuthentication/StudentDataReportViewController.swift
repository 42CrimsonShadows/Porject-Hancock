
//
//  StudentDataReportViewController.swift
//  Hancock
//
//  Created by Carter Jones on 4/12/24.
//  Copyright © 2024 Chris Ross. All rights reserved.
//
// sorry.

import UIKit

class StudentDataReportViewController: UIViewController {
    @IBOutlet weak var StudentLabel: UILabel!
    @IBOutlet weak var CharacterLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let character = Service().GetCharacterToReport()
    
    //Styling
    //h1
        //font size
        //height
    let primaryHeaderRowHeight = 45
    let primaryHeaderFont = UIFont(name: "Irish Grover", size: 42) ?? UIFont.systemFont(ofSize: 42)

    //h2
        //font size
        //height
    let secondaryHeaderRowHeight = 40
    let secondaryHeaderFont = UIFont(name: "Irish Grover", size: 36) ?? UIFont.systemFont(ofSize: 36)
    
    //p
        //font size
        //height
    let paragraphRowHeight = 30
    let paragraphFont = UIFont(name: "Irish Grover", size: 28) ?? UIFont.systemFont(ofSize: 28)
    
    let textColor = UIColor(red: 72/255, green: 77/255, blue: 109/255, alpha: 1)
//    let textColor = UIColor.white
//    let backgroundColor = UIColor(red: 140/255, green: 122/255, blue: 169/255, alpha: 1)
   
    var col1: Int = -1
    var col2: Int = -1
    var col3: Int = -1
    
    //img
    let imgHeight = 250
    let imgWidth = 250

    //padding
    let padding = 50
    //sessionBlockYValue
    var sessionBlockYValue: Int = -1
    let sessionBlockYValueIncrement = 50
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        col1 = Int(scrollView.frame.width)
        col2 = Int(scrollView.frame.width / 2)
        col3 = Int(scrollView.frame.width / 3)
        sessionBlockYValue = padding

        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.current

        let name = Service().GetCurrentStudent()
        if let StudentLabel = StudentLabel {
            StudentLabel.text = name.split(separator: "_")[1] + " " + name.split(separator: "_")[0]
        }
        if let CharacterLabel = CharacterLabel {
            CharacterLabel.text = character
        }

        let characterReports = Service().GetCharacterReport(character: character)

        var previousSessionView: UIView? = nil
        for characterReport in characterReports {
            let sessionView = createSessionBlock(characterReport: characterReport)
            scrollView.addSubview(sessionView)

            // Position the session view relative to the previous one
            if let previousSessionView = previousSessionView {
                sessionView.frame.origin.y = previousSessionView.frame.maxY //+ CGFloat(padding)
            } else {
                sessionView.frame.origin.y = 0
            }
            previousSessionView = sessionView
        }

        // Set the content size of the scroll view to fit all session views and their contents
        if previousSessionView != nil {
            scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: CGFloat(sessionBlockYValue + padding * 10))
        }
//        scrollView.backgroundColor = backgroundColor
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //create session block
    func createSessionBlock(characterReport: CharacterReport) -> UIView {
        let sessionView = UIView()
        sessionView.frame = CGRect(x: 0, y: sessionBlockYValue/2, width: 0, height: 0)
        
        let dateLabel = UILabel()
        dateLabel.text = dateFormatter.string(from: characterReport.date)
        dateLabel.textColor = textColor
        dateLabel.font = primaryHeaderFont
        dateLabel.frame = CGRect(x: 0, y: Int(sessionView.frame.origin.y), width: col1, height: primaryHeaderRowHeight)
        sessionView.addSubview(dateLabel)
        
        let attemptsLabel = UILabel()
        attemptsLabel.text = "Attempts: \(characterReport.attemptCount)"
        attemptsLabel.textColor = textColor
        attemptsLabel.font = paragraphFont
        attemptsLabel.frame = CGRect(x: 0, y: Int(dateLabel.frame.minY) + padding, width: col3, height: paragraphRowHeight)
        sessionView.addSubview(attemptsLabel)
        
        let avgErrorsLabel = UILabel()
        avgErrorsLabel.text = "AVG Errors: \(characterReport.totalFaults / characterReport.attemptCount)"
        avgErrorsLabel.textColor = textColor
        avgErrorsLabel.font = paragraphFont
        avgErrorsLabel.frame = CGRect(x: col3, y: Int(dateLabel.frame.minY) + padding, width: col3, height: paragraphRowHeight)
        sessionView.addSubview(avgErrorsLabel)
        
        let avgScoreLabel = UILabel()
        avgScoreLabel.text = "AVG Score: \(characterReport.totalScore / characterReport.attemptCount) / \(characterReport.totalPossibleScore / characterReport.attemptCount)"
        avgScoreLabel.textColor = textColor
        avgScoreLabel.font = paragraphFont
        avgScoreLabel.frame = CGRect(x: col3 * 2, y: Int(dateLabel.frame.minY) + padding, width: col3, height: paragraphRowHeight)
        sessionView.addSubview(avgScoreLabel)
        
        //add attempts
        let attemptsContainer = UIView()
        attemptsContainer.frame = CGRect(x: 0, y: Int(avgScoreLabel.frame.minY), width: col1, height: 0)
        var attemptCounter = 0
        for attempt in characterReport.attempts {
            attemptCounter += 1
            createAttemptBlock(parentView: attemptsContainer, attempt: attempt, attemptNumber: attemptCounter)
        }
        sessionView.addSubview(attemptsContainer)
        
        sessionView.frame = CGRect(x: sessionView.frame.origin.x,
                                   y: sessionView.frame.origin.y,
                                   width: CGFloat(col1),
                                   height: CGFloat(padding) + attemptsContainer.frame.height)
        print(sessionView.frame.height)
        print(sessionView.frame.origin.y)
        
        scrollView.addSubview(sessionView)
        sessionBlockYValue += Int(sessionView.frame.height) + padding
        
        return sessionView
    }
    func createAttemptBlock(parentView: UIView, attempt: LetterStruct, attemptNumber: Int) {
        let attemptContainer = UIView()
        
        let attemptLabel = UILabel()
        attemptLabel.text = "Attempt: \(attemptNumber)"
        attemptLabel.textColor = textColor
        attemptLabel.font = secondaryHeaderFont
        attemptLabel.frame = CGRect(x: 0, y: padding * 3, width: col3, height: secondaryHeaderRowHeight)
        
        let errorLabel = UILabel()
        errorLabel.text = "Errors: \(attempt.faults)"
        errorLabel.textColor = textColor
        errorLabel.font = paragraphFont
        errorLabel.frame = CGRect(x: 0, y: Int(attemptLabel.frame.minY + attemptLabel.frame.height) + padding, width: col3, height: paragraphRowHeight)
        
        let scoreLabel = UILabel()
        scoreLabel.text = "Score: \(attempt.tokens) / \(attempt.possibleTokens)"
        scoreLabel.textColor = textColor
        scoreLabel.font = paragraphFont
        scoreLabel.frame = CGRect(x: 0, y: Int(errorLabel.frame.minY + attemptLabel.frame.height) + padding, width: col3, height: paragraphRowHeight)
        
 
        let encodedImage = Data(base64Encoded: attempt.offpath_image)
        let image = UIImage(data: encodedImage!)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: col2, y: Int(attemptLabel.frame.minY), width: imgWidth, height: imgHeight)

        attemptContainer.frame = CGRect(x: 0, y: (imageView.frame.height + CGFloat(padding)) * CGFloat(attemptNumber - 1), width: parentView.frame.width, height: imageView.frame.height)
        
        attemptContainer.addSubview(attemptLabel)
        attemptContainer.addSubview(errorLabel)
        attemptContainer.addSubview(scoreLabel)
        attemptContainer.addSubview(imageView)
        
        parentView.addSubview(attemptContainer)
        parentView.frame = CGRect(x: parentView.frame.origin.x,
                                   y: parentView.frame.origin.y,
                                   width: parentView.frame.width,
                                  height:  attemptContainer.frame.height + CGFloat(padding))
        
        sessionBlockYValue += 250
    }
}
