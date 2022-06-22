//
//  Model.swift
//  ARKitDemo
//
//  Created by Mac Mini 2021_1 on 27/04/2022.
//

import Foundation
import ARKit

let resourceFolder = "art.scnassets"

enum View: String {
    case ARSCNView = "ARSCNView"
    case ARView = "ARView"
}

enum LineWith: Float {
    case small = 0.006
    case medium = 0.011
    case large = 0.020
}

enum ViewMode {
    case DRAWING
    case OBJECT
    case STRIANGTH
    case TEXT
}

enum Arrow: String {
    case Arrow1 = "Arrow1"
    case Arrow2 = "Arrow2"
    case Arrow3 = "Arrow3"
    case Arrow4 = "Arrow4"
    case Arrow5 = "Arrow5"
    case Arrow6 = "Arrow6"
}

extension SCNVector3 {
    func distance(to receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
