//
//  ARViewController.swift
//  ARKitDemo
//
//  Created by Thien Vu on 05/05/2022.
//

import Foundation
import UIKit
import RealityKit
import ARKit


class ARViewController : UIViewController {
    
    var arView = ARView()
    
    var slideWith = UISlider()
    
    var reloadBut = UIButton()

// MARK: -- Load view override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setARView()
        self.setupSlider()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
// MARK: - Setup SubView
    
    func setARView() {
        self.view.addSubview(self.arView)
        self.arView.translatesAutoresizingMaskIntoConstraints = false
        
        let contraints = [
            self.arView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.arView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.arView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.arView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(contraints)
    }
    
    func setupSlider() {
        self.view.addSubview(self.slideWith)
        self.slideWith.translatesAutoresizingMaskIntoConstraints = false
        self.slideWith.addTarget(self, action: #selector(onSliderChangeValue), for: .valueChanged)
        slideWith.transform = slideWith.transform.rotated(by: CGFloat(1.5 * Float.pi))
        
        let contraints = [
            slideWith.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 300),
            slideWith.leadingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -140),
            slideWith.widthAnchor.constraint(equalToConstant: 200),
            slideWith.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(contraints)
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
    
}

// MARK: -- Private function

extension ARViewController {
    func setupARConfiguration(isReset:Bool, runOptions: ARSession.RunOptions = []) {
        self.arView.automaticallyConfigureSession = false
        
        let configuration = ARWorldTrackingConfiguration()
        if #available(iOS 13.4, *) {
            self.arView.debugOptions.insert([.showSceneUnderstanding,.showAnchorGeometry])
            self.arView.environment.sceneUnderstanding.options.insert([.occlusion,.physics])
            configuration.sceneReconstruction = .meshWithClassification
        } else {
            // Fallback on earlier versions
        }
        
        configuration.environmentTexturing = .automatic
        
        self.arView.session.run(configuration, options: runOptions)
    }
    
    func setNodeModel() -> SCNNode? {
        let name = resourceFolder + "/" + "arrow1.scn"
        if let sence = SCNScene(named: name) {
            return sence.rootNode
        }
        return nil
    }
    
    func resetScene() {
        self.setupARConfiguration(isReset:true, runOptions: ARSession.RunOptions.removeExistingAnchors)
        dismiss(animated: true)
    }
}
