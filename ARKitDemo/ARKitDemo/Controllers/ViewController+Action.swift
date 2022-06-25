//
//  ViewController+Action.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 03/05/2022.
//

import Foundation
import UIKit
import SceneKit
import RealityKit

extension ViewController {
    
// MARK: -- Touch Handler
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touchesBegan")
        guard let touchPoint = self.getTouchPoint(touches) else {
            return;
        }
        self.touchPoint = touchPoint

        switch mode {
            case .OBJECT :
                self.lastNode = nil
                if let anchor = makeAnchor(at:touchPoint) {
                    scenceView.session.add(anchor: anchor)
                }
                break;
            case .DRAWING :
                // begin a new stroke
                let stroke = Stroke()
                if let anchor = makeAnchor(at:touchPoint) {
                    stroke.anchor = anchor
                    stroke.points.append(SCNVector3Zero)
                    stroke.touchStart = touchPoint
                    stroke.lineWidth = strokeSize.rawValue

                    strokes.append(stroke)
                    scenceView.session.add(anchor: anchor)
                }
                break;
            case .STRIANGTH :
                self.touchStart = self.touchPoint
                break
            case .TEXT:
                if let anchor = makeAnchor(at:touchPoint) {
                    scenceView.session.add(anchor: anchor)
                }
                break
            default :
                break;
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("touchesMoved")
        if (mode == .DRAWING) {
            guard let touchPoint = self.getTouchPoint(touches) else {
                return;
            }
            self.touchPoint = touchPoint
        }
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touchesEnded")
        guard let touchPoint = self.getTouchPoint(touches) else {
            return;
        }
        
        if mode == .STRIANGTH {
            self.touchEnd = touchPoint
                    if let startRaycast = self.raycastQuery(point: self.touchStart), let stopRaycast = self.raycastQuery(point: self.touchEnd) {
//                        let cylinderLineNode = SCNGeometry.cylinderLine(from: startRaycast.worldTransform.position(),
//                                                                        to: stopRaycast.worldTransform.position(),
//                                                                    segments: 3)
//                        self.addNodeToParentNode(cylinderLineNode, to: self.scenceView.scene.rootNode)
                        let cylinderLineNode = SCNGeometry.torus(at: startRaycast.worldTransform.position(),
                                                                 segment: 40)
                        self.addNodeToParentNode(cylinderLineNode, to: self.scenceView.scene.rootNode)
            }
        }
        self.resetTouches()
        strokes.last?.resetMemory()
    }
    
    func getTouchPoint(_ touches: Set<UITouch>) -> CGPoint? {
        guard let touch = touches.first else {
            return nil
        }

        let point = touch.location(in: scenceView)
        
        return point
    }
        
// MARK: -- Event clicked handler
        
    @objc func onClickReload() {
        self.resetScene()
    }

    @objc func onTapSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.setObject()
        } else {
            self.setDrawing()
        }
    }
    
    @objc func onSliderChangeValue(_ slider: UISlider) {
        print("tHIEN vi: %d",slider.value)
        let node_arm = lastNode
        node_arm?.runAction(.customAction(duration: 0, action: { node, progress in
            DispatchQueue.main.async {
                node.physicsBody = nil
                node.scale = SCNVector3(x: Float(slider.value), y: Float(slider.value), z: Float(slider.value))
            }
        }))
    }
}

extension SCNGeometry {

    static func cylinderLine(from: SCNVector3,
                               to: SCNVector3,
                         segments: Int) -> SCNNode {
        
        let x1 = from.x
        let x2 = to.x

        let y1 = from.y
        let y2 = to.y

        let z1 = from.z
        let z2 = to.z

        let distance =  sqrtf( (x2-x1) * (x2-x1) +
                               (y2-y1) * (y2-y1) +
                               (z2-z1) * (z2-z1) )

        let cylinder = SCNCylinder(radius: 0.005,
                                   height: CGFloat(distance))

        cylinder.radialSegmentCount = segments

        cylinder.firstMaterial?.diffuse.contents = UIColor.red

        let lineNode = SCNNode(geometry: cylinder)

        lineNode.position = SCNVector3(x: (from.x + to.x) / 2,
                                       y: (from.y + to.y) / 2,
                                       z: (from.z + to.z) / 2)

        lineNode.eulerAngles = SCNVector3(Float.pi / 2,
                                          acos((to.z-from.z)/distance),
                                          atan2((to.y-from.y),(to.x-from.x)))

        return lineNode
    }
    
    static func torus(at: SCNVector3,
                      segment: Int) -> SCNNode {
        
        let x1 = at.x
        let y1 = at.y
        let z1 = at.z
        
        let torus = SCNTorus(ringRadius: 0.2, pipeRadius: 0.005)
        torus.ringSegmentCount = segment
        
        torus.firstMaterial?.diffuse.contents = UIColor.red
        
        let torusNode = SCNNode(geometry: torus)
        
        torusNode.position = SCNVector3(x: x1 ,
                                        y: y1 ,
                                        z: z1 )
        
        torusNode.eulerAngles = SCNVector3(Float.pi / 2,
                                           acos(z1),
                                          atan2(y1,x1))

        return torusNode
    }
}

extension matrix_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
}



