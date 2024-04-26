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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let character = Service().GetCharacterToReport()
    
    //Styling
    //h1
        //font size
        //height
    let primaryHeaderFontSize: CGFloat = 42
    let primaryHeaderRowHeight = 45
    //h2
        //font size
        //height
    let secondaryHeaderFontSize: CGFloat = 36
    let secondaryHeaderRowHeight = 40
    //p
        //font size
        //height
    let paragraphFontSize: CGFloat = 28
    let paragraphRowHeight = 30
   
    var col1: Int = -1
    var col2: Int = -1
    var col3: Int = -1
    //img
    //TODO

    //padding
    let padding = 20
    //sessionBlockYValue
    var sessionBlockYValue: Int = -1
    let sessionBlockYValueIncrement = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        col1 = Int(scrollView.frame.width)
        col2 = Int(scrollView.frame.width / 2)
        col3 = Int(scrollView.frame.width / 3)
        sessionBlockYValue = padding
        
        let name = Service().GetCurrentStudent()
        if(StudentLabel != nil) {
            StudentLabel.text = name.split(separator: "_")[1] + " " + name.split(separator: "_")[0]
        }
        if(CharacterLabel != nil) {
            CharacterLabel.text = character
        }
        
        let characterReports = Service().GetCharacterReport(character: character)
        
        for characterReport in characterReports {
            createSessionBlock(characterReport: characterReport)
            print("found new session")
        }
                
        // Set the content size of the scroll view to accommodate all the subviews
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: CGFloat(sessionBlockYValue + padding))
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //create session block
    func createSessionBlock(characterReport: CharacterReport) {
        //DateFormatter settings <- this should be done outside of a looped method
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        let dateLabel = UILabel()
        dateLabel.text = dateFormatter.string(from: characterReport.date)
        dateLabel.font = UIFont.systemFont(ofSize: primaryHeaderFontSize)
        dateLabel.frame = CGRect(x: padding, y: sessionBlockYValue, width: col1, height: primaryHeaderRowHeight)
        
        let attemptsLabel = UILabel()
        attemptsLabel.text = "Attempts: \(characterReport.attemptCount)"
        attemptsLabel.font = UIFont.systemFont(ofSize: paragraphFontSize)
        attemptsLabel.frame = CGRect(x: 0, y: Int(dateLabel.frame.height + CGFloat(padding)), width: col3, height: paragraphRowHeight)
        dateLabel.addSubview(attemptsLabel)
        
        let avgErrorsLabel = UILabel()
        avgErrorsLabel.text = "AVG Errors: \(characterReport.totalFaults / characterReport.attemptCount)"
        avgErrorsLabel.font = UIFont.systemFont(ofSize: paragraphFontSize)
        avgErrorsLabel.frame = CGRect(x: col3, y: Int(dateLabel.frame.height + CGFloat(padding)), width: col3, height: paragraphRowHeight)
        dateLabel.addSubview(avgErrorsLabel)
        
        let avgScoreLabel = UILabel()
        avgScoreLabel.text = "AVG Score: \(characterReport.totalScore / characterReport.attemptCount) / \(characterReport.totalPossibleScore / characterReport.attemptCount)"
        avgScoreLabel.font = UIFont.systemFont(ofSize: paragraphFontSize)
        avgScoreLabel.frame = CGRect(x: col3 * 2, y: Int(dateLabel.frame.height + CGFloat(padding)), width: col3, height: paragraphRowHeight)
        dateLabel.addSubview(avgScoreLabel)
        
        //add attempts
        var attemptCounter = 0
        for attempt in characterReport.attempts {
            attemptCounter += 1
            createAttemptBlock(parentView: attemptsLabel, attempt: attempt, attemptNumber: attemptCounter)
        }
        
        scrollView.addSubview(dateLabel)
        sessionBlockYValue += sessionBlockYValueIncrement
    }
    func createAttemptBlock(parentView: UIView, attempt: LetterStruct, attemptNumber: Int) {
        //TODO ADD IMAGE SUPPORT
        let attemptLabel = UILabel()
        attemptLabel.text = "Attempt: \(attemptNumber)"
        attemptLabel.font = UIFont.systemFont(ofSize: secondaryHeaderFontSize)
        attemptLabel.frame = CGRect(x: 0, y: sessionBlockYValue + (padding * 3), width: col3, height: secondaryHeaderRowHeight)
        
        let errorLabel = UILabel()
        errorLabel.text = "Errors: \(attempt.faults)"
        errorLabel.font = UIFont.systemFont(ofSize: paragraphFontSize)
        errorLabel.frame = CGRect(x: 0, y: Int(attemptLabel.frame.minY + attemptLabel.frame.height) + padding, width: col3, height: paragraphRowHeight)
        
        let scoreLabel = UILabel()
        scoreLabel.text = "Score: \(attempt.tokens) / \(attempt.possibleTokens)"
        scoreLabel.font = UIFont.systemFont(ofSize: paragraphFontSize)
        scoreLabel.frame = CGRect(x: 0, y: Int(errorLabel.frame.minY + attemptLabel.frame.height) + padding, width: col3, height: paragraphRowHeight)
        
 
            let encodedImage = Data(base64Encoded: attempt.offpath_image)
            let image = UIImage(data: encodedImage!)
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: col2, y: sessionBlockYValue + (padding), width: 250, height: 200)

        
        parentView.addSubview(attemptLabel)
        parentView.addSubview(errorLabel)
        parentView.addSubview(scoreLabel)
        parentView.addSubview(imageView)
    }
}
