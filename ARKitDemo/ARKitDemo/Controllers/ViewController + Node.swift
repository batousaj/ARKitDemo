//
//  ViewController + Stroke.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 03/05/2022.
//

import Foundation
import UIKit
import ARKit

extension ViewController {
    
// MARK: - Sence Node Handler
        
    func addNode(_ node: SCNNode, at point: CGPoint) {
        let raycastQuery = scenceView.raycastQuery(from: point,
                                               allowing: .estimatedPlane,
                                              alignment: .any)

        let results = scenceView.session.raycast(raycastQuery!)
        if results.count > 0 {
            let q = simd_quatf(results.first!.worldTransform)
            print("z point : %f", q.axis.z)
            node.simdTransform = results.first!.worldTransform
        }
        addNodeToParentNode(node.clone(), to: scenceView.scene.rootNode)
    }
        
    func addNodeToParentNode(_ node: SCNNode, to parentNode: SCNNode) {
        lastNode = node
            
        objectNode.append(node)
            
        parentNode.addChildNode(node)
    }
    
// MARK: - Stroke Code
    
    func getStroke(for anchor: ARAnchor) -> Stroke? {
        let matchStrokeArray = strokes.filter { (stroke) -> Bool in
            return stroke.anchor == anchor
        }

        return matchStrokeArray.first
    }

    /// Checks user's strokes for match, then partner's strokes
    func getStroke(for node: SCNNode) -> Stroke? {
        let matchStrokeArray = strokes.filter { (stroke) -> Bool in
            return stroke.node == node
        }

        return matchStrokeArray.first
    }
    
    func makeAnchor(at point: CGPoint) -> ARAnchor? {
        
        let offset = unprojectedPositionAtBegin(touch: point)
        
        if offset.x != 0 && offset.y != 0 && offset.z != 0 {
            var blankTransform = matrix_float4x4(1)
            blankTransform.columns.3.x = offset.x
            blankTransform.columns.3.y = offset.y
            blankTransform.columns.3.z = offset.z

            return ARAnchor(transform: blankTransform)
        }
        
        print("Can not create anchor")

        return nil
    }
    
    func updateLine(for stroke: Stroke) {
        guard let _ = stroke.points.last, let strokeNode = stroke.node else {
            return
        }
        let offset = unprojectedPosition(touch: touchPoint)
        let newPoint = strokeNode.convertPosition(offset, from: scenceView.scene.rootNode)

        stroke.lineWidth = strokeSize.rawValue
        if (stroke.add(point: newPoint)) {
            updateGeometry(stroke)
        }
        print("Total Points: \(stroke.points.count)")
    }
    
    func updateGeometry(_ stroke:Stroke) {
        if stroke.positionsVec3.count > 4 {
            let vectors = stroke.positionsVec3
            let sides = stroke.mSide
            let width = stroke.mLineWidth
            let lengths = stroke.mLength
            let totalLength = (stroke.drawnLocally) ? stroke.totalLength : stroke.animatedLength
            let line = LineGeometry(vectors: vectors,
                                    sides: sides,
                                    width: width,
                                    lengths: lengths,
                                    endCapPosition: totalLength)

            stroke.node?.geometry = line
        }
    }

    func unprojectedPositionAtBegin(touch: CGPoint) -> SCNVector3 {
        let raycastQuery = scenceView.raycastQuery(from: touch,
                                               allowing: .estimatedPlane,
                                              alignment: .any)

        let results = scenceView.session.raycast(raycastQuery!)
        if results.count > 0 {
            let q = simd_quatf(results.first!.worldTransform)
            print("z point : %f", q.axis.z)
//            scenceView.pointOfView?.removeFromParentNode()
//            self.hitNode?.position = SCNVector3Make(0, 0, q.axis.z)
//            scenceView.pointOfView?.addChildNode(self.hitNode!)
            let projectedOrigin = scenceView.projectPoint(hitNode!.worldPosition)
            let offset = scenceView.unprojectPoint(SCNVector3Make(Float(touch.x), Float(touch.y), Float(projectedOrigin.z)))
            return offset
        }
        return SCNVector3Zero
    }
    
    // Stroke Helper Methods
    func unprojectedPosition(touch: CGPoint) -> SCNVector3 {
        guard let hitNode = self.hitNode else {
            return SCNVector3Zero
        }
        
        let projectedOrigin = scenceView.projectPoint(hitNode.worldPosition)
        let offset = scenceView.unprojectPoint(SCNVector3Make(Float(touch.x), Float(touch.y), Float(projectedOrigin.z)))
        return offset
    }
    
    func clearAllStrokes() {
        for stroke in self.strokes {
            if let anchor = stroke.anchor {
                self.scenceView.session.remove(anchor: anchor)
            }
        }
    }
    
    func raycastQuery(point: CGPoint) -> ARRaycastResult?{
        let raycastQuery = scenceView.raycastQuery(from: point,
                                               allowing: .estimatedPlane,
                                              alignment: .any)
                    
        let results = scenceView.session.raycast(raycastQuery!)
        if results.count > 0 {
            return results.first!
        }
        return nil
    }
    
    func generateNodes(raycast :ARRaycastResult) -> SCNNode? {
        let sphereNode = SCNNode()
        let sphereNodeGeometry = SCNSphere(radius: 0.01)
        sphereNodeGeometry.firstMaterial?.diffuse.contents = UIColor.cyan
        sphereNode.geometry = sphereNodeGeometry

        let starterNode = sphereNode
        starterNode.simdTransform = raycast.worldTransform
        self.scenceView.scene.rootNode.addChildNode(starterNode.clone())

        let distanceLabel = TextNode(text: "Thien Vu", colour: .red)
        var blankTransform = raycast.worldTransform
        blankTransform.columns.3.y = blankTransform.columns.3.y + 0.03
        distanceLabel.simdTransform = blankTransform

        return distanceLabel
    }
}
