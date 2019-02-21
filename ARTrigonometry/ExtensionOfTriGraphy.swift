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
    case negOne = -1.0
}

// MARK: extension for sin/cos graphy
extension ViewController {
    
    // MARK: generate the coordinate for sin/cos graphy
    func coordinateSetup(/*b: parameter*/) -> SCNNode {
        
        let hLength: Double = 0.8
        let numOfMk: Int = 8
        
//        switch b {
//        case .half:
//            hLength = 0.8
//            numOfMk = 8
//        case .one:
//            hLength = 0.4
//            numOfMk = 4
//        case .twice:
//            hLength = 0.4
//            numOfMk = 4
//        }
        
        //create local rootnode of section 2
        let sec2RN = SCNNode()
        sec2RN.position = SCNVector3(0.7, 0, -0.75)
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
        vCoordinate.position = SCNVector3(-hLength/2, 0, 0)
        sec2RN.addChildNode(vCoordinate)
        
        //create arrows for coordinate
        let arrow = SCNCone(topRadius: 0, bottomRadius: 0.003, height: 0.01)
        arrow.firstMaterial?.diffuse.contents = UIColor.black
        let hArror = SCNNode(geometry: arrow)
        let vArror = SCNNode(geometry: arrow)
        
        hArror.eulerAngles = SCNVector3(0, 0, -90.degreesToRadians)
        hArror.position = SCNVector3(hLength/2 + 0.005, 0, 0)
        sec2RN.addChildNode(hArror)
        
        vArror.position = SCNVector3(-hLength/2, 0.4 + 0.005, 0)
        sec2RN.addChildNode(vArror)
        
        
        //create horizontal marks
        for i in -numOfMk/2...numOfMk/2 {
            
            let str = (i + numOfMk/2) == 0 ? "\(Double(i + numOfMk/2)/2.0)" : "\(Double(i + numOfMk/2)/2.0)π"
            let mark = SCNText(string: str, extrusionDepth: 1)
            mark.firstMaterial?.diffuse.contents = UIColor.black
            let mNode = SCNNode(geometry: mark)
            mNode.scale = SCNVector3(0.001, 0.001, 0.001)
            let xPosition = 0.1*Double(i)
            mNode.position = SCNVector3(xPosition, -0.02, 0)
            sec2RN.addChildNode(mNode)
        }
        
        //create vertical marks
        for i in 0...8 {
            if i != 4 {
                let str = "\(-2 + 0.5*Double(i))"
                let mark = SCNText(string: str, extrusionDepth: 1)
                mark.firstMaterial?.diffuse.contents = UIColor.black
                let mNode = SCNNode(geometry: mark)
                mNode.scale = SCNVector3(0.001, 0.001, 0.001)
                let yPosition = -0.4 + 0.1*Double(i)
                mNode.position = SCNVector3(-hLength/2 - 0.03, yPosition, 0)
                sec2RN.addChildNode(mNode)
            }
        }
        
        return sec2RN
    }
    
    // MARK: put a dot(ball) in real world based on the coordinate
    func drawGraphy(myRN: SCNNode, position: SCNVector3, color: UIColor) {
        let dot = SCNSphere(radius: 0.004)
        dot.firstMaterial?.diffuse.contents = color
        dot.firstMaterial?.specular.contents = UIColor.white
        let dotNode = SCNNode(geometry: dot)
        dotNode.name = "dot"
        dotNode.position = position
        myRN.addChildNode(dotNode)
    }
    
    
    // MARK: generate a scntext to show what trig function are going to draw
    func triFuncGenerate(_ pa: parameter, _ pb: parameter, _ pc: parameter, _ tri: String, myRN: SCNNode, yPosition: Double, textColor: UIColor) {
        let a = pa.rawValue == 1.0 ? "" : String(pa.rawValue)
        let b = pb.rawValue == 1.0 ? "" : String(pb.rawValue)
        var c: String
        
        if pc == .half {
            c = " + 0.5π"
        } else if pc == .one {
            c = ""
        } else if pc == .negOne{
            c = " - π"
        } else {
            c = " + π"
        }
        
        let fucntion: String = "y = \(a)\(tri)(\(b)x\(c))"
        
        let triFunc = SCNText(string: fucntion, extrusionDepth: 1)
        triFunc.firstMaterial?.diffuse.contents = textColor
        triFunc.firstMaterial?.specular.contents = UIColor.white
        let triNode = SCNNode(geometry: triFunc)
        triNode.name = "triFunText"
        triNode.scale = SCNVector3(0.003, 0.003, 0.003)
        triNode.position = SCNVector3(0, yPosition, 0)
        myRN.addChildNode(triNode)
    }
    
    // MARK: Calculate each dot's position on coordinate
    func  getPositionForDrawing(_ sec2RN: SCNNode, angle: Int, isForOriginalTri: Bool) -> SCNVector3 {
        let hLen: Double = 0.8
        let totalDegree: Int = 720
        
        // if the position is for standard trig function such as y = sinx, will set a, b to 1 and c to 0; otherwise will use user's submittion
        var a: parameter, b: parameter, c: parameter
        if !isForOriginalTri {
            a = paraOutput(parameter: paraA)
            b = paraOutput(parameter: paraB)
            c = paraOutput(parameter: paraC)
        } else {
            a = .one
            b = .one
            c = .one
        }
        
        
        //test
//        print(b.rawValue)
        
//        if paraB.selectedSegmentIndex == 0 {
//            hLen = 0.8
//            totalDegree = 720
//        } else {
//            hLen = 0.4
//            totalDegree = 360
//        }
        
        let x = -hLen/2 + hLen*(Double(angle)/Double(totalDegree))
        
        var cRad: Double
        if c == .half {
            cRad = 0.5*Double.pi
        } else if c == .one {
            cRad = 0
        } else if c == .negOne {
            cRad = -Double.pi/2.0
        } else {
            cRad = Double.pi
        }
        
        var y: Double
        if sinCos.selectedSegmentIndex == 0 {
            y = 0.2 * (a.rawValue * sin(b.rawValue * angle.degreesToRadians + cRad))
        } else {
            y = 0.2 * (a.rawValue * cos(b.rawValue * angle.degreesToRadians + cRad))
        }
        
        return SCNVector3(x, y, 0)
    }
    
        
}
