//
//  ExtentionUnitCircle.swift
//  ARTrigonometry
//
//  Created by CHAO JIANG on 2/15/19.
//  Copyright © 2019 CHAO JIANG. All rights reserved.
//

import UIKit
import ARKit

// MARK: ARObjects for unit circle
extension ViewController {
    
    func unitCircle() -> [SCNNode] {
        
        var nodes = [SCNNode]() // [0]: myRootNode; [1]: textNode
        
        let circle = SCNNode()
        circle.geometry = SCNTorus(ringRadius: 0.1, pipeRadius: 0.003)
        circle.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        circle.geometry?.firstMaterial?.specular.contents = UIColor.white
        circle.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        circle.position = SCNVector3(0, 0, -0.5)
        self.sceneView.scene.rootNode.addChildNode(circle)
        
        let myRootNode = SCNNode()
        myRootNode.position = SCNVector3(0, 0, -0.5)
        self.sceneView.scene.rootNode.addChildNode(myRootNode)
        
        let point = SCNNode()
        point.geometry = SCNSphere(radius: 0.005)
        point.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        point.geometry?.firstMaterial?.specular.contents = UIColor.white
        point.position = SCNVector3(0.1, 0, 0)
        myRootNode.addChildNode(point)
        
        let hCoordinate = SCNNode()
        hCoordinate.geometry = SCNCylinder(radius: 0.002, height: 0.3)
        hCoordinate.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        hCoordinate.eulerAngles = SCNVector3(0, 0, 90.degreesToRadians)
        hCoordinate.position = SCNVector3(0, 0, 0)
        circle.addChildNode(hCoordinate)
        
        let vCoordinate = SCNNode()
        vCoordinate.geometry = SCNCylinder(radius: 0.002, height: 0.3)
        vCoordinate.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        vCoordinate.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        vCoordinate.position = SCNVector3(0, 0, 0)
        circle.addChildNode(vCoordinate)
        
        let hArrow = SCNNode()
        hArrow.geometry = SCNCone(topRadius: 0, bottomRadius: 0.003, height: 0.01)
        hArrow.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        hArrow.eulerAngles = SCNVector3(0, 0, -90.degreesToRadians)
        hArrow.position = SCNVector3(0.155, 0, 0)
        circle.addChildNode(hArrow)
        
        let vArrow = SCNNode()
        vArrow.geometry = SCNCone(topRadius: 0, bottomRadius: 0.003, height: 0.01)
        vArrow.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        vArrow.eulerAngles = SCNVector3(-90.degreesToRadians, 0, 0)
        vArrow.position = SCNVector3(0, 0, -0.155)
        circle.addChildNode(vArrow)
        
        let oneX = SCNNode()
        oneX.geometry = SCNText(string: "1", extrusionDepth: 0.5)
        oneX.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        oneX.position = SCNVector3(0.101, 0.001, -0.5)
        oneX.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(oneX)
        
        let oneY = SCNNode()
        oneY.geometry = SCNText(string: "1", extrusionDepth: 0.5)
        oneY.geometry?.firstMaterial?.diffuse.contents = UIColor.black
        oneY.position = SCNVector3(0.001, 0.1, -0.5)
        oneY.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(oneY)
        
        let line = SCNNode()
        line.geometry = SCNCylinder(radius: 0.003, height: 0.1)
        line.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        line.geometry?.firstMaterial?.specular.contents = UIColor.white
        line.eulerAngles = SCNVector3(0, 0, 90.degreesToRadians)
        line.position = SCNVector3(0.05, 0, 0)
        myRootNode.addChildNode(line)
        
        
        let text = SCNText(string: "Welcome to AR Trigonometry!", extrusionDepth: 1)
        text.firstMaterial?.diffuse.contents = UIColor.green
        text.firstMaterial?.specular.contents = UIColor.white
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0.1, 0.1, -0.5)
        textNode.scale = SCNVector3(0.001, 0.001, 0.001)
        sceneView.scene.rootNode.addChildNode(textNode)
        
        nodes.append(myRootNode)
        nodes.append(textNode)
        
        return nodes
    }
    
    
    func action(_ myRootNode: SCNNode, clockWise: Bool, angle: Int, stepDegree: Int) -> Int {
        
        var rotateDegree: CGFloat
        var a = angle
        if clockWise {
            rotateDegree = CGFloat(-stepDegree.degreesToRadians)
            a -= stepDegree
        } else {
            rotateDegree = CGFloat(stepDegree.degreesToRadians)
            a += stepDegree
        }
        
        let action = SCNAction.rotateBy(x: 0, y: 0, z: rotateDegree, duration: 1)
        myRootNode.runAction(action)
        
        var sina = sin(Double(a.degreesToRadians))
        var cosa = cos(Double(a.degreesToRadians))
        let arad = round(a.degreesToRadians/3.1415926*100)/100
        
        createVerticalLine(height: CGFloat(abs(sina*0.1)), px: cosa*0.1, py: 0.1*sina/2, pz: -0.5)
        sina = Double(round(sina*1000)/1000)
        cosa = Double(round(cosa*1000)/1000)
        let str = "⍺ = \(a) degrees\n⍺ = \(arad)π rad\nsin⍺ = \(sina)\ncos⍺ = \(cosa)"
        
        //get textNode and update textnode's string value
        if let textNode = theNodes?[1] {
            let temText = textNode.geometry as! SCNText
            temText.string = str
            theNodes?[1].geometry = temText
        }
        
        return a
    }
    
    func createVerticalLine(height: CGFloat, px: Double, py: Double, pz: Double) {
        let lineVertical = SCNCylinder(radius: 0.0022, height: height)
        lineVertical.firstMaterial?.diffuse.contents = UIColor.green
        lineVertical.firstMaterial?.specular.contents = UIColor.white
        let node = SCNNode(geometry: lineVertical)
        node.name = "lineVertical"
        node.position = SCNVector3(px, py, pz)
        sceneView.scene.rootNode.enumerateChildNodes {
            (node, _) in
            if node.name == "lineVertical" {
                node.removeFromParentNode()
            }
        }
        sceneView.scene.rootNode.addChildNode(node)
    }
}
