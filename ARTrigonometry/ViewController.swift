//
//  ViewController.swift
//  ARTrigonometry
//
//  Created by CHAO JIANG on 2/1/19.
//  Copyright © 2019 CHAO JIANG. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var sectionButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var clockWiseButton: UIButton! //for section1
    @IBOutlet weak var countClockWiseButton: UIButton!
    
    let pickerContent: [String] = ["section1", "section2", "section3"]
    var buttons = [UIButton]()
    
    
    var theNodes: [SCNNode]? // store some important scnNodes generate from functions in extension for later use.
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.session.run(configuration)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        
        //set up pickview delegate and datasource
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
        sectionButton.isHidden = false
        
//        sectionButton.backgroundColor = UIColor.white
        
        //add each section's buttons into an array for hidden when touch section selector button
        buttons = [clockWiseButton, countClockWiseButton]
        for button in buttons {
            DispatchQueue.main.async {
                button.isHidden = true
            }
        }
    }
    
    @IBAction func sectionButtonClicked(_ sender: UIButton) {
        picker.isHidden = false
        sectionButton.isHidden = true
        
        for button in buttons {
            DispatchQueue.main.async {
                button.isHidden = true
            }
        }
        
        theNodes = []
        
        //reset theAngle variable from section1
        theAngle = 0
        
        //reset session, clean all nodes
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes {
            (node, _) in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    //moveButton for section1
    var theAngle = 0
    @IBAction func clockWiseClicked(_ sender: UIButton) {
        if let myRootNode = theNodes?[0] {
            theAngle = action(myRootNode, clockWise: true, angle: theAngle)
        }
    }
    
    @IBAction func countClockWiseClicked(_ sender: UIButton) {
        if let myRootNode = theNodes?[0] {
            theAngle = action(myRootNode, clockWise: false, angle: theAngle)
        }
    }
}


//: MARK pickview
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerContent.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerContent[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        arAnimation(for: row)
        picker.isHidden = true
        sectionButton.isHidden = false
    }
}

//: MARK ARObjects for section1
extension ViewController {
    func arAnimation(for _row: Int) {
        if _row == 0 {
            theNodes = unitCircle()
            clockWiseButton.isHidden = false
            countClockWiseButton.isHidden = false
        } else if _row == 1 {
        }
    }
    
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
    
    
    func action(_ myRootNode: SCNNode, clockWise: Bool, angle: Int) -> Int {
        
        var rotateDegree: CGFloat
        var a = angle
        if clockWise {
            rotateDegree = CGFloat(-15.degreesToRadians)
            a -= 15
        } else {
            rotateDegree = CGFloat(15.degreesToRadians)
            a += 15
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

extension Int {
    var degreesToRadians: Double {
        get {
            return Double(self)*(Double.pi)/180
        }
    }
}
