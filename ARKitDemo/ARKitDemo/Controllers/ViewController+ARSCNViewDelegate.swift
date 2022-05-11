//
//  ViewController+Extension.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 26/04/2022.
//

import Foundation
import ARKit

extension ViewController : ARSCNViewDelegate, ARSessionDelegate {
    
// MARK: -- ARSCNViewDelegate
    
    func nodeAdded(_ node: SCNNode, for anchor: ARPlaneAnchor) {
        print("nodeAdded Plane")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print("renderer did Add Node")
        isNode = true
        if (self.isObject()) {
            if touchPoint != .zero {
                guard let node = self.setNodeModel() else {
                    return;
                }
//                node.simdTransform = anchor.transform
                if (isNode) {
                   self.addNode(node, at: touchPoint)
                }
            }
        } else {
            let raycastQuery = scenceView.raycastQuery(from: touchPoint,
                                                   allowing: .estimatedPlane,
                                                  alignment: .any)

            let results = scenceView.session.raycast(raycastQuery!)
            if results.count > 0 {
                let q = simd_quatf(results.first!.worldTransform)
                print("z point : %f", q.axis.z)
                node.simdTransform = results.first!.worldTransform
            }
            if let stroke = getStroke(for: anchor) {
                print ("did add: \(node.position)")
                print ("stroke first position: \(stroke.points[0])")
                stroke.node = node

                DispatchQueue.main.async {
                    self.updateGeometry(stroke)
                }
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if (self.isObject()) {

        } else {
            if let stroke = getStroke(for: anchor) {
                print("Renderer did update node transform: \(node.transform) and anchorTranform: \(anchor.transform)")
                stroke.node = node
                if (strokes.contains(stroke)) {
                    DispatchQueue.main.async {
                        self.updateGeometry(stroke)
                    }
                }
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if (self.isObject()) {

        } else {
            if let stroke = getStroke(for: node) {

                if (strokes.contains(stroke)) {
                    if let index = strokes.firstIndex(of: stroke) {
                        strokes.remove(at: index)
                    }
                }
                stroke.cleanup()

                print("Stroke removed.  Total strokes=\(strokes.count)")
            }
        }

    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if (self.isObject()) {
            
        } else {
            if (touchPoint != .zero) {
                if let stroke = strokes.last {
                    DispatchQueue.main.async {
                        self.updateLine(for: stroke)
                    }
                }
            }
        }
        
    }
}
