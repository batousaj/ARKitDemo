//
//  ViewController+Extension.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 26/04/2022.
//

import Foundation
import ARKit

extension ViewController : ARSCNViewDelegate {
    
// MARK: -- Touch Handler
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.lastNode = nil
        guard let touch = touches.first else {
            return
        }
        
        let point = touch.location(in: scenceView)
        self.addNode(self.setNodeModel(), at: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
// MARK: -- Event clicked handler
    
    @objc func onClickReload() {
        self.resetScene()
    }
    
// MARK: -- ARSCNViewDelegate
    
    func nodeAdded(_ node: SCNNode, for anchor: ARPlaneAnchor) {
        print("nodeAdded Plane")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("renderer did Add Node")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("renderer did Update Node")
    }
    
}
