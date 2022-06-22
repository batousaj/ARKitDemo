//
//  ViewController.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 24/04/2022.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    // SenceView Configuration
    var scenceView:ARSCNView!
    
    var configuration = ARWorldTrackingConfiguration()
    
    // Model Arrow Node
    var objectNode = [SCNNode]()
    
    var lastNode: SCNNode?
    
    var hitNode: SCNNode?
    
    // Drawing line
    var touchPoint: CGPoint = .zero
    
    var strokes = [Stroke]()
    
    // options tool
    var modeTrack = UISwitch()
    
    var modeLabel = UILabel()
    
    var reloadBut = UIButton()
    
    var slideWith = UISlider()
    
    //private variable
    var isNode = false
    
    let minimumDistance:Float = 0.05
    
    var strokeSize: LineWith = .small
    
    var mode:ViewMode!
    
    var touchStart:CGPoint!
    var touchEnd:CGPoint!
    
    
    
// MARK: - Load View Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSenceView()
        self.setupControlButton()
        self.setupSwitch()
        self.setupSlider()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureARSession(isReset: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
        resetTouches()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        resetTouches()
    }
    
// MARK: - View State
    
    func setupControlButton() {
        reloadBut.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(reloadBut)
        self.view.bringSubviewToFront(reloadBut)
        
        if #available(iOS 13.0, *) {
            reloadBut.setImage(UIImage.init(systemName: "arrow.clockwise"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        reloadBut.tintColor = .gray
        reloadBut.addTarget(self, action: #selector(onClickReload), for: .touchUpInside)
        let contraints = [
            reloadBut.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            reloadBut.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            reloadBut.heightAnchor.constraint(equalToConstant: 50),
            reloadBut.widthAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    func setupSwitch() {
        self.view.addSubview(self.modeTrack)
        self.modeTrack.translatesAutoresizingMaskIntoConstraints = false
        self.modeTrack.setOn(false, animated: true)
        self.modeTrack.addTarget(self, action: #selector(onTapSwitch), for: .valueChanged)
        
        let constraints = [
            modeTrack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            modeTrack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            modeTrack.heightAnchor.constraint(equalToConstant: 50),
            modeTrack.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        self.view.addSubview(self.modeLabel)
        self.modeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.modeLabel.font = .boldSystemFont(ofSize: 20)
        self.modeLabel.textColor = .systemBlue
        self.setDrawing()
        
        let constraints1 = [
            modeLabel.topAnchor.constraint(equalTo: self.modeTrack.bottomAnchor, constant: 5),
            modeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            modeLabel.heightAnchor.constraint(equalToConstant: 50),
            modeLabel.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        NSLayoutConstraint.activate(constraints1)
    }
    
    func setupSenceView() {
        scenceView = ARSCNView.init(frame: self.view.frame)
        self.view.addSubview(scenceView)
        self.scenceView.translatesAutoresizingMaskIntoConstraints = false
        let contraints = [
            scenceView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scenceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scenceView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            scenceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(contraints)
        
        hitNode = SCNNode()
        hitNode!.position = SCNVector3Make(0, 0, -0.2)
        scenceView.pointOfView?.addChildNode(hitNode!)
        
        // Show statistics such as fps and timing information
//        scenceView.showsStatistics = true
        scenceView.autoenablesDefaultLighting = true
        scenceView.delegate = self
        scenceView.session.delegate = self
    }
    
    func setupSlider() {
        self.view.addSubview(self.slideWith)
        self.slideWith.translatesAutoresizingMaskIntoConstraints = false
        self.slideWith.addTarget(self, action: #selector(onSliderChangeValue), for: .valueChanged)
        self.slideWith.setValue(1.0, animated: true)
        slideWith.transform = slideWith.transform.rotated(by: CGFloat(1.5 * Float.pi))
        
        let contraints = [
            slideWith.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300),
            slideWith.leadingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -140),
            slideWith.widthAnchor.constraint(equalToConstant: 200),
            slideWith.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
}

// MARK: -- Private function

extension ViewController {
    
    func setNodeModel() -> SCNNode? {
        let name = resourceFolder + "/" + "arrow1.scn"
        if let sence = SCNScene(named: name) {
            return sence.rootNode
        }
        return nil
    }
    
    func configureARSession(isReset:Bool, runOptions: ARSession.RunOptions = []) {
        if (isReset) {
            self.objectNode.forEach { node in
                node.removeFromParentNode()
            }
            objectNode.removeAll()
        }
        
        if #available(iOS 13.4, *) {
            configuration.sceneReconstruction = .meshWithClassification
        } else {
            // Fallback on earlier versions
        }
        configuration.environmentTexturing = .automatic
        
        configuration.planeDetection = .horizontal
        scenceView.session.run(configuration, options: runOptions)
    }
    
    func sencePause() {
        scenceView.session.pause()
    }
    
    func setMaxValueSlide() {
        self.slideWith.setValue(1.0, animated: true)
    }
    
    func resetScene() {
        isNode = false
        self.clearAllStrokes()
        resetTouches()
        configureARSession(isReset:true, runOptions: ARSession.RunOptions.removeExistingAnchors)
        dismiss(animated: true)
    }
    
    func resetTouches() {
        touchPoint = .zero
    }
    
    func setDrawing() {
        print("Mode change to Drawing")
        self.modeLabel.text = "Drawing"
        self.mode = .TEXT
    }
    
    func setObject() {
        print("Mode change to Object Tracking")
        self.modeLabel.text = "Object"
        self.mode = .STRIANGTH
    }
    
    func isObject() -> Bool {
        if (self.mode == .OBJECT) {
            return true
        }
        return false
    }
}
