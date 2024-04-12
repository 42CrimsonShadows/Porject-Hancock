
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


public var totalCoins = 0
public var startTime = Date()

enum LetterState: Int16 {
    case P1_P2 //first line
    case P3_P4 //second
    case P5_P6 //third
    case P7_P8 //fourth
    case P9_P10//fifth
}

class activityViewController: UIViewController, UIPencilInteractionDelegate {
    
    // MARK: - VARIABLES
    
    private var useDebugDrawing = false
    public var activitySelection = ActivitySelection()
    private var letterCoins: Int32 = 0
    // total coins user can get on letter
    public var coinsPossible: Int32 = 0
    private var canDraw = true
    
    // Properties for tracking off-path touches
    private var isCurrentlyOffPath = false
    private var offPathCount: Int32 = 0
    private var offPathImage: String = ""
    private var offPathLocations = [CGPoint]()
    private var hasGoneOffPath = false;
    
    private let reticleView: ReticleView = {
        let view = ReticleView(frame: CGRect.null)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    //New properties
    //@IBOutlet weak var debugButton: UIButton!
    //@IBOutlet weak var locationLabel: UILabel!
    //@IBOutlet weak var forceLabel: UILabel!
    //@IBOutlet weak var azimuthAngleLabel: UILabel!
    //@IBOutlet weak var azimuthUnitVectorLabel: UILabel!
    //@IBOutlet weak var altitudeAngleLabel: UILabel!
    //@IBOutlet weak var separatorView: UIView!
    
    //@IBOutlet private var gagueLabelCollection: [UILabel]!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var antFace: UIImageView!
    @IBOutlet weak var grassImage: UIImageView!
    @IBOutlet weak var antChillImage: UIImageView!
    @IBOutlet weak var CoinCountLabel: UILabel!
    
    //LMTest
    @IBOutlet weak var testImage: UIImageView! //LM
    
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
    let PinkDotView: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let PinkDot = UIImage(named: "art.scnassets/DotImages/PinkDot.png")
        let PinkDotView = UIImageView(image: PinkDot)
        //this enables autolayout for our YellowDotView
        PinkDotView.translatesAutoresizingMaskIntoConstraints = false
        return PinkDotView
    }()
    let WhiteDotView: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let WhiteDot = UIImage(named: "art.scnassets/DotImages/WhiteDot.png")
        let WhiteDotView = UIImageView(image: WhiteDot)
        //this enables autolayout for our YellowDotView
        WhiteDotView.translatesAutoresizingMaskIntoConstraints = false
        return WhiteDotView
    }()
    let Blue2DotView: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let Blue2Dot = UIImage(named: "art.scnassets/DotImages/BlueDot.png")
        let Blue2DotView = UIImageView(image: Blue2Dot)
        //this enables autolayout for our YellowDotView
        Blue2DotView.translatesAutoresizingMaskIntoConstraints = false
        return Blue2DotView
    }()
    let Orange2DotView: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let Orange2Dot = UIImage(named: "art.scnassets/DotImages/OrangeDot.png")
        let Orange2DotView = UIImageView(image: Orange2Dot)
        //this enables autolayout for our YellowDotView
        Orange2DotView.translatesAutoresizingMaskIntoConstraints = false
        return Orange2DotView
    }()
    var purple2DotView: UIImageView = {
        //Add the Green Dot image to the canvas
        let purple2Dot = UIImage(named: "art.scnassets/DotImages/PurpleDot.png")
        let purple2DotView = UIImageView(image: purple2Dot)
        //this enables autolayout for our GreenDotView
        purple2DotView.translatesAutoresizingMaskIntoConstraints = false
        return purple2DotView
    }()
    let yellow2DotView: UIImageView = {
        //Add the Red Dot image to the canvas
        let yellow2Dot = UIImage(named: "art.scnassets/DotImages/YellowDot.png")
        let yellow2DotView = UIImageView(image: yellow2Dot)
        //this enables autolayout for our RedDotView
        yellow2DotView.translatesAutoresizingMaskIntoConstraints = false
        return yellow2DotView
    }()
    let BlackDotView1: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot1 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView1 = UIImageView(image: BlackDot1)
        //this enables autolayout for our YellowDotView
        BlackDotView1.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView1
    }()
    let BlackDotView2: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot2 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView2 = UIImageView(image: BlackDot2)
        //this enables autolayout for our YellowDotView
        BlackDotView2.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView2
    }()
    let BlackDotView3: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot3 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView3 = UIImageView(image: BlackDot3)
        //this enables autolayout for our YellowDotView
        BlackDotView3.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView3
    }()
    let BlackDotView4: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot4 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView4 = UIImageView(image: BlackDot4)
        //this enables autolayout for our YellowDotView
        BlackDotView4.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView4
    }()
    let BlackDotView5: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot5 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView5 = UIImageView(image: BlackDot5)
        //this enables autolayout for our YellowDotView
        BlackDotView5.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView5
    }()
    let BlackDotView6: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot6 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView6 = UIImageView(image: BlackDot6)
        //this enables autolayout for our YellowDotView
        BlackDotView6.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView6
    }()
    let BlackDotView7: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot7 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView7 = UIImageView(image: BlackDot7)
        //this enables autolayout for our YellowDotView
        BlackDotView7.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView7
    }()
    let BlackDotView8: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot8 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView8 = UIImageView(image: BlackDot8)
        //this enables autolayout for our YellowDotView
        BlackDotView8.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView8
    }()
    let BlackDotView9: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot9 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView9 = UIImageView(image: BlackDot9)
        //this enables autolayout for our YellowDotView
        BlackDotView9.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView9
    }()
    let BlackDotView10: UIImageView = {
        //Add the Yellow Dot image to the canvas
        let BlackDot10 = UIImage(named: "art.scnassets/UI-art/AnthonyCoin.png")
        let BlackDotView10 = UIImageView(image: BlackDot10)
        //this enables autolayout for our YellowDotView
        BlackDotView10.translatesAutoresizingMaskIntoConstraints = false
        return BlackDotView10
    }()
    
    let animationDictionary = [
        "lowercaseA":"ch6_a"
    ]
    
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
        //AppDelegate.AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
        canvasView.addSubview(reticleView)
        
        
        //to toggle on on start, uncomment this line
        //toggleDebugDrawing(debugButton)
        
        clearGagues()
        
        if #available(iOS 12.0, *) {
            let pencilInteraction = UIPencilInteraction()
            pencilInteraction.delegate = self
            view.addInteraction(pencilInteraction)
        }
        
        hasGoneOffPath = false
        
        setupCoinLabel()
        setupCanvas()
        //setupGreenlines() ----- For setting up letter craked images to be shown/hidden
        loadActivity()
        setupUnderlay()
        setupDotsImages()
        setupMiddleDots()
        
        //load animations
        // antChillImage.loadGif(name: "Anthony-Chillaxing") //can be set to different images for different chapters
        //  grassImage.loadGif(name: "Grass-Blowing")
        
        antFace.isHidden = true
        
        //antChillImage.contentMode = .scaleAspectFit
        //antChillImage.backgroundColor = UIColor.lightGray
        //grassImage.contentMode = .scaleAspectFit
        //grassImage.backgroundColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("*** ViewWillAppear()")
        
        //set the first line active
        canvasView.Line1 = true
        canvasView.Line2 = false
        canvasView.Line3 = false
        canvasView.Line4 = false
        canvasView.Line5 = false
        
        testImage.alpha = 0.90
        
        //FIXME: if the chapter is one of the line chapters play the first narration
        if (selectedActivity == "-" || selectedActivity == "/" || selectedActivity == "|" || selectedActivity == "'\'" || selectedActivity == "cross+" || selectedActivity == "crossx" || selectedActivity == "square" || selectedActivity == "circle" || selectedActivity == "triangle"){
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.canvasView.playAudioNarrationFile(file: chapterSelectedSoundDict!["GreenToRed"]!, type: "mp3")
            })
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            //play the pulsate animation for the first dot
            self.canvasView.greenDot?.pulsate(duration: 0.6)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                //play the pulsate animation for the second dot
                self.canvasView.redDot?.pulsate(duration: 0.6)
            })
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        // AppDelegate.AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
    }
    
    
    //MARK: -- Changes 1
    private func setupCanvas() {
        //Add the drawing canvas to the UIView
        //view.addSubview(canvas)
        canvasView.backgroundColor = UIColor(white: 0.5, alpha: 0)
        //this enables autolayout for our canvas
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        print(view.center)
        print(canvasView.center)
        canvasView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        canvasView.widthAnchor.constraint(equalToConstant: 600).isActive = true
        canvasView.heightAnchor.constraint(equalToConstant: 900).isActive = true
        
        view.layoutIfNeeded()
    }
    
    private func setupUnderlay() {
        //Add the letter A underlay image to the UIView under the canvas
        view.insertSubview(letterUnderlay, belowSubview: canvasView)
        letterUnderlay.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
        letterUnderlay.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor).isActive = true
        letterUnderlay.widthAnchor.constraint(equalToConstant: 600).isActive = true
        letterUnderlay.heightAnchor.constraint(equalToConstant: 900).isActive = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("Canvas Center: \(canvasView.center)")
        print("Underlay Center: \(letterUnderlay.center)")
    }
    
    //    public func setupGreenlines() {
    //        //Add the letter A1 green line to the UIView under the canvas
    //        view.insertSubview(A1UnderlayView, belowSubview: canvasView)
    //        A1UnderlayView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
    //        A1UnderlayView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor).isActive = true
    //        A1UnderlayView.widthAnchor.constraint(equalToConstant: 600).isActive = true
    //        A1UnderlayView.heightAnchor.constraint(equalToConstant: 900).isActive = true
    //        A1UnderlayView.isHidden = true
    //
    //        canvasView.A1GreenLine = A1UnderlayView
    //
    //        //Add the letter A2 green line to the UIView under the canvas
    //        view.insertSubview(A2UnderlayView, belowSubview: canvasView)
    //        A2UnderlayView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
    //        A2UnderlayView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor).isActive = true
    //        A2UnderlayView.widthAnchor.constraint(equalToConstant: 600).isActive = true
    //        A2UnderlayView.heightAnchor.constraint(equalToConstant: 900).isActive = true
    //        A2UnderlayView.isHidden = true
    //
    //        canvasView.A2GreenLine = A2UnderlayView
    //
    //        //Add the letter A3 green line to the UIView under the canvas
    //        view.insertSubview(A3UnderlayView, belowSubview: canvasView)
    //        A3UnderlayView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor).isActive = true
    //        A3UnderlayView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor).isActive = true
    //        A3UnderlayView.widthAnchor.constraint(equalToConstant: 600).isActive = true
    //        A3UnderlayView.heightAnchor.constraint(equalToConstant: 900).isActive = true
    //        A3UnderlayView.isHidden = true
    //
    //        canvasView.A3GreenLine = A3UnderlayView
    //    }
    
    
    
    
    public func setupDotsImages() {
        var greenDot1 = CGPoint(x: 600 * activityPoints[0][0], y: 900 * activityPoints[0][1])
        var redDot2 = CGPoint(x: 600 * activityPoints[3][0], y: 900 * activityPoints[3][1])
        var blueDot4: CGPoint?
        var orangeDot5: CGPoint?
        var purpleDot6: CGPoint?
        var yellowDot7: CGPoint?
        //        var PinkDot8: CGPoint?
        //        var WhiteDot9: CGPoint?
        var blueDot8: CGPoint?
        var orangeDot9: CGPoint?
        var purpleDot10: CGPoint?
        var yellowDot11: CGPoint?
        
        let dotArraySize = activityPoints.count
        
        //if there is more than one line...
        if dotArraySize > 4 {
            blueDot4 = CGPoint(x: 600 * activityPoints[4][0], y: 900 * activityPoints[4][1])
            orangeDot5 = CGPoint(x: 600 * activityPoints[7][0], y: 900 * activityPoints[7][1])
            
            //if there is more than two lines
            if dotArraySize > 8 {
                yellowDot7 = CGPoint(x: 600 * activityPoints[8][0], y: 900 * activityPoints[8][1])
                purpleDot6 = CGPoint(x: 600 * activityPoints[11][0], y: 900 * activityPoints[11][1])
                
                //if there is more than three lines
                if dotArraySize > 12 {
                    blueDot8 = CGPoint(x: 600 * activityPoints[12][0], y: 900 * activityPoints[12][1])
                    orangeDot9 = CGPoint(x: 600 * activityPoints[15][0], y: 900 * activityPoints[15][1])
                    //if there is more than four lines
                    if dotArraySize > 16 {
                        yellowDot11 = CGPoint(x: 600 * activityPoints[16][0], y: 900 * activityPoints[16][1])
                        purpleDot10 = CGPoint(x: 600 * activityPoints[19][0], y: 900 * activityPoints[19][1])
                        
                        
                    }
                    
                }
            }
        }
        //Set up GREEN dot
        view.insertSubview(GreenDotView, belowSubview: canvasView)
        GreenDotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: greenDot1.x).isActive = true
        GreenDotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: greenDot1.y).isActive = true
        GreenDotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        GreenDotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        GreenDotView.isHidden = true
        canvasView.greenDot = GreenDotView
        
        //Set up RED dot
        view.insertSubview(RedDotView, belowSubview: canvasView)
        RedDotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: redDot2.x).isActive = true
        RedDotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: redDot2.y).isActive = true
        RedDotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        RedDotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        RedDotView.isHidden = true
        canvasView.redDot = RedDotView
        
        //Set up BLUE dot
        view.insertSubview(BlueDotView, belowSubview: canvasView)
        BlueDotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant:  blueDot4?.x ?? 0).isActive = true
        BlueDotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: blueDot4?.y ?? 0).isActive = true
        BlueDotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        BlueDotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        BlueDotView.isHidden = true
        canvasView.blueDot = BlueDotView
        
        //Set up Orange dot
        view.insertSubview(OrangeDotView, belowSubview: canvasView)
        OrangeDotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: orangeDot5?.x ?? 0).isActive = true
        OrangeDotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: orangeDot5?.y ?? 0).isActive = true
        OrangeDotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        OrangeDotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        OrangeDotView.isHidden = true
        canvasView.orangeDot = OrangeDotView
        
        //Set up PURPLE dot
        view.insertSubview(PurpleDotView, belowSubview: canvasView)
        PurpleDotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: purpleDot6?.x ?? 0).isActive = true
        PurpleDotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: purpleDot6?.y ?? 0).isActive = true
        PurpleDotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        PurpleDotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        PurpleDotView.isHidden = true
        canvasView.purpleDot = PurpleDotView
        
        //Set up Yellow dot
        view.insertSubview(YellowDotView, belowSubview: canvasView)
        YellowDotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: yellowDot7?.x ?? 0).isActive = true
        YellowDotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: yellowDot7?.y ?? 0).isActive = true
        YellowDotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        YellowDotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        YellowDotView.isHidden = true
        canvasView.yellowDot = YellowDotView
        
        //Set up Pink dot
        //        view.insertSubview(PinkDotView, belowSubview: canvasView)
        //        PinkDotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: PinkDot8?.x ?? 0).isActive = true
        //        PinkDotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: PinkDot8?.y ?? 0).isActive = true
        //        PinkDotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //        PinkDotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //        PinkDotView.isHidden = true
        //        canvasView.pinkDot = PinkDotView
        
        //set up white dot
        //        view.insertSubview(WhiteDotView, belowSubview: canvasView)
        //        WhiteDotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: WhiteDot9?.x ?? 0).isActive = true
        //        WhiteDotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: WhiteDot9?.y ?? 0).isActive = true
        //        WhiteDotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //        WhiteDotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //        WhiteDotView.isHidden = true
        //        canvasView.whiteDot = WhiteDotView
        
        //Set up BLUE2 dot
        view.insertSubview(Blue2DotView, belowSubview: canvasView)
        Blue2DotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant:  blueDot8?.x ?? 0).isActive = true
        Blue2DotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: blueDot8?.y ?? 0).isActive = true
        Blue2DotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        Blue2DotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        Blue2DotView.isHidden = true
        canvasView.blue2Dot = Blue2DotView
        
        //Set up Orange2 dot
        view.insertSubview(Orange2DotView, belowSubview: canvasView)
        Orange2DotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: orangeDot9?.x ?? 0).isActive = true
        Orange2DotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: orangeDot9?.y ?? 0).isActive = true
        Orange2DotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        Orange2DotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        Orange2DotView.isHidden = true
        canvasView.orange2Dot = Orange2DotView
        
        //Set up purple2 dot
        view.insertSubview(purple2DotView, belowSubview: canvasView)
        purple2DotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: purpleDot10?.x ?? 0).isActive = true
        purple2DotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: purpleDot10?.y ?? 0).isActive = true
        purple2DotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        purple2DotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        purple2DotView.isHidden = true
        canvasView.purple2Dot = purple2DotView
        
        //Set up yellow2 dot
        view.insertSubview(yellow2DotView, belowSubview: canvasView)
        yellow2DotView.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: yellowDot11?.x ?? 0).isActive = true
        yellow2DotView.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: yellowDot11?.y ?? 0).isActive = true
        yellow2DotView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        yellow2DotView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        yellow2DotView.isHidden = true
        canvasView.yellow2Dot = yellow2DotView
    }
    
    public func setupMiddleDots(){
        print("******Setting up Middle Dots*******")
        
        var coin1 = CGPoint(x: 600 * activityPoints[1][0], y: 900 * activityPoints[1][1])
        var coin2 = CGPoint(x: 600 * activityPoints[2][0], y: 900 * activityPoints[2][1])
        var coin3: CGPoint?
        var coin4: CGPoint?
        var coin5: CGPoint?
        var coin6: CGPoint?
        var coin7: CGPoint?
        var coin8: CGPoint?
        var coin9: CGPoint?
        var coin10: CGPoint?
        
        let coinArraySize = activityPoints.count
        
        //if there is more than one line...
        if coinArraySize > 4 {
            coin3 = CGPoint(x: 600 * activityPoints[5][0], y: 900 * activityPoints[5][1])
            coin4 = CGPoint(x: 600 * activityPoints[6][0], y: 900 * activityPoints[6][1])
            
            //if there is more than two lines
            if coinArraySize > 8 {
                coin5 = CGPoint(x: 600 * activityPoints[9][0], y: 900 * activityPoints[9][1])
                coin6 = CGPoint(x: 600 * (activityPoints[10][0]), y: 900 * activityPoints[10][1])
                
                //if there is more than three lines
                if coinArraySize > 12 {
                    coin7 = CGPoint(x: 600 * activityPoints[13][0], y: 900 * activityPoints[13][1])
                    coin8 = CGPoint(x: 600 * activityPoints[14][0], y: 900 * activityPoints[14][1])
                    //if there is more than four lines
                    if coinArraySize > 16 {
                        coin9 = CGPoint(x: 600 * activityPoints[17][0], y: 900 * activityPoints[17][1])
                        coin10 = CGPoint(x: 600 * activityPoints[18][0], y: 900 * activityPoints[18][1])
                    }
                }
            }
        }
        
        //set up black dot 1
        view.insertSubview(BlackDotView1, belowSubview: canvasView)
        BlackDotView1.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin1.x).isActive = true
        BlackDotView1.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin1.y).isActive = true
        BlackDotView1.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView1.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView1.isHidden = true
        canvasView.blackDot1 = BlackDotView1
        
        //set up black dot 2
        view.insertSubview(BlackDotView2, belowSubview: canvasView)
        BlackDotView2.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin2.x).isActive = true
        BlackDotView2.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin2.y).isActive = true
        BlackDotView2.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView2.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView2.isHidden = true
        canvasView.blackDot2 = BlackDotView2
        
        //set up black dot 3
        view.insertSubview(BlackDotView3, belowSubview: canvasView)
        BlackDotView3.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin3?.x ?? 0).isActive = true
        BlackDotView3.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin3?.y ?? 0).isActive = true
        BlackDotView3.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView3.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView3.isHidden = true
        canvasView.blackDot3 = BlackDotView3
        
        //set up black dot 4
        view.insertSubview(BlackDotView4, belowSubview: canvasView)
        BlackDotView4.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin4?.x ?? 0).isActive = true
        BlackDotView4.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin4?.y ?? 0).isActive = true
        BlackDotView4.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView4.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView4.isHidden = true
        canvasView.blackDot4 = BlackDotView4
        
        //set up black dot 5
        view.insertSubview(BlackDotView5, belowSubview: canvasView)
        BlackDotView5.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin5?.x ?? 0).isActive = true
        BlackDotView5.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin5?.y ?? 0).isActive = true
        BlackDotView5.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView5.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView5.isHidden = true
        canvasView.blackDot5 = BlackDotView5
        
        //set up black dot 6
        view.insertSubview(BlackDotView6, belowSubview: canvasView)
        BlackDotView6.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin6?.x ?? 0).isActive = true
        BlackDotView6.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin6?.y ?? 0).isActive = true
        BlackDotView6.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView6.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView6.isHidden = true
        canvasView.blackDot6 = BlackDotView6
        
        //set up black dot 7
        view.insertSubview(BlackDotView7, belowSubview: canvasView)
        BlackDotView7.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin7?.x ?? 0).isActive = true
        BlackDotView7.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin7?.y ?? 0).isActive = true
        BlackDotView7.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView7.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView7.isHidden = true
        canvasView.blackDot7 = BlackDotView7
        
        //set up black dot 8
        view.insertSubview(BlackDotView8, belowSubview: canvasView)
        BlackDotView8.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin8?.x ?? 0).isActive = true
        BlackDotView8.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin8?.y ?? 0).isActive = true
        BlackDotView8.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView8.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView8.isHidden = true
        canvasView.blackDot8 = BlackDotView8
        
        //set up black dot 9
        view.insertSubview(BlackDotView9, belowSubview: canvasView)
        BlackDotView9.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin9?.x ?? 0).isActive = true
        BlackDotView9.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin9?.y ?? 0).isActive = true
        BlackDotView9.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView9.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView9.isHidden = true
        canvasView.blackDot9 = BlackDotView9
        
        //set up black dot 10
        view.insertSubview(BlackDotView10, belowSubview: canvasView)
        BlackDotView10.centerXAnchor.constraint(equalTo: canvasView.leftAnchor, constant: coin10?.x ?? 0).isActive = true
        BlackDotView10.centerYAnchor.constraint(equalTo: canvasView.topAnchor, constant: coin10?.y ?? 0).isActive = true
        BlackDotView10.widthAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView10.heightAnchor.constraint(equalToConstant: 25).isActive = true
        BlackDotView10.isHidden = true
        canvasView.blackDot10 = BlackDotView10
    }
    
    func setupCoinLabel() {
        CoinCountLabel.text = "X \(totalCoins)"
    }
    
    func goBack() {
        
        //dismissItem.dismiss(animated: false, completion: nil)
        print("Go Back Was Called")
        //self.performSegue(withIdentifier: "Back To Scene", sender: self)
        //navigationController?.popToRootViewController(animated: true)
        //navigationController?.popViewController(animated: true)
        //dismiss(animated: true, completion: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(canDraw)
        {
            //canvasView.drawTouches(touches, withEvent: event)
            guard let firstPoint = touches.first?.location(in: canvasView) else { return }
            
            print("The distance to the startPoint: ", canvasView.CGPointDistance(from: firstPoint, to: startingPoint))
            print("My Touch Location = CGpointX", firstPoint.x / canvasView.bounds.maxX, "and CGpointY", firstPoint.y / canvasView.bounds.maxY)
            
            if canvasView.CGPointDistance(from: firstPoint, to: startingPoint) < 25 {
                // lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
                canvasView.goodTouch = true
                print("Touch was within 25 units")
                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing1"]!, type: "mp3")
                
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
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(canDraw)
        {
            if canvasView.goodTouch {
                canvasView.drawTouches(touches, withEvent: event)
                
                //turn on feedback if the pencil angle is good
                if reticleView.actualAzimuthAngle >= 0 && reticleView.actualAzimuthAngle <= 1 {
                    self.antFace.isHidden = false
                }
                else {
                    self.antFace.isHidden = true
                }
                
                //each time we move the touch...
                touches.forEach {(touch) in
                                       
                    //check to see if we interact with coins
                    if canvasView.Line1 == true {
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint1) < 25 {
                            if canvasView.coin1Collected == false {
                                canvasView.coin1Collected = true
                                canvasView.blackDot1?.isHidden = true
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                print("***DINGDING***")
                                //TODO: add one to the Coin tally
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing2"]!, type: "mp3")
                                
                            }
                        }
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint2) < 25 {
                            if canvasView.coin2Collected == false {
                                canvasView.coin2Collected = true
                                canvasView.blackDot2?.isHidden = true
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                print("***DINGDING***")
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing3"]!, type: "mp3")
                            }
                        }
                    }
                    //**************
                    if canvasView.Line2 == true {
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint1) < 25 {
                            if canvasView.coin1Collected == false {
                                canvasView.coin1Collected = true
                                canvasView.blackDot3?.isHidden = true
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                print("***DINGDING***")
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing2"]!, type: "mp3")
                            }
                        }
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint2) < 25 {
                            if canvasView.coin2Collected == false {
                                canvasView.coin2Collected = true
                                canvasView.blackDot4?.isHidden = true
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                print("***DINGDING***")
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing3"]!, type: "mp3")
                            }
                        }
                    }
                    //*************
                    if canvasView.Line3 == true {
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint1) < 25 {
                            if canvasView.coin1Collected == false {
                                canvasView.coin1Collected = true
                                canvasView.blackDot5?.isHidden = true
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                print("***DINGDING***")
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing2"]!, type: "mp3")
                            }
                        }
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint2) < 25 {
                            if canvasView.coin2Collected == false {
                                canvasView.coin2Collected = true
                                canvasView.blackDot6?.isHidden = true
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                print("***DINGDING***")
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing3"]!, type: "mp3")
                            }
                        }
                    }
                    //************
                    if canvasView.Line4 == true {
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint1) < 25 {
                            if canvasView.coin1Collected == false {
                                canvasView.coin1Collected = true
                                canvasView.blackDot7?.isHidden = true
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                print("***DINGDING***")
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing2"]!, type: "mp3")
                            }
                        }
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint2) < 25 {
                            if canvasView.coin2Collected == false {
                                canvasView.coin2Collected = true
                                canvasView.blackDot8?.isHidden = true
                                
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing3"]!, type: "mp3")
                            }
                        }
                    }
                    if canvasView.Line5 == true {
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint1) < 25 {
                            if canvasView.coin1Collected == false {
                                canvasView.coin1Collected = true
                                canvasView.blackDot9?.isHidden = true
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                print("***DINGDING***")
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing2"]!, type: "mp3")
                            }
                        }
                        if canvasView.CGPointDistance(from: touch.location(in: canvasView), to: middlePoint2) < 25 {
                            if canvasView.coin2Collected == false {
                                canvasView.coin2Collected = true
                                canvasView.blackDot10?.isHidden = true
                                
                                totalCoins += 1
                                letterCoins += 1
                                setupCoinLabel()
                                self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing3"]!, type: "mp3")
                            }
                        }
                    }
                    
                    // Check if touch is off path
                    checkAndTrackOffPath(touch: touch)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(canDraw)
        {
            //only able to end the line if the start was good (no touching last CGpoint to continue)
            if canvasView.goodTouch == true {
                //turn off feedback
                self.antFace.isHidden = true
                
                canvasView.drawTouches(touches, withEvent: event)
                canvasView.endTouches(touches, cancel: false)
                canvasView.goodTouch = false
                
                //guard let lastPoint = touches.first?.location(in: canvasView) else { return }
                
                touches.forEach { (touch) in clearGagues()
                    if useDebugDrawing, touch.type == .pencil {
                        reticleView.isHidden = true
                        //separatorView.isHidden = true
                    }
                }
                // adding total amount of coins possible to get
                coinsPossible += 2
                
                if canvasView.letterComplete == true {
                    canDraw = false
                    //play last ding
                    self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["CoinDing4"]!, type: "mp3")
                    
                    if (hasGoneOffPath) {
                        print(selectedActivity)
                        
                        if let image = screenShot() {
                            if let pngData = image.pngData() {
                                offPathImage = pngData.base64EncodedString()
                                // send character data to db with user credentials from login
                                print("Out of bounds on letter \(pngData)")
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        Service().updateCharacterData(letter: selectedActivity, faults: self.offPathCount, totalPointsEarned: self.letterCoins, totalPointsPossible: self.coinsPossible, image: self.offPathImage)
                    })
                    
                    //play cheer
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.canvasView.playAudioFXFile(file: chapterSelectedSoundDict!["LetterComplete"]!, type: "wav")
                        
                        // send character data to db with user credentials from login
//                        Service.updateCharacterData(username: user, password: pass, letter: selectedActivity, score: self.letterCoins, timeToComplete: Service.TimeSinceActive(lastActive: startTime), totalPointsEarned: self.letterCoins, totalPointsPossible: self.coinsPossible)
                        //dismiss activity view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                            self.dismiss(animated: false, completion: nil)
                        })
                    })
                }
                
                //removing coins from total if the line was not completed
                guard let lastPoint = touches.first?.location(in: canvasView) else { return }
                if canvasView.CGPointDistance(from: lastPoint, to: targetPoint) > 25 {
                    if canvasView.coin1Collected == true {
                        totalCoins -= 1
                        letterCoins -= 1
                        setupCoinLabel()
                        
                        if canvasView.coin2Collected == true {
                            totalCoins -= 1
                            letterCoins -= 1
                            setupCoinLabel()
                        }
                    }
                    // subtracting total amount of coins possible if line wasn't finished
                    coinsPossible -= 2
                }
                //reset collected booleans
                canvasView.coin1Collected = false
                canvasView.coin2Collected = false
            }
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
    
    // Checks and tracks off-path touches
//    private func checkAndTrackOffPath(touch: UITouch) {
//        let touchPoint = touch.location(in: canvasView)
//        let threshold: CGFloat = 25 // Adjust this threshold as needed
//
//        var isOnPath = false
//
//        // Loop through segments
//        for i in 0..<activityPoints.count-1 {
//            let start = CGPoint(x: activityPoints[i][0] * canvasView.bounds.maxX,
//                                y: activityPoints[i][1] * canvasView.bounds.maxY)
//            let end = CGPoint(x: activityPoints[i+1][0] * canvasView.bounds.maxX,
//                              y: activityPoints[i+1][1] * canvasView.bounds.maxY)
//
//            if touchPoint.distanceToSegment(start: start, end: end) < threshold {
//                isOnPath = true
//                break
//            }
//        }
//
//        if isOnPath {
//            // If the touch is back on the path, reset the off-path flag
//            isCurrentlyOffPath = false
//        } else {
//            // If the touch is off-path and it's the first time off-path, count it
//            if !isCurrentlyOffPath {
//                offPathCount += 1
//                offPathLocations.append(touchPoint)
//                isCurrentlyOffPath = true
//                print("Off path")
//                
//                
//            }
//            
//            canvasView.drawRedDot(at: touchPoint)
//        }
//    }
    
    

    
    // Image underlay version Im sorry for this code 🙁
    private func checkAndTrackOffPath(touch: UITouch) {
        let touchPoint = touch.location(in: canvasView)
        let alphaThreshold: CGFloat = 0.01 // Adjust this threshold as needed

        if let underlayImage = letterUnderlay.image {
            let pointMod = CGPoint(x: touchPoint.x * 1.25, y: touchPoint.y * 1.1225)
            
            let imagePoint = canvasView.convert(pointMod, to: letterUnderlay)
            
            let alphaValue = underlayImage.alphaValueAt(point: imagePoint)
            
            if alphaValue < alphaThreshold {
                if !isCurrentlyOffPath {
                    offPathCount += 1
                    hasGoneOffPath = true
                    isCurrentlyOffPath = true
                    canvasView.drawRedDot(at: touchPoint)
                    print("Off path")
                }                
            } else {
                isCurrentlyOffPath = false
            }
        }
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
        startTime = Date()
        switch selectedActivity {
        case "A":
            activitySelection.loadActivityA()
             testImage.image = #imageLiteral(resourceName: "Chapter 4 Background.png")
        case "B":
            activitySelection.loadActivityB()
             testImage.image = #imageLiteral(resourceName: "Chapter 2 Background")
        case "C":
            activitySelection.loadActivityC()
             testImage.image = #imageLiteral(resourceName: "Chapter 2 Background")
        case "D":
            activitySelection.loadActivityD()
             testImage.image = #imageLiteral(resourceName: "Chapter 2 Background")
        case "E":
            activitySelection.loadActivityE()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "F":
            activitySelection.loadActivityF()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "G":
            activitySelection.loadActivityG()
             testImage.image = #imageLiteral(resourceName: "Chapter 3 Background")
        case "H":
            activitySelection.loadActivityH()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "I":
            activitySelection.loadActivityI()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "J":
            activitySelection.loadActivityJ()
            testImage.image = #imageLiteral(resourceName: "Chapter 3 Background")
        case "K":
            activitySelection.loadActivityK()
            testImage.image = #imageLiteral(resourceName: "Chapter 4 Background.png")
        case "L":
            activitySelection.loadActivityL()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "M":
            activitySelection.loadActivityM()
             testImage.image = #imageLiteral(resourceName: "Chapter 4 Background.png")
        case "N":
            activitySelection.loadActivityN()
             testImage.image = #imageLiteral(resourceName: "Chapter 5 Background v1")
        case "O":
            activitySelection.loadActivityO()
            testImage.image = #imageLiteral(resourceName: "Chapter 3 Background")
        case "P":
            activitySelection.loadActivityP()
            testImage.image = #imageLiteral(resourceName: "Chapter 2 Background")
        case "Q":
            activitySelection.loadActivityQ()
            testImage.image = #imageLiteral(resourceName: "Chapter 3 Background")
        case "R":
            activitySelection.loadActivityR()
             testImage.image = #imageLiteral(resourceName: "Chapter 2 Background")
        case "S":
            activitySelection.loadActivityS()
            testImage.image = #imageLiteral(resourceName: "Chapter 3 Background")
        case "T":
            activitySelection.loadActivityT()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "U":
            activitySelection.loadActivityU()
             testImage.image = #imageLiteral(resourceName: "Chapter 2 Background")
        case "V":
            activitySelection.loadActivityV()
             testImage.image = #imageLiteral(resourceName: "Chapter 4 Background.png")
        case "W":
            activitySelection.loadActivityW()
             testImage.image = #imageLiteral(resourceName: "Chapter 4 Background.png")
        case "X":
            activitySelection.loadActivityX()
            testImage.image = #imageLiteral(resourceName: "Chapter 5 Background v1")
        case "Y":
            activitySelection.loadActivityY()
            testImage.image = #imageLiteral(resourceName: "Chapter 5 Background v1")
        case "Z":
            activitySelection.loadActivityZ()
            testImage.image = #imageLiteral(resourceName: "Chapter 5 Background v1")
        case "a":
            activitySelection.loadActivitya()
            testImage.image = #imageLiteral(resourceName: "Chapter 6 Background")
            antChillImage.loadGif(name: "Ch6_a")
        case "b":
            activitySelection.loadActivityb()
            testImage.image = #imageLiteral(resourceName: "Chapter 9 Background")
        case "c":
            activitySelection.loadActivityc()
             testImage.image = #imageLiteral(resourceName: "Chapter 6 Background")
             antChillImage.loadGif(name: "Ch6_c")
        case "d":
            activitySelection.loadActivityd()
            testImage.image = #imageLiteral(resourceName: "Chapter 6 Background")
             antChillImage.loadGif(name: "Ch6_d")
        case "e":
            activitySelection.loadActivitye()
            testImage.image = #imageLiteral(resourceName: "Chapter 8 Background")
        case "f":
            activitySelection.loadActivityf()
            testImage.image = #imageLiteral(resourceName: "Chapter 10 Background")
        case "g":
            activitySelection.loadActivityg()
            testImage.image = #imageLiteral(resourceName: "Chapter 6 Background")
             antChillImage.loadGif(name: "Ch6_g")
        case "h":
            activitySelection.loadActivityh()
             testImage.image = #imageLiteral(resourceName: "Chapter 9 Background")
        case "i":
            activitySelection.loadActivityi()
             testImage.image = #imageLiteral(resourceName: "Chapter 7 Background")
        case "j":
            activitySelection.loadActivityj()
            testImage.image = #imageLiteral(resourceName: "Chapter 8 Background")
        case "k":
            activitySelection.loadActivityk()
            testImage.image = #imageLiteral(resourceName: "Chapter 8 Background")
        case "l":
            activitySelection.loadActivityl()
             testImage.image = #imageLiteral(resourceName: "Chapter 8 Background")
        case "m":
            activitySelection.loadActivitym()
             testImage.image = #imageLiteral(resourceName: "Chapter 9 Background")
        case "n":
            activitySelection.loadActivityn()
             testImage.image = #imageLiteral(resourceName: "Chapter 9 Background")
        case "o":
            activitySelection.loadActivityo()
            testImage.image = #imageLiteral(resourceName: "Chapter 6 Background")
             antChillImage.loadGif(name: "Ch6_o")
        case "p":
            activitySelection.loadActivityp()
             testImage.image = #imageLiteral(resourceName: "Chapter 9 Background")
        case "q":
            activitySelection.loadActivityq()
             testImage.image = #imageLiteral(resourceName: "Chapter 10 Background")
        case "r":
            activitySelection.loadActivityr()
             testImage.image = #imageLiteral(resourceName: "Chapter 9 Background")
        case "s":
            activitySelection.loadActivitys()
             testImage.image = #imageLiteral(resourceName: "Chapter 7 Background")
        case "t":
            activitySelection.loadActivityt()
             testImage.image = #imageLiteral(resourceName: "Chapter 7 Background")
        case "u":
            activitySelection.loadActivityu()
            testImage.image = #imageLiteral(resourceName: "Chapter 7 Background")
        case "v":
            activitySelection.loadActivityv()
             testImage.image = #imageLiteral(resourceName: "Chapter 7 Background")
        case "w":
            activitySelection.loadActivityw()
             testImage.image = #imageLiteral(resourceName: "Chapter 7 Background")
        case "x":
            activitySelection.loadActivityx()
             testImage.image = #imageLiteral(resourceName: "Chapter 10 Background")
        case "y":
            activitySelection.loadActivityy()
            testImage.image = #imageLiteral(resourceName: "Chapter 8 Background")
        case "z":
            activitySelection.loadActivityz()
             testImage.image = #imageLiteral(resourceName: "Chapter 10 Background")
        case "-":
            activitySelection.loadActivityHorizontal()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "/":
            activitySelection.loadActivityDiagonalRight()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "|":
            activitySelection.loadActivityVertical()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "'\'":
            activitySelection.loadActivityDiagonalLeft()
            testImage.image = #imageLiteral(resourceName: "Chapter 4 Background")
        case "cross+":
            activitySelection.loadActivityPerpendicularCross()
            testImage.image = #imageLiteral(resourceName: "Chapter 1 Background")
        case "crossx":
            activitySelection.loadActivityDiagonalCross()
            testImage.image = #imageLiteral(resourceName: "Chapter 5 Background v1")
        case "square":
            activitySelection.loadActivitySquare()
            testImage.image = #imageLiteral(resourceName: "Chapter 3 Background")
        case "circle":
            activitySelection.loadActivityCircle()
            testImage.image = #imageLiteral(resourceName: "Chapter 3 Background")
        case "triangle":
            activitySelection.loadActivityTriangle()
            testImage.image = #imageLiteral(resourceName: "Chapter 3 Background")
        default: return
        }
    }
    
    private func screenShot() -> UIImage? {
        //Create the UIImage
        UIGraphicsBeginImageContext(canvasView.frame.size)
        letterUnderlay.layer.render(in: UIGraphicsGetCurrentContext()!)
        canvasView.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

extension CGPoint {
    // Calculate the minimum distance from this point to a line segment.
    func distanceToSegment(start: CGPoint, end: CGPoint) -> CGFloat {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let lengthSquared = dx*dx + dy*dy
        var t = ((self.x - start.x) * dx + (self.y - start.y) * dy) / lengthSquared
        t = max(0, min(1, t))
        let closestPoint = CGPoint(x: start.x + t * dx, y: start.y + t * dy)
        return self.distance(to: closestPoint)
    }

    // Calculate the Euclidean distance between two points.
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx*dx + dy*dy)
    }
}

extension UIImage {
    func alphaValueAt(point: CGPoint) -> CGFloat {
        guard let cgImage = self.cgImage, let dataProvider = cgImage.dataProvider else { return 0 }
        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let x = Int(point.x)
        let y = Int(point.y)

        let pixelIndex = (cgImage.width * y + x) * 4 // Assuming a standard RGBA image
        let alpha = data[pixelIndex + 3] // Alpha value of the pixel
        return CGFloat(alpha) / 255.0
    }
}

