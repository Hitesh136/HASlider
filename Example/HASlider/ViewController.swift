//
//  ViewController.swift
//  CustomSlider
//
//  Created by Hitesh  Agarwal on 1/15/18.
//  Copyright © 2018 Hitesh  Agarwal. All rights reserved.
//

import UIKit
import HASlider

class ViewController: UIViewController {
    
    @IBOutlet var leftView: UIView!
    @IBOutlet var rightView: UIView!
    
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var lblRight: UILabel!
    
    @IBOutlet weak var slider: HASlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //For show only one handler set disbable range true.And don't add right tip view.
        /* if disablerange = true
         slider.rightTipView = UIView()
         slider.disableRange = true
         
         left value becomes main value
         right selction color not active.
        */ 
        
        //Set Left view over handler
        slider.leftTipView = leftView
        
        //Set Right view over handler
        slider.rightTipView = rightView
        
        //Text in left custom view
        lblLeft.text = String(format: "%d", Int(slider.leftValue))
        
        //Text in right custom view
        lblRight.text = String(format: "%d", Int(slider.rightValue))
        
        //Delegte to get callback of slider touch events.
        slider.delegate = self
        
    }
    
    @IBAction func actionReload(_ sender: Any) {
        slider.leftValue = 0
        slider.rightValue = 100
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: SliderDelegate {
    func beginTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        if isTrackingLeftHandler {
            lblLeft.text = String(format: "%d", Int(slider.leftValue))
        }
        else if isTrackingRightHandler {
            lblRight.text = String(format: "%d", Int(slider.rightValue))
        }
    }
    
    func continueTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        if isTrackingLeftHandler {
            lblLeft.text = String(format: "%d", Int(slider.leftValue))
        }
        else if isTrackingRightHandler {
            lblRight.text = String(format: "%d", Int(slider.rightValue))
        }
    }
    
    func endTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        if isTrackingLeftHandler {
            lblLeft.text = String(format: "%d", Int(slider.leftValue))
        }
        else if isTrackingRightHandler {
            lblRight.text = String(format: "%d", Int(slider.rightValue))
        }
    }
    
}

