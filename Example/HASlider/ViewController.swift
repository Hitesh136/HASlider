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
        //For show only one handler set disbable range true.And don't add right tip view.
        /* if disablerange = true
         slider.rightTipView = UIView()
         slider.disableRange = true
         
         left value becomes main value
         right selction color not active.
        */ 
        
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
        slider1.lineHeight = 10.0
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
    
    @IBAction func actionReload(_ sender: Any) {
        slider1.leftValue = 0
        slider1.rightValue = 100
        
        slider2.leftValue = 0
        slider2.rightValue = 100
        
        slider3.leftValue = 0
        slider3.rightValue = 100
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


/*

// isTrackingLeftHandler = check if tracking left handler
// isTrackingRightHandler = check if tracking right handler
extension ViewController: SliderDelegate {
    func beginTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        // Begin tracking of handler
    }
    
    func continueTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        // continuously moving handler
    }
    
    func endTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        // Stop moving handler
    }
    
}
*/
