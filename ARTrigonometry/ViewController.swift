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
    
    let pickerContent: [String] = ["section1"]
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.session.run(configuration)
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        
        //set up pickview delegate and datasource
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
        sectionButton.isHidden = false
    }
    
    @IBAction func sectionButtonClicked(_ sender: UIButton) {
        picker.isHidden = false
        sectionButton.isHidden = true
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


extension ViewController {
    func arAnimation(for _row: Int) {
        if _row == 0 {
            unitCircle()
        }
    }
    
    func unitCircle() {
        let circle = SCNNode()
        circle.geometry = SCNTorus(ringRadius: 0.1, pipeRadius: 0.003)
        circle.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        circle.eulerAngles = SCNVector3(90.degreesToRadians, 0, 0)
        circle.position = SCNVector3(0, 0, -0.5)
        self.sceneView.scene.rootNode.addChildNode(circle)
        
        let point = SCNNode()
        point.geometry = SCNSphere(radius: 0.005)
        point.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        point.position = SCNVector3(0.1, 0, 0)
        circle.addChildNode(point)
        
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
    }
    
}

extension Int {
    var degreesToRadians: Double {
        get {
            return Double(self)*(Double.pi)/180
        }
    }
}
