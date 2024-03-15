//
//  LevelTwoViewController.swift
//  Hancock
//
//  Created by Jasmine Young on 6/17/20.
//  Copyright © 2020 Chris Ross. All rights reserved.
//

import UIKit
import AVKit // for the video player

class LevelTwoActivityViewController: UIViewController {
    
    // MARK: - Variables
    @IBOutlet weak var doneBtn: UIButton! // to return to level 2 menu
    @IBOutlet weak var letterLabel: UILabel! // shows the letter to draw
    @IBOutlet weak var letterAnimationView: UIView! // shows letter video
    @IBOutlet weak var replaySoundBtn: UIButton! // replay the video & audio
    @IBOutlet weak var writingView: UIView!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var canvasBGIV: UIImageView!
    @IBOutlet weak var resetCanvasBtn: UIButton! // clears lines from canvas
    @IBOutlet weak var letterIV: UIImageView! // to show gifs instead of videos
    private var audioPlayer = AVAudioPlayer() // for audio instructions
    private var videoPlayer = AVPlayer() // video player
    private var didPressDone = false
    var letterToDraw:String? // set in LevelTwoMenuVC in prepare: forSegue
    
    // MARK: - Dictionaries
    // TODO: Get videos and link them
    // dictionary to grab letter video
    private let letterAnimationDictionary = [
        "a":"aLower",
        "b":"bLower",
        "c":"cLower",
        "d":"dLower",
        "e":"eLower",
        "f":"fLower",
        "g":"gLower",
        "h":"hLower",
        "i":"iLower",
        "j":"jLower",
        "k":"kLower",
        "l":"lLower",
        "m":"mLower",
        "n":"nLower",
        "o":"oLower",
        "p":"pLower",
        "q":"qLower",
        "r":"rLower",
        "s":"sLower",
        "t":"tLower",
        "u":"uLower",
        "v":"vLower",
        "w":"wLower",
        "x":"xLower",
        "y":"yLower",
        "z":"zLower",
            "A":"A",
            "B":"B",
            "C":"C",
            "D":"D",
            "E":"E",
            "F":"F",
            "G":"G",
            "H":"H",
            "I":"I",
            "J":"J",
            "K":"K",
            "L":"L",
            "M":"M",
            "N":"N",
            "O":"O",
            "P":"P",
            "Q":"Q",
            "R":"R",
            "S":"S",
            "T":"T",
            "U":"U",
            "V":"V",
            "W":"W",
            "X":"X",
            "Y":"Y",
            "Z":"Z"]
    // dictionary to grab letter audio
    private let audioDictionary = [
        "a":"Gravel and Grass Walk",
        "b":"Gravel and Grass Walk",
        "c":"Gravel and Grass Walk",
        "d":"Gravel and Grass Walk",
        "e":"Gravel and Grass Walk",
        "f":"Gravel and Grass Walk",
        "g":"Gravel and Grass Walk",
        "h":"Gravel and Grass Walk",
        "i":"Gravel and Grass Walk",
        "j":"Gravel and Grass Walk",
        "k":"Gravel and Grass Walk",
        "l":"Gravel and Grass Walk",
        "m":"Gravel and Grass Walk",
        "n":"Gravel and Grass Walk",
        "o":"Gravel and Grass Walk",
        "p":"Gravel and Grass Walk",
        "q":"Gravel and Grass Walk",
        "r":"Gravel and Grass Walk",
        "s":"Gravel and Grass Walk",
        "t":"Gravel and Grass Walk",
        "u":"Gravel and Grass Walk",
        "v":"Gravel and Grass Walk",
        "w":"Gravel and Grass Walk",
        "x":"Gravel and Grass Walk",
        "y":"Gravel and Grass Walk",
        "z":"Gravel and Grass Walk",
            "A":"Gravel and Grass Walk",
            "B":"Gravel and Grass Walk",
            "C":"Gravel and Grass Walk",
            "D":"Gravel and Grass Walk",
            "E":"Gravel and Grass Walk",
            "F":"Gravel and Grass Walk",
            "G":"Gravel and Grass Walk",
            "H":"Gravel and Grass Walk",
            "I":"Gravel and Grass Walk",
            "J":"Gravel and Grass Walk",
            "K":"Gravel and Grass Walk",
            "L":"Gravel and Grass Walk",
            "M":"Gravel and Grass Walk",
            "N":"Gravel and Grass Walk",
            "O":"Gravel and Grass Walk",
            "P":"Gravel and Grass Walk",
            "Q":"Gravel and Grass Walk",
            "R":"Gravel and Grass Walk",
            "S":"Gravel and Grass Walk",
            "T":"Gravel and Grass Walk",
            "U":"Gravel and Grass Walk",
            "V":"Gravel and Grass Walk",
            "W":"Gravel and Grass Walk",
            "X":"Gravel and Grass Walk",
            "Y":"Gravel and Grass Walk",
            "Z":"Gravel and Grass Walk"]
    
    
    // MARK: - ViewDidLoad/Appear and Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //lock rotation
        AppDelegate.AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        if letterToDraw != nil {
            print("Setup Letter \(letterToDraw!)")
            // show letter to draw
            letterLabel.text = "Let's Draw \"\(letterToDraw!)\" Together!"
            //letterIV.isHidden = true
            //setUpVideo()
            setUpGif()
            //setUpAudio()
            
        }
        // make button corners rounded
       // doneBtn.layer.cornerRadius = 10
        replaySoundBtn.layer.cornerRadius = 10
        resetCanvasBtn.layer.cornerRadius = 10
        
        // Canvas setup
        canvasView.backgroundColor = UIColor(white: 0.5, alpha: 0)
        //this enables autolayout for our canvas
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        writingView.heightAnchor.constraint(lessThanOrEqualToConstant: 778).isActive = true
        //canvasBGIV.image = UIImage(named: "art.scnassets/UI-art/AntFace.png")
        // added to stop line clearing after finger/pencil lifts
        canvasView.freeDraw = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start the animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.letterIV.startAnimating()
        }
        
    }
    
    private func setUpVideo() {
        // find video name for letter
        guard let video = letterAnimationDictionary[letterToDraw!] else {
            print("No letterAnimationDictionary value for key \(letterToDraw!)")
            return
        }
        // find video path in the main bundle
        guard let path = Bundle.main.path(forResource: video, ofType: ".mp4") else {
            print("Could not find path for video")
            return
        }
        
        // create local url with the path
        let url = URL(fileURLWithPath: path)
        // assign AVPlayer to play the video
        videoPlayer = AVPlayer(url: url)
        // turn sound off of video to hear the audio
        videoPlayer.volume = 0.0
        // create a layer to put the player on so it doesn't take up the whole screen
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        // the the frame to the sized view in the storyboard
        playerLayer.frame = letterAnimationView.bounds
        // add the player layer to the sized view
        letterAnimationView.layer.addSublayer(playerLayer)
        // play the video
        videoPlayer.play()
    }
    
    private func setUpAudio() {
        // find audio name for letter
        guard let audio = audioDictionary[letterToDraw!] else {
            print("No audioDictionary value for key \(letterToDraw!)")
            return
        }
        // find audio path in the main bundle
        guard let path = Bundle.main.path(forResource: audio, ofType: "wav", inDirectory: "art.scnassets/Sounds") else {
            print("Could not find path for audio")
            return
        }
        do {
            // assign AVAudioPlayer to play the audio
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        }
        catch {
            print("Could not create AudioPlayer")
        }
        // play the audio
        self.audioPlayer.play()
    }
    
    private func setUpGif() {
        // find gif name for letter
        guard let image = letterAnimationDictionary[letterToDraw!] else {
            print("No letterAnimationDictionary value for key \(letterToDraw!)")
                return
        }
        // find and setup letter gif
        if let letterGif = UIImage.gif(name: image) {
        //if let letterGif = UIImage.gif(name:"Anthony-Chillaxing") {
            letterIV.image = letterGif.images?.last
            // Set the images from the UIImage
            letterIV.animationImages = letterGif.images
            // Set the duration of the UIImage
            letterIV.animationDuration = letterGif.duration
            // Set the repetitioncount
            letterIV.animationRepeatCount = 1
        }
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
        canvasView.endTouches(touches, cancel: false)
    }
    
    // MARK: - Actions
    @IBAction func replayVideo(_ sender: UIButton) {
        // if there is a current sound playing stop sound
//        if(audioPlayer.isPlaying)
//        {
//            audioPlayer.stop()
//        }
//        // set audio position time to zero and play
//        audioPlayer.currentTime = .zero
//        audioPlayer.play()
        
        // Start the animation
        letterIV.startAnimating()
        
        // set the player's video time position to zero and play
//        videoPlayer.seek(to: .zero)
//        videoPlayer.play()
    }
    
    @IBAction func resetCanvas(_ sender: UIButton) {
        // removes all lines from canvas view
        canvasView.clear()
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        if(!didPressDone)
        {
            didPressDone = true
            // done with letter so send data return to menu selection
            // this is a screenshot of the canvas view
            if let image = screenShot() {
                if let pngData = image.pngData() {
                    let base64String = pngData.base64EncodedString()
                    // send character data to db with user credentials from login
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                        Service.updateImageData(username: user, password: pass, base64: base64String, title: "Letter: \(self.letterToDraw!)", description: "In Letter Imitation")
                    })
                    print("Did screenshot Level2 and this is the pngData: \(pngData)")
                }
            }
            goBack()
        }
    }
    
    @IBAction func goBackPressed(_ sender: UIButton) {
        goBack()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute:{
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Don't forget to reset when view is being removed
//        AppDelegate.AppUtility.lockOrientation(.all)
    }
}
