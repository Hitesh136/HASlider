//
//  HAVerticalSlider.swift
//  HASlider
//
//  Created by Hitesh Agarwal on 01/02/18.
//

import UIKit
import Foundation

//MARK:- Protocol
public protocol VerticalSliderDelegate {
    func beginTracking(verticalSlider slider: HAVerticalSlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
    func continueTracking(verticalSlider slider: HAVerticalSlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
    func endTracking(verticalSlider slider: HAVerticalSlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
}

//MARK:- Global Constant 

@IBDesignable
open class HAVerticalSlider: UIControl {
    //MARK:- Left Handler variables
    var leftHandler = CALayer()
    var handlerY: CGFloat = 0.0
    var handlerX: CGFloat = 0.0
    
    var leftHandlerPreviousLocation = CGPoint(x: 0.0, y: 0.0)
    var leftHandlerWidth:CGFloat = 31.0
    var leftHandlerHeight:CGFloat = 31.0
    var isTrackingLeftHanlder = false
    
    @IBInspectable
    open var leftHandlerColor: UIColor = UIColor.gray {
        didSet {
            leftHandler.backgroundColor = leftHandlerColor.cgColor
        }
    }
    
    @IBInspectable
    open var leftHandlerImage: UIImage? = nil {
        didSet{
            if let image = leftHandlerImage {
                let size = image.size
                leftHandlerWidth = size.width
                leftHandlerHeight = size.height
            }
        }
    }
    open var leftTipView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    //MARK:- Right Handler variables
    var rightHandler = CALayer()
    var rightHandlerWidth:CGFloat = 31.0
    var rightHandlerHeight:CGFloat = 31.0
    var isTrackingRightHanlder = false
    var rightHandlerPreviousLocation = CGPoint(x: 0, y: 0 )
    
    @IBInspectable
    open var rightHandlerColor: UIColor = UIColor.gray {
        didSet {
            rightHandler.backgroundColor = rightHandlerColor.cgColor
        }
    }
    
    @IBInspectable
    open var rightHandlerImage: UIImage? = nil {
        didSet{
            if let image = rightHandlerImage {
                let size = image.size
                rightHandlerWidth = size.width
                rightHandlerHeight = size.height
            }
        }
    }
    
    open var rightTipView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    //MARK:- Line Variables
    var sliderLine = CALayer()
    var lineX: CGFloat = 0.0
    var lineY: CGFloat = 0.0
    var lineHeight: CGFloat = 0.0
    
    @IBInspectable
    open var lineWidth: CGFloat = 0.0 {
        didSet{ 
            sliderLine.frame = CGRect(x: lineX, y: lineY, width: lineWidth, height: lineHeight)
            updateLeftHanlderFrame(addInView: false)
            updateRightHanlderFrame(addInView: false)
            updateLineCorner()
        }
    }
    
    @IBInspectable
    open var roundCorner: Bool = false {
        didSet {
            self.updateLineCorner()
        }
    }
    
    @IBInspectable
    open var lineBackgroundColor:UIColor = UIColor.gray {
        didSet{
            sliderLine.backgroundColor = lineBackgroundColor.cgColor
        }
    }
    
    //MARK:- Values Variables
    @IBInspectable
    open var minimumValue: CGFloat = 0.0
    
    @IBInspectable
    open var maximumValue: CGFloat = 100.0
    
    @IBInspectable
    open var leftValue: CGFloat = 0.0 {
        didSet {
            updateLeftHandlerPosition()
            updateLeftTipViewPosition()
            updateLeftSelectionLineWidth()
            updateMiddleSelectionLineWidth()
            updateRightSelectionLineWidth()
        }
    }
    
    @IBInspectable
    open var rightValue: CGFloat = 5.0 {
        didSet{
            updateRightHandlerPosition()
            updateRightTipViewPosition()
            updateLeftSelectionLineWidth()
            updateMiddleSelectionLineWidth()
            updateRightSelectionLineWidth()
        }
    }
    
    //MARK:- Selection Variables
    var leftSelectionLine = CALayer()
    var middleSelectionLine = CALayer()
    var rightSelectionLine = CALayer()
    @IBInspectable
    open var leftSelectionColor: UIColor = UIColor.blue {
        didSet{
            leftSelectionLine.backgroundColor = leftSelectionColor.cgColor
        }
    }
    
    //  Selection Color between left handler and right handler
    @IBInspectable
    open var middleSelectionColor: UIColor = UIColor.red {
        didSet {
            middleSelectionLine.backgroundColor = middleSelectionColor.cgColor
        }
    }
    
    //  Selcetion Color between right handler and end of line
    @IBInspectable
    open var rightSelectionColor: UIColor = UIColor.green {
        didSet {
            rightSelectionLine.backgroundColor = rightSelectionColor.cgColor
        }
    }
    
    
    //MARK:- Other Variables
    open var delegate: VerticalSliderDelegate?
    @IBInspectable
    open var disableRange: Bool = false {
        didSet {
            if disableRange {
                rightHandler.isHidden = true
                rightTipView.isHidden = true
                rightValue = maximumValue
                rightSelectionLine.isHidden = true
            }
            else {
                rightHandler.isHidden = false
                rightTipView.isHidden = false
                rightSelectionLine.isHidden = false
            }
            layoutSubviews()
        }
    }
    
    //MARK:- View LifeCycle
    open override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- Helper Methods
    fileprivate func setup() {
        drawSliderLine()
        updateLeftHanlderFrame(addInView: true)
        updateRightHanlderFrame(addInView: true)
        drawLeftSelectionLine()
        drawMiddleSelectionLine()
        drawRightSelectionLine()
        
        updateLeftHandlerPosition()
        updateRightHandlerPosition()
        
        drawLeftTipView()
        drawRightTipView()
    }
    
    func reload() {
        leftValue = minimumValue
        rightValue = maximumValue
        setup()
    }
    
    fileprivate func isTouchRightHandler(location: CGPoint) -> Bool {
        
        //Check if slider type in single handler
        if disableRange {
            return false
        }
        
        let totalX = rightHandler.frame.origin.x + rightHandler.frame.width
        let totalY = rightHandler.frame.origin.y + rightHandler.frame.height
        
        // Check if left Handler above right handler
        if leftHandler.zPosition > rightHandler.zPosition {
            return false
        }
        
        // if touch location inside handler frame
        if ( location.x >= rightHandler.frame.origin.x && location.x <= totalX ) &&  ( location.y >= rightHandler.frame.origin.y && location.y <= totalY ){
            return true
        }
        return false
    }
    
    fileprivate func isTouchLeftHandler(location: CGPoint) -> Bool {
        let totalX = leftHandler.frame.origin.x + leftHandler.frame.width
        let totalY = leftHandler.frame.origin.y + leftHandler.frame.height
        
        //Check if right handler is above left handler
        if leftHandler.zPosition < rightHandler.zPosition {
            return false
        }
        
        // if touch location inside handler frame
        if (location.x >= leftHandler.frame.origin.x && location.x <= totalX) && ( location.y >= leftHandler.frame.origin.y && location.y <= totalY ) {
            return true
        }
        return false
    }
    
    fileprivate func positionForValue(value: CGFloat) -> CGFloat {
        let availableGap = frame.height - leftHandlerHeight
        let v1 = availableGap * (value - minimumValue)
        let v2 = (maximumValue - minimumValue)
        return (v1 / v2)
    }
}

//MARK:- Draw Frames
extension HAVerticalSlider {
    
   fileprivate  func drawSliderLine() {
    
        lineX = 20.0
        lineY = 0.0
        lineHeight = self.frame.height
    
        sliderLine.frame = CGRect(x: lineX, y: lineY, width: lineWidth, height: lineHeight)
        if roundCorner {
            sliderLine.cornerRadius = lineWidth / 2
        }
        sliderLine.backgroundColor = lineBackgroundColor.cgColor
        sliderLine.zPosition = slideLineZposition
        self.layer.addSublayer(sliderLine)
    }
    
    fileprivate func drawLeftSelectionLine() {
        
        leftSelectionLine.frame = getLeftSelectionLineFrame()
        leftSelectionLine.zPosition = selectionLineZposition
        
        if roundCorner {
            leftSelectionLine.cornerRadius = lineWidth / 2
        }
        leftSelectionLine.backgroundColor = leftSelectionColor.cgColor
        self.layer.addSublayer(leftSelectionLine)
    }
    
    fileprivate func drawMiddleSelectionLine() {
        
        middleSelectionLine.frame = getMiddleSelectionFrame()
        middleSelectionLine.zPosition = selectionLineZposition
        
        if roundCorner {
            middleSelectionLine.cornerRadius = lineWidth / 2
        }
        middleSelectionLine.backgroundColor = middleSelectionColor.cgColor
        self.layer.addSublayer(middleSelectionLine)
    }
    
    fileprivate func drawRightSelectionLine() {
        
        rightSelectionLine.frame = getRightSelectionFrame()
        rightSelectionLine.zPosition = selectionLineZposition
        
        if roundCorner {
            rightSelectionLine.cornerRadius = lineWidth / 2
        }
        rightSelectionLine.backgroundColor = rightSelectionColor.cgColor
        self.layer.addSublayer(rightSelectionLine)
    }
    
    fileprivate func drawLeftTipView() {
    
        let minX = leftHandler.frame.origin.x + leftHandlerWidth + 30.0
        let availableX = frame.width - minX
        //Check if left tip view frame height is greater than available space.
        if leftTipView.frame.width > availableX {
            print(kAlertLeftTipMinSpace)
            return
        }
        
        leftTipView.layer.zPosition = 1
        leftTipView.frame.origin.x = minX
        self.addSubview(leftTipView)
        updateLeftTipViewPosition()
    }
    
    fileprivate func drawRightTipView() {
        
        let minX = rightHandler.frame.origin.x + rightHandlerWidth +  30.0
        let availableX = frame.width - minX
        //Check if left tip view frame height is greater than available space.
        if rightTipView.frame.width > availableX {
            print(kAlertLeftTipMinSpace)
            return
        }
        rightTipView.layer.zPosition = 1
        rightTipView.frame.origin.x = minX
        self.addSubview(rightTipView)
        updateRightTipViewPosition()
    }
    
}

//MARK:- Get Frames
extension HAVerticalSlider {
    
    //Handlers frame
    fileprivate func getHandlerFrame(forValue value: CGFloat) -> CGRect{
        
        handlerY = positionForValue(value: value)
        handlerX = (lineX + (lineWidth / 2 )) - (leftHandlerWidth / 2)
        return CGRect(x: handlerX, y: handlerY, width: leftHandlerWidth, height: leftHandlerHeight)
    }
    
    //SelectionLine Frames
    fileprivate func getLeftSelectionLineFrame() -> CGRect {
        //Starting Point
        let startingPoint = CGPoint(x: lineX, y: lineY)
        
        //End Point
        let endY = positionForValue(value: leftValue)
        let endPoint = CGPoint(x: lineX, y: endY)
        
        let height = startingPoint.y + (endPoint.y + leftHandlerHeight / 2)
        
        return CGRect(x: lineX, y: lineY, width: lineWidth, height: height)
    }
    
    fileprivate func getMiddleSelectionFrame() -> CGRect {
        //Starting point
        var startY = positionForValue(value: leftValue)
        startY = startY + ( leftHandlerHeight / 2 )
        let startingPoint = CGPoint(x: lineX, y: startY)
        
        //Ending Point
        var endY: CGFloat = 0.0
        if disableRange {
            endY = sliderLine.frame.height
        }
        else {
            endY = positionForValue(value: rightValue)
            endY = endY + ( leftHandlerHeight / 2 )
        }
        
        let endPoint = CGPoint(x: lineX, y: endY)
        let height = endPoint.y - startingPoint.y
        return  CGRect(x: lineX, y: startingPoint.y, width: lineWidth, height: height)
    }
    
    fileprivate func getRightSelectionFrame() -> CGRect {
        //Starting point
        var startY = positionForValue(value: rightValue)
        startY = startY + ( leftHandlerHeight / 2 )
        
        //Ending Point
        let height = sliderLine.frame.height - startY
        
        return CGRect(x: lineX, y: startY, width: lineWidth, height: height)
    }
}

//MARK:- Update Frames
extension HAVerticalSlider {
    
    //Update tip positions
    fileprivate func updateLeftTipViewPosition() {
        let yPosition = positionForValue(value: leftValue)
        updateZpositionOfHandler()
        if yPosition <= sliderLine.frame.origin.y {
            leftTipView.center.y = sliderLine.frame.origin.y + (leftHandlerHeight / 2)
        }
        else {
            leftTipView.center.y = yPosition + (leftHandlerHeight / 2)
        }
    }
    
    fileprivate func updateRightTipViewPosition() {
        //if range is disable than rightTipView is not visible
        if disableRange {
            return
        }
        
        let yPosition = positionForValue(value: rightValue)
        updateZpositionOfHandler()
        if yPosition >= lineHeight {
            rightTipView.center.y = lineHeight - (leftHandlerHeight / 2)
        }
        else {
            rightTipView.center.y = yPosition + (leftHandlerHeight / 2 )
        }
        
    }
    
    //Update handler positions
    fileprivate func updateLeftHandlerPosition(){
        
        // Check if left handler cross right handler
        var newY = positionForValue(value: leftValue)
        
        if disableRange {
            // if range is diable than check if handler reach don't reach beyond line.
            let maximumY = sliderLine.frame.maxY - leftHandlerHeight
            if newY >= maximumY {
                newY = maximumY
            }
        }
        else {
            // Stop lefthandler to reach ahead from right handler in right side
            let rightHandlerY = rightHandler.frame.origin.y
            if newY >= rightHandlerY {
                newY = rightHandlerY
            }
        }
        
        //check if handler move outside line
        if newY <= sliderLine.frame.minY {
            newY = sliderLine.frame.minY
        }
        
        //update previous location of left hanlder
        leftHandlerPreviousLocation = CGPoint(x: leftHandlerPreviousLocation.x, y: newY + (leftHandlerHeight / 2))
        leftHandler.frame.origin.y = newY
    }
    
    fileprivate func updateRightHandlerPosition() {
        
        var newY = positionForValue(value: rightValue)
        
        //Check if right handler cross left handler
        if newY <= leftHandler.frame.origin.y {
            newY = leftHandler.frame.origin.y
        }
        
        //Check if hanlder move outside line
        let maxY = sliderLine.frame.maxY + (leftHandlerHeight / 2)
        if newY >= maxY {
            newY = maxY
        }
        
        //update handler previos location
        rightHandlerPreviousLocation = CGPoint(x: rightHandlerPreviousLocation.x, y: newY + (leftHandlerHeight / 2))
        rightHandler.frame.origin.y = newY
    }
    //Update Selection lines width
    fileprivate func updateLeftSelectionLineWidth() {
        leftSelectionLine.frame = getLeftSelectionLineFrame()
    }
    
    fileprivate func updateMiddleSelectionLineWidth() {
        middleSelectionLine.frame = getMiddleSelectionFrame()
    }
    
    fileprivate func updateRightSelectionLineWidth() {
        rightSelectionLine.frame = getRightSelectionFrame()
    }
    
    fileprivate func updateZpositionOfHandler() {
        let leftMaxX = leftTipView.frame.origin.y + leftTipView.frame.height
        let rightMinx = rightTipView.frame.origin.y
        if leftMaxX > rightMinx {
            if isTrackingLeftHanlder {
                leftTipView.layer.zPosition = handlerHigherZPosition
                rightTipView.layer.zPosition = handlerLowerZPosition
                leftHandler.zPosition = handlerHigherZPosition
                rightHandler.zPosition = handlerLowerZPosition
            }
            else if isTrackingRightHanlder {
                leftTipView.layer.zPosition = handlerLowerZPosition
                rightTipView.layer.zPosition = handlerHigherZPosition
                leftHandler.zPosition = handlerLowerZPosition
                rightHandler.zPosition = handlerHigherZPosition
            }
        }
        else {
            leftTipView.layer.zPosition = handlerLowerZPosition
            rightTipView.layer.zPosition = handlerLowerZPosition
            leftHandler.zPosition = handlerLowerZPosition
            rightHandler.zPosition = handlerLowerZPosition
        }
    }
    
    //Update value
    fileprivate func upateLeftValue(touch: UITouch) {
        
        let location = touch.location(in: self)
        
        //Determine by how much user dragged
        let deltaLocation = location.y - leftHandlerPreviousLocation.y
        let deltaValue = ( maximumValue - minimumValue ) * ( deltaLocation  / lineHeight )
        var newValue = leftValue + deltaValue
        
        //new value can't be less than minimumvalue
        if newValue <= minimumValue {
            newValue = minimumValue
        }
        
        if disableRange {
            //If range is disable than new value can't be greater than maximum vlaue
            if newValue >= maximumValue {
                newValue = maximumValue
            }
        }
        else {
            //If range is enable than new value can't be greater than right value
            if newValue >= rightValue {
                newValue = rightValue
            }
        }
        leftValue = newValue
    }
    
    fileprivate func updateRightValue(touch: UITouch) {
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = location.y - rightHandlerPreviousLocation.y
        let deltaValue = (maximumValue - minimumValue) * deltaLocation  / (lineHeight + (rightHandlerHeight / 2))
        var newValue = rightValue + deltaValue
        
        //If new value greater than equal to maximum value than assign maximum value in new value
        if newValue >= maximumValue {
            newValue = maximumValue
        }
            //If new value in less than lefthanlder's value than assign left value in new value
        else if newValue <= leftValue {
            newValue = leftValue
        }
        rightValue = newValue
    }
    
    //Make Slider Line round corner
    fileprivate func updateLineCorner() { 
        let radius = lineWidth / 2
        if roundCorner {
            sliderLine.cornerRadius = radius
            middleSelectionLine.cornerRadius = radius
            leftSelectionLine.cornerRadius = radius
            rightSelectionLine.cornerRadius = radius
        }
        else {
            sliderLine.cornerRadius = 0.0
            leftSelectionLine.cornerRadius = 0.0
            middleSelectionLine.cornerRadius = 0.0
            rightSelectionLine.cornerRadius = 0.0
        }
    }
    
    //Update handler frames
    fileprivate func updateLeftHanlderFrame(addInView isAddSubLayer: Bool) {
        
        // Parameter isAddsublayer use to check if lefthandler need to add layer in view. if view is already added and only need to get update than isAddSublayer is false.
        
        leftHandler.zPosition = handlerLowerZPosition
        leftHandler.frame = getHandlerFrame(forValue: leftValue)
        leftHandler.backgroundColor = leftHandlerColor.cgColor
        leftHandler.cornerRadius = (leftHandlerHeight / 2)
        leftHandlerPreviousLocation = CGPoint(x: handlerX, y: leftHandler.frame.origin.y)
        
        if let image = leftHandlerImage {
            leftHandler.contents = image.cgImage
            leftHandler.backgroundColor = UIColor.clear.cgColor
        }
        
        if isAddSubLayer {
            self.layer.addSublayer(leftHandler)
        }
    }
    
    fileprivate func updateRightHanlderFrame(addInView isAddSubLayer: Bool = true ) {
        
        // Parameter isAddsublayer use to check if righthandler need to add layer in view. if view is already added and only need to get update than isAddSublayer is false.
        
        rightHandler.zPosition = handlerLowerZPosition
        rightHandler.frame = getHandlerFrame(forValue: rightValue)
        rightHandler.backgroundColor = rightHandlerColor.cgColor
        rightHandler.cornerRadius = (rightHandlerHeight / 2)
        
        rightHandlerPreviousLocation = CGPoint(x: handlerX, y: rightHandler.frame.origin.y)
        
        if let image = rightHandlerImage {
            rightHandler.contents = image.cgImage
            rightHandler.backgroundColor = UIColor.clear.cgColor
        }
        
        if isAddSubLayer {
            self.layer.setValue(FrameTag.tag_RightHandler, forKey: KRightHandler)
            self.layer.addSublayer(rightHandler)
        }
    }
    
}

//MARK:- Touch EventsDelegates
extension HAVerticalSlider {
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        //Get which handler touched
        isTrackingLeftHanlder = isTouchLeftHandler(location: location)
        isTrackingRightHanlder = isTouchRightHandler(location:  location)
        
        //Call delegates functions.
        delegate?.beginTracking(verticalSlider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        
        //Update Both Tip View postion.
        updateLeftTipViewPosition()
        updateRightTipViewPosition()
        
        if isTrackingLeftHanlder {
            leftHandlerPreviousLocation = location
        }
        else if isTrackingRightHanlder {
            rightHandlerPreviousLocation = location
        }
        updateLeftSelectionLineWidth()
        updateMiddleSelectionLineWidth()
        updateRightSelectionLineWidth()
        return true
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        delegate?.continueTracking(verticalSlider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        
        //Update both tip view according to new value
        updateLeftTipViewPosition()
        updateRightTipViewPosition()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if isTrackingLeftHanlder {
            upateLeftValue(touch: touch)
        }
        else if isTrackingRightHanlder {
            updateRightValue(touch: touch)
        }
        updateLeftSelectionLineWidth()
        updateMiddleSelectionLineWidth()
        updateRightSelectionLineWidth()
        CATransaction.commit()
        
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.endTracking(verticalSlider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        isTrackingLeftHanlder = false
        isTrackingRightHanlder = false
    }
}



