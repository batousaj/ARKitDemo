//
//  ViewController+Extension.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 26/04/2022.
//

import Foundation
import ARKit

extension ViewController : ARSCNViewDelegate, ARSessionDelegate {
    
// MARK: -- Touch Handler
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touchesBegan")
        self.lastNode = nil
        guard let touch = touches.first else {
            return
        }

        let point = touch.location(in: scenceView)
        guard let node = self.setNodeModel() else {
            return;
        }
        if (isNode) {
            self.addNode(node, at: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("touchesMoved")

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")
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
        isNode = true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("renderer did Update Node")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        print("renderer updateAtTime")
    }
}
