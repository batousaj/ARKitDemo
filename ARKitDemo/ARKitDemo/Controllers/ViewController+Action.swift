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


