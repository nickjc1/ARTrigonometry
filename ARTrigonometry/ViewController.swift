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
    
    // MARK: Buttons for Unit Circle
    @IBOutlet weak var clockWiseButton: UIButton!
    @IBOutlet weak var countClockWiseButton: UIButton!
    
    // MARK: sin/cos graphy view and buttons initialize
    @IBOutlet weak var sinCosControlView: UIView!
    @IBOutlet weak var parameterSubmmit: UIButton!
    @IBOutlet weak var paraA: UISegmentedControl!
    @IBOutlet weak var paraB: UISegmentedControl!
    @IBOutlet weak var paraC: UISegmentedControl!
    @IBOutlet weak var sinCos: UISegmentedControl!
    @IBOutlet weak var graphyResetButton: UIButton!
    
    // MARK: PickerView Content array
    let pickerContent: [String] = ["1. Unit Circle", "2. sin/cos Graphy", "section3"]
    
    var buttons = [UIButton]()
    
    // MARK: Store some important scnNodes generate from functions in extension for later use.
    var theNodes: [SCNNode]?
    
    let configuration = ARWorldTrackingConfiguration()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.session.run(configuration)
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        
        //set up pickview delegate and datasource
        picker.delegate = self
        picker.dataSource = self
        
        // MARK: Initialize the userinterface when app first loaded.
        picker.isHidden = true
        sectionButton.isHidden = false
        
        sinCosControlView.isHidden = true //for section 2
        sinCosControlView.layer.cornerRadius = 5 //round sinCosControlView corner
        
        
        //add each section's buttons into an array for hidden when touch section selector button
        buttons = [clockWiseButton, countClockWiseButton, graphyResetButton]
        
        for button in buttons {
            DispatchQueue.main.async {
                button.isHidden = true
            }
        }
    }
    
    @IBAction func sectionButtonClicked(_ sender: UIButton) {
        picker.isHidden = false
        sectionButton.isHidden = true
        sinCosControlView.isHidden = true
        
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
    
    // MARK: RotationButtons of Unit circle
    var theAngle = 0
    var stepDegree: Int?
    @IBAction func clockWiseClicked(_ sender: UIButton) {
        if let myRootNode = theNodes?[0] {
            theAngle = action(myRootNode, clockWise: true, angle: theAngle, stepDegree: 15)
        }
    }
    
    @IBAction func countClockWiseClicked(_ sender: UIButton) {
        
        if theAngle < 720 {
            if let myRootNode = theNodes?[0] {
                theAngle = action(myRootNode, clockWise: false, angle: theAngle, stepDegree: stepDegree!)
            }
        }
        
        if theNodes?.count == 3, let sec2RN = theNodes?[2] {
            var position = getPositionForDrawing(sec2RN, angle: theAngle, isForOriginalTri: false)
            drawGraphy(myRN: sec2RN, position: position, color: UIColor.red)
//            let index: [Int] = [paraA.selectedSegmentIndex, paraB.selectedSegmentIndex, paraC.selectedSegmentIndex]
            
            position = getPositionForDrawing(sec2RN, angle: theAngle, isForOriginalTri: true)
            drawGraphy(myRN: sec2RN, position: position, color: UIColor.blue)
        }
        
    }
    
    // MARK: Buttons Clicked for sin/cos graphy draw of section2
    @IBAction func paraSubmitClicked(_ sender: UIButton) {
        let pa: parameter = paraOutput(parameter: paraA)
        let pb: parameter = paraOutput(parameter: paraB)
        let pc: parameter = paraOutput(parameter: paraC)
        var triFunc: String
        switch sinCos.selectedSegmentIndex {
        case 0: triFunc = "sin"
        default: triFunc = "cos"
        }
        
        let sec2RN = self.coordinateSetup()
        theNodes?.append(sec2RN) // theNodes[2] is sec2RN
        triFuncGenerate(pa, pb, pc, triFunc, myRN: sec2RN, yPosition: 0.5, textColor: UIColor.red)
        triFuncGenerate(.one, .one, .one, triFunc, myRN: sec2RN, yPosition: 0.45, textColor: UIColor.blue)
        
        sinCosControlView.isHidden = true
        countClockWiseButton.isHidden = false
        graphyResetButton.isHidden = false
    }
    
    func paraOutput(parameter: UISegmentedControl) -> parameter {
        switch parameter.selectedSegmentIndex {
        case 0: return .half
        case 1: return .one
        case 2:  return .twice
        default: return .negOne
        }
    }
    
    @IBAction func graphyResetClicked(_ sender: UIButton) {
//        if let sec2RN = theNodes?[2] {
//            sec2RN.enumerateChildNodes { (node, _) in
//                node.removeFromParentNode()
//            }
//        }
        sceneView.scene.rootNode.enumerateChildNodes {
            (node, _) in
            node.removeFromParentNode()
        }
        theAngle = 0
        
//        theNodes?.remove(at: 2) // remove the sec2RN from theNodes[]
        sinCosControlView.isHidden = false
        countClockWiseButton.isHidden = true
        graphyResetButton.isHidden = true
        
        //recreate a unit circle
        theNodes = unitCircle()
    }
    
    
    
}


// MARK: pickview
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
    
    // pickView will select which section should be run
    func arAnimation(for _row: Int) {
        if _row == 0 {
            theNodes = unitCircle() //[0], [1]
            stepDegree = 15
            clockWiseButton.isHidden = false
            countClockWiseButton.isHidden = false
        } else if _row == 1 {
            stepDegree = 5
            theNodes = unitCircle() //[0], [1]
            sinCosControlView.isHidden = false
        }
    }
}

// MARK: degree to radian transform for Integer
extension Int {
    var degreesToRadians: Double {
        get {
            return Double(self)*(Double.pi)/180
        }
    }
}
