//
//  LetterMatchingViewController.swift
//  Hancock
//
//  Created by Lauren  Matthews on 6/17/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//

import UIKit

class LetterMatchingViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    //setting up instruction label
    
    //setting up image views - named by row and column position - LM
    //Row one
    @IBOutlet weak var rowOneCardOneImageView: UIImageView!
    @IBOutlet weak var rowOneCardTwoImageView: UIImageView!
    @IBOutlet weak var rowOneCardThreeImageView: UIImageView!
    @IBOutlet weak var rowOneCardFourImageView: UIImageView!
    @IBOutlet weak var rowOneCardFiveImageView: UIImageView!
    //Row two
    @IBOutlet weak var rowTwoCardOneImageView: UIImageView!
    @IBOutlet weak var rowTwoCardTwoImageView: UIImageView!
    @IBOutlet weak var rowTwoCardThreeImageView: UIImageView!
    @IBOutlet weak var rowTwoCardFourImageView: UIImageView!
    @IBOutlet weak var rowTwoCardFiveImageView: UIImageView!
    //Row three
    @IBOutlet weak var rowThreeCardOneImageView: UIImageView!
    @IBOutlet weak var rowThreeCardTwoImageView: UIImageView!
    @IBOutlet weak var rowThreeCardThreeImageView: UIImageView!
    @IBOutlet weak var rowThreeCardFourImageView: UIImageView!
    @IBOutlet weak var rowThreeCardFiveImageView: UIImageView!
    //Row four
    @IBOutlet weak var rowFourCardOneImageView: UIImageView!
    @IBOutlet weak var rowFourCardTwoImageView: UIImageView!
    @IBOutlet weak var rowFourCardThreeImageView: UIImageView!
    @IBOutlet weak var rowFourCardFourImageView: UIImageView!
    @IBOutlet weak var rowFourCardFiveImageView: UIImageView!
    //Row five
    @IBOutlet weak var rowFiveCardOneImageView: UIImageView!
    @IBOutlet weak var rowFiveCardTwoImageView: UIImageView!
    @IBOutlet weak var rowFiveCardThreeImageView: UIImageView!
    @IBOutlet weak var rowFiveCardFourImageView: UIImageView!
    @IBOutlet weak var rowFiveCardFiveImageView: UIImageView!
    //instruction image
    @IBOutlet weak var instructionImageView: UIImageView!
    //end of image view set up
    
    //setting up Line Label
    @IBOutlet weak var lineLabel: UILabel!
    
    
    
    //tappedImage variable setup
    var tappedImage:UIImage? = nil
    
    //setting up image array using an image literal
    let letterMatchingArray = [ #imageLiteral(resourceName: "a-"), #imageLiteral(resourceName: "c-"), #imageLiteral(resourceName: "d-"), #imageLiteral(resourceName: "e-"), #imageLiteral(resourceName: "x-"), #imageLiteral(resourceName: "r-") ,#imageLiteral(resourceName: "b-"), #imageLiteral(resourceName: "f-"), #imageLiteral(resourceName: "g-"), #imageLiteral(resourceName: "h-.png"), #imageLiteral(resourceName: "i-"), #imageLiteral(resourceName: "j-.png"), #imageLiteral(resourceName: "k-.png"), #imageLiteral(resourceName: "l-.png"),#imageLiteral(resourceName: "m-.png"), #imageLiteral(resourceName: "n-"), #imageLiteral(resourceName: "o-.png"), #imageLiteral(resourceName: "p-.png"), #imageLiteral(resourceName: "q-.png"), #imageLiteral(resourceName: "t-.png"), #imageLiteral(resourceName: "s-.png"), #imageLiteral(resourceName: "u-.png"), #imageLiteral(resourceName: "v-.png"), #imageLiteral(resourceName: "w-.png"), #imageLiteral(resourceName: "y-.png"), #imageLiteral(resourceName: "z-.png"), #imageLiteral(resourceName: "A.png"), #imageLiteral(resourceName: "B.png"), #imageLiteral(resourceName: "C"), #imageLiteral(resourceName: "D.png"), #imageLiteral(resourceName: "E.png"), #imageLiteral(resourceName: "F.png"), #imageLiteral(resourceName: "G.png"), #imageLiteral(resourceName: "H.png"), #imageLiteral(resourceName: "I.png"), #imageLiteral(resourceName: "J.png"), #imageLiteral(resourceName: "K.png"), #imageLiteral(resourceName: "L.png"), #imageLiteral(resourceName: "M.png"), #imageLiteral(resourceName: "N.png"), #imageLiteral(resourceName: "O.png"), #imageLiteral(resourceName: "P.png"), #imageLiteral(resourceName: "Q.png"), #imageLiteral(resourceName: "R.png"), #imageLiteral(resourceName: "S.png"), #imageLiteral(resourceName: "T.png"), #imageLiteral(resourceName: "U.png"), #imageLiteral(resourceName: "V.png"), #imageLiteral(resourceName: "W.png"), #imageLiteral(resourceName: "X.png"), #imageLiteral(resourceName: "Y.png"), #imageLiteral(resourceName: "Z.png")]
    
    //Test "You Win" graphic
    @IBOutlet weak var youWinPic: UIImageView!
    
    //set up work item for delay
    var workItem1:DispatchWorkItem? = nil
    var workItem2:DispatchWorkItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set instruction label to show instruction image
        
        //end of image setup
        //resetting the opacity of the tapped image when reset is hit*/
        
        //set up array of image views
        instructionImageView.image =  letterMatchingArray.randomElement()
        youWinPic.isHidden = true
        
        //set up boolean to hide images on win condition
        
        
        
        let imageViews = [rowOneCardOneImageView, rowOneCardTwoImageView, rowOneCardThreeImageView, rowOneCardFourImageView, rowOneCardFiveImageView, rowTwoCardOneImageView, rowTwoCardTwoImageView, rowTwoCardThreeImageView, rowTwoCardFourImageView, rowTwoCardFiveImageView, rowThreeCardOneImageView, rowThreeCardTwoImageView, rowThreeCardThreeImageView, rowThreeCardFourImageView, rowThreeCardFiveImageView, rowFourCardOneImageView, rowFourCardTwoImageView, rowFourCardThreeImageView, rowFourCardFourImageView, rowFourCardFiveImageView, rowFiveCardOneImageView, rowFiveCardTwoImageView, rowFiveCardThreeImageView, rowFiveCardFourImageView, rowFiveCardFiveImageView]
        
        
        
        var imageViewsCopy = imageViews
        
        
        var tempImages = [UIImage]()
        
        for (index, imageView) in imageViews.enumerated(){
            imageView?.image = letterMatchingArray.randomElement()
            if imageView!.image == instructionImageView.image {
                tempImages.append(imageView!.image!)
                if index >= 0 && index < imageViewsCopy.count {
                    imageViewsCopy.remove(at: index)
                }
            }
        }
        
        let imageCount = tempImages.count
        var numberOfDuplicates = 3
        
        if imageCount < 3 {
            var count = numberOfDuplicates - imageCount
            for n in 0...count {
                let index = imageViewsCopy.indices.randomElement()
                imageViews[index!]!.image = instructionImageView.image
            }
        }
        
        // 2
        for  imageView in imageViews {
            // 3
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(matchTapped)
                
            )
            
            // 4
            tapGesture.delegate = self
            imageView?.addGestureRecognizer(tapGesture)
            imageView?.alpha = 1.00
            
        }
        
        
        
    }// End of ViewDidLoad
    
    @IBAction func backButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "mainMenu", sender: self)
    }
    
    
    @IBAction func resetTapped(_ sender: Any) {
        viewDidLoad()
        lineLabel.isHidden = false
        
        let imageViews = [rowOneCardOneImageView, rowOneCardTwoImageView, rowOneCardThreeImageView, rowOneCardFourImageView, rowOneCardFiveImageView, rowTwoCardOneImageView, rowTwoCardTwoImageView, rowTwoCardThreeImageView, rowTwoCardFourImageView, rowTwoCardFiveImageView, rowThreeCardOneImageView, rowThreeCardTwoImageView, rowThreeCardThreeImageView, rowThreeCardFourImageView, rowThreeCardFiveImageView, rowFourCardOneImageView, rowFourCardTwoImageView, rowFourCardThreeImageView, rowFourCardFourImageView, rowFourCardFiveImageView, rowFiveCardOneImageView, rowFiveCardTwoImageView, rowFiveCardThreeImageView, rowFiveCardFourImageView, rowFiveCardFiveImageView, instructionImageView]
        
        
        for imageView in imageViews {
            imageView?.isHidden = false
        }
    }
    
    
    @objc func matchTapped(__ sender: UITapGestureRecognizer) {
        
        let tappedImageView = sender.view as! UIImageView
        var winningImage = [UIImage]()
        var winningImageCount = winningImage.count
        var newTempImages = [UIImage]()
        var newTempImagesCount = newTempImages.count
        
        
        let imageViews = [rowOneCardOneImageView, rowOneCardTwoImageView, rowOneCardThreeImageView, rowOneCardFourImageView, rowOneCardFiveImageView, rowTwoCardOneImageView, rowTwoCardTwoImageView, rowTwoCardThreeImageView, rowTwoCardFourImageView, rowTwoCardFiveImageView, rowThreeCardOneImageView, rowThreeCardTwoImageView, rowThreeCardThreeImageView, rowThreeCardFourImageView, rowThreeCardFiveImageView, rowFourCardOneImageView, rowFourCardTwoImageView, rowFourCardThreeImageView, rowFourCardFourImageView, rowFourCardFiveImageView, rowFiveCardOneImageView, rowFiveCardTwoImageView, rowFiveCardThreeImageView, rowFiveCardFourImageView, rowFiveCardFiveImageView]
        
        print(sender.view!)
        print("I have been tapped")
        
        for _ in imageViews {
            if tappedImageView.image == instructionImageView.image {
                tappedImageView.image = #imageLiteral(resourceName: "Coin")
            }
            for _ in imageViews {
                if tappedImageView.image != instructionImageView.image {
                    tappedImageView.alpha = 0.10
                    print ("no")
                    
                    workItem1 = DispatchWorkItem{
                        //play the final narration
                        tappedImageView.alpha = 1.0
                        print("test")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute:self.workItem1!)
                }
            }
            
            for (index, imageView) in imageViews.enumerated(){
                if tappedImageView.image == instructionImageView.image {
                    winningImage.append(imageView!.image!)
                    
                }
                
                
            }
            
            for (index, imageView) in imageViews.enumerated(){
                if imageView!.image == instructionImageView.image {
                    newTempImages.append(imageView!.image!)
                    print("this works")
                }
            }
            
            if newTempImages.count == winningImage.count {
                print("you win")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55, execute:self.workItem2!)
            }
            workItem2 = DispatchWorkItem{
                self.youWinPic.isHidden = false
                //self.youWinPic.image = #imageLiteral(resourceName: "YouWin.png")
                self.lineLabel.isHidden = true
                
                let imageViews = [self.rowOneCardOneImageView, self.rowOneCardTwoImageView, self.rowOneCardThreeImageView, self.rowOneCardFourImageView, self.rowOneCardFiveImageView, self.rowTwoCardOneImageView, self.rowTwoCardTwoImageView, self.rowTwoCardThreeImageView, self.rowTwoCardFourImageView, self.rowTwoCardFiveImageView, self.rowThreeCardOneImageView, self.rowThreeCardTwoImageView, self.rowThreeCardThreeImageView, self.rowThreeCardFourImageView, self.rowThreeCardFiveImageView, self.rowFourCardOneImageView, self.rowFourCardTwoImageView, self.rowFourCardThreeImageView, self.rowFourCardFourImageView, self.rowFourCardFiveImageView,self.rowFiveCardOneImageView, self.rowFiveCardTwoImageView, self.rowFiveCardThreeImageView, self.rowFiveCardFourImageView, self.rowFiveCardFiveImageView, self.instructionImageView]
                
                
                for imageView in imageViews {
                    imageView?.isHidden = true
                }
                
            }
        }
        
    }//end of matchTapped
    
    
}//end of LetterMatchingViewController Class