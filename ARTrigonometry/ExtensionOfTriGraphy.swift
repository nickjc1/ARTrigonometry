//
//  ExtensionOfTriGraphy.swift
//  ARTrigonometry
//
//  Created by CHAO JIANG on 2/15/19.
//  Copyright © 2019 CHAO JIANG. All rights reserved.
//

import ARKit
import UIKit

enum parameter: Double {
    case half = 0.5
    case one = 1.0
    case twice = 2.0
}

// MARK: extension for sin/cos graphy
extension ViewController {
    
    func coordinateSetup(a: parameter, b: parameter, c: parameter) {
        
        var hLength: Double
        var numOfMk: Int
        
        switch b {
        case .half:
            hLength = 0.8
            numOfMk = 8
        case .one:
            hLength = 0.4
            numOfMk = 4
        case .twice:
            hLength = 0.4
            numOfMk = 4
        }
        
        //create local rootnode of section 2
        let sec2RN = SCNNode()
        sec2RN.position = SCNVector3(0.75, 0, -0.75)
        self.sceneView.scene.rootNode.addChildNode(sec2RN)
        
        //create horizontal coordinate based on local rootnode
        let horizontal = SCNCylinder(radius: 0.002, height: CGFloat(hLength))
        horizontal.firstMaterial?.diffuse.contents = UIColor.black
        let hCoordinate = SCNNode(geometry: horizontal)
        hCoordinate.eulerAngles = SCNVector3(0, 0, 90.degreesToRadians)
        hCoordinate.position = SCNVector3(0, 0, 0)
        sec2RN.addChildNode(hCoordinate)
        
        //create vertical coordinate based on local rootnode
        let vertical = SCNCylinder(radius: 0.002, height: 0.8)
        vertical.firstMaterial?.diffuse.contents = UIColor.black
        let vCoordinate = SCNNode(geometry: vertical)
        vCoordinate.position = SCNVector3(-0.2, 0, 0)
        sec2RN.addChildNode(vCoordinate)
        
        //create arrows for coordinate
        let arrow = SCNCone(topRadius: 0, bottomRadius: 0.003, height: 0.01)
        arrow.firstMaterial?.diffuse.contents = UIColor.black
        let hArror = SCNNode(geometry: arrow)
        let vArror = SCNNode(geometry: arrow)
        
        hArror.eulerAngles = SCNVector3(0, 0, -90.degreesToRadians)
        hArror.position = SCNVector3(hLength/2 + 0.005, 0, 0)
        sec2RN.addChildNode(hArror)
        
        vArror.position = SCNVector3(-0.2, 0.4 + 0.005, 0)
        sec2RN.addChildNode(vArror)
        
        
        //create horizontal marks
        for i in -numOfMk/2...numOfMk/2 {
            
            let str = (i + numOfMk/2) == 0 ? "\(Double(i + numOfMk/2)/2.0)" : "\(Double(i + numOfMk/2)/2.0)π"
            let mark = SCNText(string: str, extrusionDepth: 1)
            mark.firstMaterial?.diffuse.contents = UIColor.darkGray
            let mNode = SCNNode(geometry: mark)
            mNode.scale = SCNVector3(0.001, 0.001, 0.001)
            let xPosition = 0.1*Double(i)
            mNode.position = SCNVector3(xPosition, -0.02, 0)
            sec2RN.addChildNode(mNode)
        }
        
        //create vertical marks
        for i in 0...8 {
            if i != 4 {
                let str = "\(-2 + 0.5*Double(i))π"
                let mark = SCNText(string: str, extrusionDepth: 1)
                mark.firstMaterial?.diffuse.contents = UIColor.darkGray
                let mNode = SCNNode(geometry: mark)
                mNode.scale = SCNVector3(0.001, 0.001, 0.001)
                let yPosition = -0.4 + 0.1*Double(i)
                mNode.position = SCNVector3(-0.2 - 0.03, yPosition, 0)
                sec2RN.addChildNode(mNode)
            }
        }
    }
}
