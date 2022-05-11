//
//  ARViewController + Action.swift
//  ARKitDemo
//
//  Created by Thien Vu on 05/05/2022.
//

import Foundation
import RealityKit
import UIKit
import SceneKit

extension ARViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touchesBegan")
        guard let touchPoint = self.getTouchPoint(touches) else {
            return;
        }
        self.touchPoint = touchPoint
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("touchesMoved")
        guard let touchPoint = self.getTouchPoint(touches) else {
            return;
        }
        self.touchPoint = touchPoint
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touchesEnded")
        self.resetTouches()
    }
    
    @objc func onClickReload() {
        self.resetScene()
    }
    
    @objc func onSliderChangeValue(_ slider: UISlider) {
        
    }
    
    func getTouchPoint(_ touches: Set<UITouch>) -> CGPoint? {
        guard let touch = touches.first else {
            return nil
        }

        let point = touch.location(in: arView)
        
        return point
    }
    
}
