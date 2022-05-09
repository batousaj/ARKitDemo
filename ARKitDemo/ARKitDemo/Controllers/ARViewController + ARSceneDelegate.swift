//
//  ARViewController + ARSceneDelegate.swift
//  ARKitDemo
//
//  Created by Thien Vu on 05/05/2022.
//

import Foundation
import RealityKit
import ARKit

extension ARViewController : ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        print("session: didUpdate")
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        print("session: didAdd")
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("session: didUpdate")
    }


    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        print("session: didRemove")
    }
}
