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
    
    //View for first slider
    @IBOutlet var leftView_Slider1: UIView!
    @IBOutlet var rightView_Slider1: UIView!
    @IBOutlet weak var lblLeft_Slider1: UILabel!
    @IBOutlet weak var lblRight_Slider1: UILabel!
    @IBOutlet weak var slider1: HASlider!
    
    //View for second slider
    @IBOutlet weak var leftView_Slider2: UIView!
    @IBOutlet weak var rightView_Slider2: UIView!
    @IBOutlet weak var lblLeft_Slider2: UILabel!
    @IBOutlet weak var lblRight_Slider2: UILabel!
    @IBOutlet weak var slider2: HASlider!
    
    //View for thired slider
    @IBOutlet var tipView_Slider3: UIView!
    @IBOutlet weak var slider3: HASlider!
    @IBOutlet weak var lblValue_Slider3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        // First Slider 
        
        //Set Left view over handler
        slider1.leftTipView = leftView_Slider1
        
        //Set Right view over handler
        slider1.rightTipView = rightView_Slider1
        
        //Text in left custom view
        lblLeft_Slider1.text = String(format: "%d", Int(slider1.leftValue))
        
        //Text in right custom view
        lblRight_Slider1.text = String(format: "%d", Int(slider1.rightValue))
        
        //Delegte to get callback of slider touch events.
        slider1.delegate = self 
        //Second Slider
        
        slider2.leftTipView = leftView_Slider2
        slider2.rightTipView = rightView_Slider2
        
        lblLeft_Slider2.text = String(format: "%d AM", Int(slider2.leftValue))
        lblRight_Slider2.text = String(format: "%d PM", Int(slider2.rightValue) - 12)
        
        slider2.delegate = self
        
        //Thired Slider
        slider3.leftTipView = tipView_Slider3
        lblValue_Slider3.text = String(format: "%d", Int(slider3.leftValue))
        slider3.delegate = self
        
    } 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateValue(ofSlider slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool ) {
        
        if isTrackingLeftHandler {
            if slider == slider1 {
                lblLeft_Slider1.text = String(format: "%d", Int(slider.leftValue))
            }
            else if slider == slider2 {
                var value = Int(slider.leftValue)
                if value < 12 {
                    lblLeft_Slider2.text = String(format: "%d AM", value)
                }
                else if value >= 12 {
                    if value > 12 {
                        value = value - 12
                    }
                    lblLeft_Slider2.text = String(format: "%d PM", value )
                }
            }
            else if slider == slider3 {
                lblValue_Slider3.text = String(format: "%d", Int(slider.leftValue))
            }
        }
        else if isTrackingRightHandler {
            if slider == slider1 {
                lblRight_Slider1.text = String(format: "%d", Int(slider.rightValue))
            }
            else if slider == slider2 {
                var value = Int(slider.rightValue)
                if value < 12 {
                    lblRight_Slider2.text = String(format: "%d AM", value)
                }
                else if value >= 12 {
                    if value > 12 {
                        value = value - 12
                    }
                    lblRight_Slider2.text = String(format: "%d PM", value)
                } 
            }
        }
    }
}

extension ViewController: SliderDelegate {
    func beginTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingRightHandler)
    }
    
    func continueTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingRightHandler)
    }
    
    func endTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        updateValue(ofSlider: slider, isTrackingLeftHandler: isTrackingLeftHandler, isTrackingRightHandler: isTrackingRightHandler)
    } 
}

