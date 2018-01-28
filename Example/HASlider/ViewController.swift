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
        
        slider.leftTipView = leftView
        slider.rightTipView = rightView
        slider.leftValue = 0
        slider.rightValue = 100
        lblLeft.text = String(format: "%d", Int(slider.leftValue))
        lblRight.text = String(format: "%d", Int(slider.rightValue))
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

