//
//  FreeWriteViewController.swift
//  Hancock
//
//  Created by Jasmine Young on 7/1/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//

import UIKit

class FreeWriteViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var writingView: UIView!
    @IBOutlet weak var backgroundIV: UIImageView!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var paperTypeBtn1: UIButton!
    @IBOutlet weak var paperTypeBtn2: UIButton!
    @IBOutlet weak var paperTypeBtn3: UIButton!
    @IBOutlet weak var paperScaleBtn1: UIButton!
    @IBOutlet weak var paperScaleBtn2: UIButton!
    @IBOutlet weak var paperScaleBtn3: UIButton!
    @IBOutlet weak var penScaleBtn1: UIButton!
    @IBOutlet weak var penScaleBtn2: UIButton!
    @IBOutlet weak var penScaleBtn3: UIButton!
    @IBOutlet weak var penScaleBtn4: UIButton!
    private var paperNum: Int = 1
    private var paperScale: Int = 2
    private var didPressDone:Bool = false
    
        
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)

        // make button corners rounded
        doneBtn.layer.cornerRadius = 10
        // set border around current paper type, line scale, and pen scale
        paperTypeBtn1.layer.borderWidth = 4
        paperTypeBtn2.layer.borderWidth = 1
        paperTypeBtn3.layer.borderWidth = 1
        paperScaleBtn1.layer.borderWidth = 1
        paperScaleBtn2.layer.borderWidth = 4
        paperScaleBtn3.layer.borderWidth = 1
        penScaleBtn1.layer.borderWidth = 1
        penScaleBtn2.layer.borderWidth = 4
        penScaleBtn3.layer.borderWidth = 1
        penScaleBtn4.layer.borderWidth = 1

        
        // Canvas setup
        canvasView.backgroundColor = UIColor(white: 0.5, alpha: 0)
        //this enables autolayout for our canvas
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        writingView.heightAnchor.constraint(lessThanOrEqualToConstant: 1000).isActive = true
        writingView.widthAnchor.constraint(greaterThanOrEqualToConstant: 1000)
        backgroundIV.image = UIImage(named: "paper2")
        // added to stop line clearing after finger/pencil lifts
        canvasView.freeDraw = true
        canvasView.lineWidth = 10
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Don't forget to reset when view is being removed
        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    
    
    // MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard (touches.first?.location(in: canvasView)) != nil else { return }
        canvasView.drawTouches(touches, withEvent: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard (touches.first?.location(in: canvasView)) != nil else { return }
        canvasView.drawTouches(touches, withEvent: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard (touches.first?.location(in: canvasView)) != nil else { return }
        canvasView.drawTouches(touches, withEvent: event)
        canvasView.goodLine = true // stops the line width from changing the end of each line regardless of line's line width
        canvasView.endTouches(touches, cancel: false)
    }
    
    // MARK: - Actions
    @IBAction func changePaperPressed(_ sender: UIButton) {
        // if(sender.currentImage == #imageLiteral(resourceName: "paper2"))
        if(sender.currentTitle == "Paper1") {
            // provided paper (yellow/white)
            paperTypeBtn1.layer.borderWidth = 4
            paperTypeBtn2.layer.borderWidth = 1
            paperTypeBtn3.layer.borderWidth = 1
            paperNum = 1
            
            if(paperScale == 1)
            {
                paperScaleBtn1.layer.borderWidth = 4
                paperScaleBtn2.layer.borderWidth = 1
                paperScaleBtn3.layer.borderWidth = 1
                backgroundIV.image = UIImage(named: "paper1")
                paperScale = 1
            }
            else if(paperScale == 3)
            {
                paperScaleBtn1.layer.borderWidth = 1
                paperScaleBtn2.layer.borderWidth = 1
                paperScaleBtn3.layer.borderWidth = 4
                backgroundIV.image = UIImage(named: "paper3")
                paperScale = 3
            }
            else
            {
                paperScaleBtn1.layer.borderWidth = 1
                paperScaleBtn2.layer.borderWidth = 4
                paperScaleBtn3.layer.borderWidth = 1
                backgroundIV.image = UIImage(named: "paper2")
                paperScale = 2
            }
        }
        else if (sender.currentTitle == "Paper2") {
            // this could be taken out if unused
            paperTypeBtn1.layer.borderWidth = 1
            paperTypeBtn2.layer.borderWidth = 4
            paperTypeBtn3.layer.borderWidth = 1
            paperNum = 2
            if(paperScale == 1)
            {
                paperScaleBtn1.layer.borderWidth = 4
                paperScaleBtn2.layer.borderWidth = 1
                paperScaleBtn3.layer.borderWidth = 1
                backgroundIV.image = UIImage(named: "linedPaper1")
                paperScale = 1
            }
            else if(paperScale == 3)
            {
                paperScaleBtn1.layer.borderWidth = 1
                paperScaleBtn2.layer.borderWidth = 1
                paperScaleBtn3.layer.borderWidth = 4
                backgroundIV.image = UIImage(named: "linedPaper3")
                paperScale = 3
            }
            else
            {
                paperScaleBtn1.layer.borderWidth = 1
                paperScaleBtn2.layer.borderWidth = 4
                paperScaleBtn3.layer.borderWidth = 1
                backgroundIV.image = UIImage(named: "linedPaper2")
                paperScale = 2
            }
        }
        else if (sender.currentTitle == "Blank") {
            // white copy paper (no image)
            backgroundIV.image = UIImage(named: "blankPaper")
            paperTypeBtn1.layer.borderWidth = 1
            paperTypeBtn2.layer.borderWidth = 1
            paperTypeBtn3.layer.borderWidth = 4
            paperScaleBtn1.layer.borderWidth = 1
            paperScaleBtn2.layer.borderWidth = 1
            paperScaleBtn3.layer.borderWidth = 1
            paperNum = 3
            paperScale = 0
        }
        else {
            print("No Paper Button Title Match: \(sender.currentTitle)")
            backgroundIV.image = nil
        }
    }
    
    @IBAction func lineScalePressed(_ sender: UIButton) {
        // line scale is currently only used for paper type 1
        // if(sender.currentImage == #imageLiteral(resourceName: "UpperCase_Temp"))
        if(sender.currentTitle == "-") {
            // change background image
            if (paperNum == 1) {
                paperScaleBtn1.layer.borderWidth = 4
                paperScaleBtn2.layer.borderWidth = 1
                paperScaleBtn3.layer.borderWidth = 1
                backgroundIV.image = UIImage(named: "paper1")
            }
            else if (paperNum == 2) {
                paperScaleBtn1.layer.borderWidth = 4
                paperScaleBtn2.layer.borderWidth = 1
                paperScaleBtn3.layer.borderWidth = 1
                backgroundIV.image = UIImage(named: "linedPaper1")
            }
            paperScale = 1
        }
        else if (sender.currentTitle == "--") {
            if (paperNum == 1) {
                paperScaleBtn1.layer.borderWidth = 1
                paperScaleBtn2.layer.borderWidth = 4
                paperScaleBtn3.layer.borderWidth = 1
                backgroundIV.image = UIImage(named: "paper2")
            }
            else if (paperNum == 2) {
                paperScaleBtn1.layer.borderWidth = 1
                paperScaleBtn2.layer.borderWidth = 4
                paperScaleBtn3.layer.borderWidth = 1
                backgroundIV.image = UIImage(named: "linedPaper2")
            }
            paperScale = 2
        }
        else if (sender.currentTitle == "---") {
            if (paperNum == 1) {
                paperScaleBtn1.layer.borderWidth = 1
                paperScaleBtn2.layer.borderWidth = 1
                paperScaleBtn3.layer.borderWidth = 4
                backgroundIV.image = UIImage(named: "paper3")
            }
            else if (paperNum == 2) {
                paperScaleBtn1.layer.borderWidth = 1
                paperScaleBtn2.layer.borderWidth = 1
                paperScaleBtn3.layer.borderWidth = 4
                backgroundIV.image = UIImage(named: "linedPaper3")
            }
            paperScale = 3
        }
        else {
            print("No Scale Button Title Match: \(sender.currentTitle)")
            backgroundIV.image = nil
            canvasView.backgroundColor = UIColor.systemGray
        }
    }
    
    @IBAction func penLinePressed(_ sender: UIButton) {
        // pen linewidth probably needs size adjustments based on feedback
        // if(sender.currentImage == #imageLiteral(resourceName: "UpperCase_Temp"))
        if(sender.currentTitle == ".") {
            penScaleBtn1.layer.borderWidth = 4
            penScaleBtn2.layer.borderWidth = 1
            penScaleBtn3.layer.borderWidth = 1
            penScaleBtn4.layer.borderWidth = 1
            canvasView.lineWidth = 5
        }
        else if (sender.currentTitle == "..") {
            penScaleBtn1.layer.borderWidth = 1
            penScaleBtn2.layer.borderWidth = 4
            penScaleBtn3.layer.borderWidth = 1
            penScaleBtn4.layer.borderWidth = 1
            canvasView.lineWidth = 10
        }
        else if (sender.currentTitle == "...") {
            penScaleBtn1.layer.borderWidth = 1
            penScaleBtn2.layer.borderWidth = 1
            penScaleBtn3.layer.borderWidth = 4
            penScaleBtn4.layer.borderWidth = 1
            canvasView.lineWidth = 15
        }
        else if (sender.currentTitle == "....") {
            penScaleBtn1.layer.borderWidth = 1
            penScaleBtn2.layer.borderWidth = 1
            penScaleBtn3.layer.borderWidth = 1
            penScaleBtn4.layer.borderWidth = 4
            canvasView.lineWidth = 20
        }
        else {
            print("No Pen Button Title Match: \(sender.currentTitle)")
            canvasView.lineWidth = 20
        }
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        if(!didPressDone)
        {
            didPressDone = true
            
            var description = ""
            if(paperNum == 3)
            {
                description = "On Blank Paper"
            }
            else if(paperNum == 2)
            {
                if(paperScale == 1)
                {
                    description = "On Blue Lined Paper with Smallest Lines."
                }
                else if(paperScale == 2)
                {
                    description = "On Blue Lined Paper with Medium Lines."
                }
                else if(paperScale == 3)
                {
                    description = "On Blue Lined Paper with Largest Lines."
                }
            }
            else if(paperNum == 1)
            {
                if(paperScale == 1)
                {
                    description = "On Yellow/White Lined Paper with Smallest Lines."
                }
                else if(paperScale == 2)
                {
                    description = "On Yellow/White Lined Paper with Medium Lines."
                }
                else if(paperScale == 3)
                {
                    description = "On Yellow/White Lined Paper with Largest Lines."
                }
            }
            // done with writing so send data return to menu selection
            // this is a screenshot of the canvas view
            if let image = screenShot() {
                if let pngData = image.pngData() {
                    let base64String = pngData.base64EncodedString()
    //                 send character data to db with user credentials from login
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        var tempStorage = DecodeData()
                        
                        Service.updateImageData(localStorage: tempStorage, teacherName: ManagerSignInViewController().username, pin:  ManagerSignInViewController().pin, studenName: Service().currentStudent, session: 0, base64: base64String, title: "Free Draw", description: description)
                    })
                    print("Did screenshot Level4 and this is the pngData: \(pngData)")
    //                let fileName = getDocumentDirectory().appendingPathComponent("copy.png")
    //                try? pngData.write(to: fileName)
                    
                }
            }
            goBack()
        }
    }
    
    @IBAction func goBackPressed(_ sender: UIButton) {
        goBack()
    }
    
    @IBAction func clearPagePressed(_ sender: UIButton) {
        canvasView.clear()
    }
    
    // MARK: - Utilities
    private func screenShot() -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContext(canvasView.frame.size)
        canvasView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func goBack() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute:{
            self.dismiss(animated: false, completion: nil)
        })
    }
}
