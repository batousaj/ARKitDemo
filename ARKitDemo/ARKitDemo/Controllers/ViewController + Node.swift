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
//        guard let hitResult = scenceView.hitTest(point, types: .existingPlaneUsingExtent).first else { return }
//        guard let anchor = hitResult.anchor as? ARPlaneAnchor, anchor.alignment == .horizontal else { return }
//
//        node.simdTransform = hitResult.worldTransform
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
        
        let offset = unprojectedPosition(touch: point)

        var blankTransform = matrix_float4x4(1)
//        var transform = hitNode.simdWorldTransform
        blankTransform.columns.3.x = offset.x
        blankTransform.columns.3.y = offset.y
        blankTransform.columns.3.z = offset.z

        return ARAnchor(transform: blankTransform)
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

    // Stroke Helper Methods
    func unprojectedPosition(touch: CGPoint) -> SCNVector3 {
        guard let hitNode = self.hitNode else {
            return SCNVector3Zero
        }

        let projectedOrigin = scenceView.projectPoint(hitNode.worldPosition)
        let offset = scenceView.unprojectPoint(SCNVector3Make(Float(touch.x), Float(touch.y), projectedOrigin.z))

        return offset
    }
    
    func clearAllStrokes() {
        for stroke in self.strokes {
            if let anchor = stroke.anchor {
                self.scenceView.session.remove(anchor: anchor)
            }
        }
    }
}
