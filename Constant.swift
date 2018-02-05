//
//  Constant.swift
//  HASlider
//
//  Created by Hitesh Agarwal on 01/02/18.
//

import UIKit

//MARK:- Enums
enum FrameTag: Int {
    case tag_Line, tag_LeftHandler, tag_RightHandler, tag_LeftTipView, tag_RightTipView
}

let kAlertLeftTipMinSpace = "HASLIDER --- Left Tip View has more height than available space. Increase view height for see left tip view"
let kAlertRightTipMinSpace = "HASLIDER --- Right Tip View has more height than available space. Increase view height for see right tip view"
let handlerLowerZPosition:CGFloat = 300.0
let handlerHigherZPosition:CGFloat = 400.0
let slideLineZposition:CGFloat = 100.0
let selectionLineZposition:CGFloat = 200.0
