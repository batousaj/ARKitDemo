//
//  ARViewController + Action.swift
//  ARKitDemo
//
//  Created by Thien Vu on 05/05/2022.
//

import Foundation
import RealityKit
import UIKit

extension ARViewController {
    
    @objc func onClickReload() {
        self.resetScene()
    }
    
    @objc func onSliderChangeValue(_ slider: UISlider) {
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // 1. Perform a ray cast against the mesh.
        // Note: Ray-cast option ".estimatedPlane" with alignment ".any" also takes the mesh into account.
        let tapLocation = sender.location(in: arView)
        if let result = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any).first {
            // ...
            // 2. Visualize the intersection point of the ray with the real-world surface.
            let resultAnchor = AnchorEntity(world: result.worldTransform)
            resultAnchor.addChild(sphere(radius: 0.01, color: .lightGray))
            arView.scene.addAnchor(resultAnchor, removeAfter: 0)
        }
    }
    
}
