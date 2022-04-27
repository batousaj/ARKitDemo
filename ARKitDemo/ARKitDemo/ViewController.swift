//
//  ViewController.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 24/04/2022.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    var scenceView:ARSCNView!
    
    var configuration = ARWorldTrackingConfiguration()
    
    var objectNode = [SCNNode]()
    
    var reloadBut = UIButton()
    
    let minimumDistance:Float = 0.05
    
    var lastNode: SCNNode?
    
    
// MARK: - Load View Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSenceView()
        self.setupControlButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadConfiguration(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupControlButton() {
        reloadBut.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(reloadBut)
        self.view.bringSubviewToFront(reloadBut)
        
        if #available(iOS 13.0, *) {
            reloadBut.setImage(UIImage.init(systemName: "arrow.clockwise"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
//        reloadBut.imageEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        reloadBut.tintColor = .gray
        reloadBut.addTarget(self, action: #selector(onClickReload), for: .touchUpInside)
        
        if #available(iOS 11.0, *) {
            let contraints = [
                reloadBut.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
                reloadBut.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                reloadBut.heightAnchor.constraint(equalToConstant: 50),
                reloadBut.widthAnchor.constraint(equalToConstant: 50)
            ]
            NSLayoutConstraint.activate(contraints)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupSenceView() {
        if #available(iOS 11.0, *) {
            scenceView = ARSCNView.init(frame: self.view.frame)
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(scenceView)
        self.scenceView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            let contraints = [
                scenceView.topAnchor.constraint(equalTo: self.view.topAnchor),
                scenceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                scenceView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                scenceView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
            NSLayoutConstraint.activate(contraints)
        } else {
            // Fallback on earlier versions
        }
        // Show statistics such as fps and timing information
//        scenceView.showsStatistics = true
        scenceView.autoenablesDefaultLighting = true
        scenceView.delegate = self
    }
    
    func reloadConfiguration(_ reset: Bool) {
        self.senceRun()
    }
    

// MARK: - Sence Node Handler
    
    func addNode(_ node: SCNNode, at point: CGPoint) {
        guard let hitResult = scenceView.hitTest(point, types: .existingPlaneUsingExtent).first else { return }
        guard let anchor = hitResult.anchor as? ARPlaneAnchor, anchor.alignment == .horizontal else { return }
        
        node.simdTransform = hitResult.worldTransform
        addNodeToParentNode(node, to: scenceView.scene.rootNode)
    }
    
    func addNodeToParentNode(_ node: SCNNode, to parentNode: SCNNode) {
//        if let lastNode = lastNode {
//            let lastPosition = lastNode.position
//            let newPosition = node.position
//
//            let x = lastPosition.x - newPosition.x
//            let y = lastPosition.y - newPosition.y
//            let z = lastPosition.z - newPosition.z
//
//            let distanceSquare = x * x + y * y + z * z
//            let minimumDistanceSquare = minimumDistance * minimumDistance
//
//            guard minimumDistanceSquare < distanceSquare else { return }
//        }
        
        let clonedNode = node.clone()
        
        lastNode = clonedNode
        
        objectNode.append(clonedNode)
        
        // Add the cloned node to the scene
        parentNode.addChildNode(clonedNode)
    }
    
}

// MARK: -- Private function

extension ViewController {
    
    func setNodeModel() -> SCNNode {
        let name = resourceFolder + "/" + "arrow1.scn"
        if let sence = SCNScene(named: name) {
            return sence.rootNode
        }
        return SCNNode.init()
    }
    
    func senceRun() {
        if #available(iOS 11.0, *) {
            let option = ARSession.RunOptions.removeExistingAnchors
            configuration.planeDetection = .horizontal
            scenceView.session.run(configuration, options: option)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func sencePause() {
        scenceView.session.pause()
    }
    
    func resetScene() {
        objectNode.removeAll()
        reloadConfiguration(true)
        dismiss(animated: true)
    }
}
