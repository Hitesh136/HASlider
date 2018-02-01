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
        slider1.topTipView = leftView_Slider1
        
        //Set Right view over handler
        slider1.bottomTipView = rightView_Slider1
        
        //Text in left custom view
        lblLeftView_Slider1.text = String(format: "%d", Int(slider1.topValue))
        
        //Text in right custom view
        lblRightView_Slider1.text = String(format: "%d", Int(slider1.bottomValue))
        
        //Delegte to get callback of slider touch events.
        slider1.delegate = self
    } 

    func updateValue(ofSlider slider: HAVerticalSlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool ) {
        
        if isTrackingLeftHandler {
            if slider == slider1 {
                lblLeftView_Slider1.text = String(format: "%d", Int(slider.topValue))
            }
        }
        else if isTrackingRightHandler {
            if slider == slider1 {
                lblRightView_Slider1.text = String(format: "%d", Int(slider.bottomValue))
            }
            
        }
    }
}


extension VerticalSliderViewController: VerticalSliderDelegate {
    func beginTracking(verticalSlider slider: HAVerticalSlider, isTrackingTopHandler isTrackingLeftHandler: Bool, isTrackingBottomHandler isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingLeftHandler)
    }
    
    func continueTracking(verticalSlider slider: HAVerticalSlider, isTrackingTopHandler isTrackingLeftHandler: Bool, isTrackingBottomHandler isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingRightHandler)
    }
    
    func endTracking(verticalSlider slider: HAVerticalSlider, isTrackingTopHandler isTrackingLeftHandler: Bool, isTrackingBottomHandler isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingRightHandler)
    } 
}
