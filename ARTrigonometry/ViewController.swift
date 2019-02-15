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
    
    let pickerContent: [String] = ["1. Unit Circle", "section2", "section3"]
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
    
    // pickView will select which section should be run
    func arAnimation(for _row: Int) {
        if _row == 0 {
            theNodes = unitCircle()
            clockWiseButton.isHidden = false
            countClockWiseButton.isHidden = false
        } else if _row == 1 {
        }
    }
    
    //moveButton for 1.Unit circle
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

extension Int {
    var degreesToRadians: Double {
        get {
            return Double(self)*(Double.pi)/180
        }
    }
}
