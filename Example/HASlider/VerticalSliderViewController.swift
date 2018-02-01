//
//  VerticalSliderViewController.swift
//  HASlider_Example
//
//  Created by Hitesh Agarwal on 01/02/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import HASlider

class VerticalSliderViewController: UIViewController {

    @IBOutlet weak var slider1: HAVerticalSlider!
    @IBOutlet var leftView_Slider1: UIView!
    @IBOutlet var rightView_Slider1: UIView!
    @IBOutlet weak var lblLeftView_Slider1: UILabel!
    @IBOutlet weak var lblRightView_Slider1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Left view over handler
        slider1.leftTipView = leftView_Slider1
        
        //Set Right view over handler
        slider1.rightTipView = rightView_Slider1
        
        //Text in left custom view
        lblLeftView_Slider1.text = String(format: "%d", Int(slider1.leftValue))
        
        //Text in right custom view
        lblRightView_Slider1.text = String(format: "%d", Int(slider1.rightValue))
        
        //Delegte to get callback of slider touch events.
        slider1.delegate = self
    } 

    func updateValue(ofSlider slider: HAVerticalSlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool ) {
        
        if isTrackingLeftHandler {
            if slider == slider1 {
                lblLeftView_Slider1.text = String(format: "%d", Int(slider.leftValue))
            }
        }
        else if isTrackingRightHandler {
            if slider == slider1 {
                lblRightView_Slider1.text = String(format: "%d", Int(slider.rightValue))
            }
            
        }
    }
}


extension VerticalSliderViewController: VerticalSliderDelegate {
    func beginTracking(verticalSlider slider: HAVerticalSlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingRightHandler)
    }
    
    func continueTracking(verticalSlider slider: HAVerticalSlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingRightHandler)
    }
    
    func endTracking(verticalSlider slider: HAVerticalSlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingRightHandler)
    } 
}
