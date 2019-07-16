//
//  activityViewController.swift
//  Hancock
//
//  Created by Chris Ross on 6/5/19.
//  Copyright © 2019 Chris Ross. All rights reserved.
//

//MARK: -- Known Issues
    /*
 
        1. User can touch the targetpoint and move on to next steps.
    */

//Mark: -- Current task
    /*
 Major task: Making the activities Modular
 minor tasks:
 
        1. Moving from step to step properly.
        2. load underlays from the activity selection class
        3. setupCanvas(), setupAUnderlay(), setupGreenlines(), setupDotsImages() need to be modular
    */
import UIKit

// MARK: - Game State
public var selectedActivity = ""

enum LetterState: Int16 {
    case AtoB
    case AtoC
    case DtoE
}

class activityViewController: UIViewController, UIPencilInteractionDelegate {
    
    // MARK: - VARIABLES
    
    private var useDebugDrawing = false
    public var activitySelection = ActivitySelection()
    
    private let reticleView: ReticleView = {
        let view = ReticleView(frame: CGRect.null)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    //New properties
    
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var antFace: UIImageView!
    
    //@IBOutlet weak var debugButton: UIButton!
    //@IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var forceLabel: UILabel!
    //@IBOutlet weak var azimuthAngleLabel: UILabel!
    //@IBOutlet weak var azimuthUnitVectorLabel: UILabel!
    //@IBOutlet weak var altitudeAngleLabel: UILabel!
    //@IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var grassImage: UIImageView!
    @IBOutlet weak var antChillImage: UIImageView!    
    
    //@IBOutlet private var gagueLabelCollection: [UILabel]!
    
    let AUnderlayView: UIImageView = {
        let AUnderlay = UIImage(named: "art.scnassets/LetterAImages/ABCGo-A-Underlay_Grey.png")
        let AUnderlayView = UIImageView(image: AUnderlay)
        //this enables autolayout for our AUnderlayView
        AUnderlayView.translatesAutoresizingMaskIntoConstraints = false
        return AUnderlayView
    }()
    let A1UnderlayView: UIImageView = {
        //Add the letter A1 image to the canvas
        let A1Underlay = UIImage(named: "art.scnassets/LetterAImages/ABCGo-A.1_GreyCracks.png")
        let A1UnderlayView = UIImageView(image: A1Underlay)
        //this enables autolayout for our AUnderlayView
        A1UnderlayView.translatesAutoresizingMaskIntoConstraints = false
        return A1UnderlayView
    }()
    let A2UnderlayView: UIImageView = {
        //Add the letter A2 image to the canvas
        let A2Underlay = UIImage(named: "art.scnassets/LetterAImages/ABCGo-A.2_GreyCracks.png")
        let A2UnderlayView = UIImageView(image: A2Underlay)
        //this enables autolayout for our A2UnderlayView
        A2UnderlayView.translatesAutoresizingMaskIntoConstraints = false
        return A2UnderlayView
    }()
    let A3UnderlayView: UIImageView = {
        //Add the letter A3 image to the canvas
        let A3Underlay = UIImage(named: "art.scnassets/LetterAImages/ABCGo-A.3_GreyCracks.png")
        let A3UnderlayView = UIImageView(image: A3Underlay)
        //this enables autolayout for our A3UnderlayView
        A3UnderlayView.translatesAutoresizingMaskIntoConstraints = false
        return A3UnderlayView
    }()
    let BlueDotView: UIImageView = {
        //Add the Blue Dot image to the canvas
        let BlueDot = UIImage(named: "art.scnassets/DotImages/BlueDot.png")
        let BlueDotView = UIImageView(image: BlueDot)
        //this enables autolayout for our BlueDotView
        BlueDotView.translatesAutoresizingMaskIntoConstraints = false
        return BlueDotView
    }()
    var GreenDotView: UIImageView = {
        //Add the Green Dot image to the canvas
        let GreenDot = UIImage(named: "art.scnassets/DotImages/GreenDot.png")
        let GreenDotView = UIImageView(image: GreenDot)
        //this enables autolayout for our GreenDotView
        GreenDotView.translatesAutoresizingMaskIntoConstraints = false
        return GreenDotView
    }()
    let OrangeDotView: UIImageView = {
        //Add the Orange Dot image to the canvas
        let OrangeDot = UIImage(named: "art.scnassets/DotImages/OrangeDot.png")
        let OrangeDotView = UIImageView(image: OrangeDot)
        //this enables autolayout for our OrangeDotView
        OrangeDotView.translatesAutoresizingMaskIntoConstraints = false
        return OrangeDotView
    }()
    let PurpleDotView: UIImageView = {
        //Add the Purple Dot image to the canvas
        let PurpleDot = UIImage(named: "art.scnassets/DotImages/PurpleDot.png")
        let PurpleDotView = UIImageView(image: PurpleDot)
        //this enables autolayout for our PurpleDotView
        PurpleDotView.translatesAutoresizingMaskIntoConstraints = false
        return PurpleDotView
    }()
    let RedDotView: UIImageView = {
        //Add the Red Dot image to the canvas
        let RedDot = UIImage(named: "art.scnassets/DotImages/RedDot.png")
        let RedDotView = UIImageView(image: RedDot)
        //this enables autolayout for our RedDotView
        RedDotView.translatesAutoresizingMaskIntoConstraints = false
        return RedDotView
    }()
    let YellowDotView: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let YellowDot = UIImage(named: "art.scnassets/DotImages/YellowDot.png")
        let YellowDotView = UIImageView(image: YellowDot)
        //this enables autolayout for our YellowDotView
        YellowDotView.translatesAutoresizingMaskIntoConstraints = false
        return YellowDotView
    }()
    
    
    //MARK: - ACTIONS
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        print(self)
    }
    //    @IBAction func undoButton(_ sender: Any) {
    //        canvasView.lines.removeAll()
    //        canvasView.checkpointLines.removeAll()
    //        canvasView.setNeedsDisplay()
    //    }
    
    //MARK: - VIEWDIDLOAD & SETUP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canvasView.addSubview(reticleView)
        
        //to toggle on on start, uncomment this line
        //toggleDebugDrawing(debugButton)
        
        clearGagues()
        
        if #available(iOS 12.0, *) {
            let pencilInteraction = UIPencilInteraction()
            pencilInteraction.delegate = self
            view.addInteraction(pencilInteraction)
        }
        
        setupCanvas()
        setupAUnderlay()
        setupGreenlines()
        loadActivity()
        
        
        //load animations
        antChillImage.loadGif(name: "Anthony-Chillaxing")
        grassImage.loadGif(name: "Grass-Blowing")
        
        antFace.isHidden = true
        
        //antChillImage.contentMode = .scaleAspectFit
        //antChillImage.backgroundColor = UIColor.lightGray
        //grassImage.contentMode = .scaleAspectFit
        //grassImage.backgroundColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("*** ViewWillAppear()")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            //play the pulsate animation for the first dot
            self.canvasView.greenDot?.pulsate()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                //play the pulsate animation for the second dot
                self.canvasView.redDot?.pulsate()
            })
        })
    }
    
    
    //MARK: -- Changes 1
    private func setupCanvas() {
        //Add the drawing canvas to the UIView
        //view.addSubview(canvas)
        canvasView.backgroundColor = UIColor(white: 0.5, alpha: 0)
        //canvasView.activityVC = self
        //this enables autolayout for our canvas
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        canvasView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        canvasView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        canvasView.heightAnchor.constraint(equalToConstant: 900).isActive = true
    }
    
    private func setupAUnderlay() {
        //Add the letter A underlay image to the UIView under the canvas
        view.insertSubview(AUnderlayView, belowSubview: canvasView)
        AUnderlayView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        AUnderlayView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor).isActive = true
        AUnderlayView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        AUnderlayView.heightAnchor.constraint(equalToConstant: 900).isActive = true
    }
    public func setupGreenlines() {
        //Add the letter A1 green line to the UIView under the canvas
        view.insertSubview(A1UnderlayView, belowSubview: canvasView)
        A1UnderlayView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        A1UnderlayView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor).isActive = true
        A1UnderlayView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        A1UnderlayView.heightAnchor.constraint(equalToConstant: 900).isActive = true
        A1UnderlayView.isHidden = true
        
        canvasView.A1GreenLine = A1UnderlayView
        
        //Add the letter A2 green line to the UIView under the canvas
        view.insertSubview(A2UnderlayView, belowSubview: canvasView)
        A2UnderlayView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        A2UnderlayView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor).isActive = true
        A2UnderlayView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        A2UnderlayView.heightAnchor.constraint(equalToConstant: 900).isActive = true
        A2UnderlayView.isHidden = true
        
        canvasView.A2GreenLine = A2UnderlayView
        
        //Add the letter A3 green line to the UIView under the canvas
        view.insertSubview(A3UnderlayView, belowSubview: canvasView)
        A3UnderlayView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        A3UnderlayView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor).isActive = true
        A3UnderlayView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        A3UnderlayView.heightAnchor.constraint(equalToConstant: 900).isActive = true
        A3UnderlayView.isHidden = true
        
        canvasView.A3GreenLine = A3UnderlayView
    }
    

    public func goBack() {
        
        //dismissItem.dismiss(animated: false, completion: nil)
        print("Go Back Was Called")
        print(self)
        //self.performSegue(withIdentifier: "Back To Scene", sender: self)
        //navigationController?.popToRootViewController(animated: true)
        //            navigationController?.popViewController(animated: true)
        //            dismiss(animated: true, completion: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //canvasView.drawTouches(touches, withEvent: event)
        guard let firstPoint = touches.first?.location(in: canvasView) else { return }
        print("Drawing in touchesBegan activityViewController")
        print("The distance to the startPoint: ", canvasView.CGPointDistance(from: firstPoint, to: startingPoint))
        print(startingPoint)
        print(targetPoint)
        
//        if !canvasView.AtoB {
//            //startingPoint = canvasView.aStartPoint
//            //targetPoint = canvasView.bStartPoint
//
//        }
//        if canvasView.AtoB {
//            //startingPoint = canvasView.aStartPoint
//            //targetPoint = canvasView.cStartPoint
//        }
//        if canvasView.AtoC {
//            //startingPoint = canvasView.dStartPoint
//            //targetPoint = canvasView.eStartPoint
//        }
        print("touches began")
        
        print("Startpoint= ", startingPoint)
        print("Targetpoint= ", targetPoint)
//        print("AtoB=", canvasView.AtoB)
//        print("AtoC=", canvasView.AtoC)
//        print("DtoE=", canvasView.DtoE)
        
        if canvasView.CGPointDistance(from: firstPoint, to: startingPoint) < 50 {
            // lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
            canvasView.goodTouch = true
            print("Touch was within 50 units")
            
            
            
            canvasView.drawTouches(touches, withEvent: event)
            touches.forEach { (touch) in updateGagues(with: touch)
                
                if useDebugDrawing, touch.type == .pencil {
                    reticleView.isHidden = false
                    updateReticleView(with: touch)
                    //separatorView.isHidden = true
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if canvasView.goodTouch {
            canvasView.drawTouches(touches, withEvent: event)
            
            //turn on feedback if the pencil angle is good
            if reticleView.actualAzimuthAngle >= 0 && reticleView.actualAzimuthAngle <= 1 {
                self.antFace.isHidden = false
            }
            else {
                self.antFace.isHidden = true
            }
            
            touches.forEach { (touch) in
                updateGagues(with: touch)
                
                if useDebugDrawing, touch.type == .pencil {
                    updateReticleView(with: touch)
                    
                    guard let predictedTouch = event?.predictedTouches(for: touch)?.last else { return }
                    
                    updateReticleView(with: predictedTouch, isPredicted: true)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //turn off feedback
        self.antFace.isHidden = true
        
        canvasView.drawTouches(touches, withEvent: event)
        canvasView.endTouches(touches, cancel: false)
        canvasView.goodTouch = false
        
        guard let lastPoint = touches.first?.location(in: canvasView) else { return }
        
        touches.forEach { (touch) in
            clearGagues()
            
            if useDebugDrawing, touch.type == .pencil {
                reticleView.isHidden = true
                //separatorView.isHidden = true
            }
        }
        
        if canvasView.DtoE == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            clearGagues()
            
            if useDebugDrawing, touch.type == .pencil {
                reticleView.isHidden = true
            }
        }
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        canvasView.updateEstimatedPropertiesForTouches(touches)
    }
    
    //MARK: Actions
    
    @IBAction func clearView(_ sender: Any) {
        canvasView.clear()
    }
    
    @IBAction func toggleDebugDrawing(_ sender: UIButton) {
        canvasView.isDebuggingEnabled = !canvasView.isDebuggingEnabled
        useDebugDrawing.toggle()
        sender.isSelected = canvasView.isDebuggingEnabled
    }
    
    @IBAction func toggleUsePreciseLocations(_ sender: UIButton) {
        canvasView.usePreciseLocations = !canvasView.usePreciseLocations
        sender.isSelected = canvasView.usePreciseLocations
    }
    
    //MARK: Convenience
    
    /// - Tag: PencilProperties
    
    private func updateReticleView(with touch: UITouch, isPredicted: Bool = false){
        guard touch.type == .pencil else { return }
        
        reticleView.predictedDotLayer.isHidden = !isPredicted
        reticleView.predictedLineLayer.isHidden = !isPredicted
        
        let azimuthAngle = touch.azimuthAngle(in: canvasView)
        let azimuthUnitVector = touch.azimuthUnitVector(in: canvasView)
        let altitudeAngle = touch.altitudeAngle
        
        if isPredicted {
            reticleView.predictedAzimuthAngle = azimuthAngle
            reticleView.predictedAzimuthUnitVector = azimuthUnitVector
            reticleView.predictedAltitudeAngle = altitudeAngle
        } else {
            let location = touch.preciseLocation(in: canvasView)
            reticleView.center = location
            reticleView.actualAzimuthAngle = azimuthAngle
            reticleView.actualAzimuthUnitVector = azimuthUnitVector
            reticleView.actualAltitudeAngle  = altitudeAngle
        }
    }
    
    private func updateGagues(with touch: UITouch) {
        //forceLabel.text = touch.force.valueFormattedForDisplay ?? ""
        
        //let azimuthUnitVector = touch.azimuthUnitVector(in: canvasView)
        //azimuthUnitVectorLabel.text = azimuthUnitVector.valueFormattedForDisplay ?? ""
        
        //let azimuthAngle = touch.azimuthAngle(in: canvasView)
        //azimuthAngleLabel.text = azimuthAngle.valueFormattedForDisplay ?? ""
        
        //altitudeAngleLabel.text = touch.altitudeAngle.valueFormattedForDisplay ?? ""
        
    }
    
    private func clearGagues() {
//        gagueLabelCollection.forEach { (label) in
//            label.text = ""
//        }
    }
    
    @available(iOS 12.0, *)
    func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        guard UIPencilInteraction.preferredTapAction == .switchPrevious else { return }
        
        //toggleDebugDrawing(debugButton)
    }
    
    private func loadActivity(){
        switch selectedActivity {
        case "A":
            activitySelection.loadActivityA()
        case "B":
            activitySelection.loadActivityB()
        default: return
            
            }
        }
    
    }
