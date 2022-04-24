//
//  ViewController.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 24/04/2022.
//

import UIKit
import ARKit

class ViewController: UIViewController,ARSCNViewDelegate {
    
    var scence:ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scence = ARSCNView.init(frame: self.view.frame)
        self.view.addSubview(scence)
        // Show statistics such as fps and timing information
        scence.showsStatistics = true
        scence.autoenablesDefaultLighting = true
        
        let sense = SCNScene(named: "art.scnassets/eevee.scn")
        scence.scene = sense!
        scence.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        
        if let imageTrack = ARReferenceImage.referenceImages(inGroupNamed: "PokemonCards", bundle: Bundle.main) {
            configuration.detectionImages = imageTrack
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        scence.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scence.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
        //            print(imageAnchor.referenceImage.name)
                    
                    let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                    plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
                    
                    let planeNode =  SCNNode(geometry: plane)
                    
                    
                    planeNode.eulerAngles.x = -Float.pi / 2
                    
                    node.addChildNode(planeNode)
                    if imageAnchor.referenceImage.name == "eevee_card"{
                        if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn"){
                                        if let pokeNode = pokeScene.rootNode.childNodes.first{
                                            pokeNode.eulerAngles.x = .pi / 2
                                            planeNode.addChildNode(pokeNode)
                                            
                                        }
                                    }
                    }
                    
                    if imageAnchor.referenceImage.name == "oddish"{
                        if let pokeScene = SCNScene(named: "art.scnassets/oddish.scn"){
                                        if let pokeNode = pokeScene.rootNode.childNodes.first{
                                            pokeNode.eulerAngles.x = .pi / 2
                                            planeNode.addChildNode(pokeNode)
                                            
                                        }
                                    }
                    }
                    
                    
                }
        return node
    }
}

