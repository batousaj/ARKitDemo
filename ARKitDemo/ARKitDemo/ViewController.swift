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
    
    var isNode = false
    
    
// MARK: - Load View Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupSenceView()
        self.setupControlButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureARSession(isReset: false)
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
        let contraints = [
            reloadBut.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            reloadBut.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            reloadBut.heightAnchor.constraint(equalToConstant: 50),
            reloadBut.widthAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(contraints)
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
        
        // Show statistics such as fps and timing information
//        scenceView.showsStatistics = true
        scenceView.autoenablesDefaultLighting = true
        scenceView.delegate = self
        scenceView.session.delegate = self
    }
    

// MARK: - Sence Node Handler
    
    func addNode(_ node: SCNNode, at point: CGPoint) {
        guard let hitResult = scenceView.hitTest(point, types: .existingPlaneUsingExtent).first else { return }
        guard let anchor = hitResult.anchor as? ARPlaneAnchor, anchor.alignment == .horizontal else { return }
        
        node.simdTransform = hitResult.worldTransform
        addNodeToParentNode(node, to: scenceView.scene.rootNode)
    }
    
    func addNodeToParentNode(_ node: SCNNode, to parentNode: SCNNode) {
        if let lastNode = lastNode {
            let lastPosition = lastNode.position
            let newPosition = node.position

            let x = lastPosition.x - newPosition.x
            let y = lastPosition.y - newPosition.y
            let z = lastPosition.z - newPosition.z

            let distanceSquare = x * x + y * y + z * z
            let minimumDistanceSquare = minimumDistance * minimumDistance

            guard minimumDistanceSquare < distanceSquare else { return }
        }
        
        let clonedNode = node.clone()
        
        lastNode = clonedNode
        
        objectNode.append(clonedNode)
        
        parentNode.addChildNode(clonedNode)
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
        
        configuration.planeDetection = .horizontal
        scenceView.session.run(configuration, options: runOptions)
    }
    
    func sencePause() {
        scenceView.session.pause()
    }
    
    func resetScene() {
        configureARSession(isReset:true, runOptions: ARSession.RunOptions.removeExistingAnchors)
        dismiss(animated: true)
    }
}
