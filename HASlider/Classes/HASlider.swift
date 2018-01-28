import UIKit
import Foundation

public protocol SliderDelegate {
    func beginTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
    func continueTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
    func endTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
}

@IBDesignable
open class HASlider: UIControl {
    
    //MARK:- Variables
    var sliderLine = CALayer()
    var leftHandler = CALayer()
    var rightHandler = CALayer()
    var leftSelectionLine = CALayer()
    var middleSelectionLine = CALayer()
    var rightSelectionLine = CALayer()
    
    let handlerLowerZPosition:CGFloat = 3.0
    let handlerHigherZPosition:CGFloat = 4.0
    let slideLineZposition:CGFloat = 1.0
    let selectionLineZposition:CGFloat = 2.0
    
    open var leftTipView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) {
        didSet {
            leftTipView.layer.zPosition = 1
            self.addSubview(leftTipView)
            updateLeftTipViewPosition()
        }
    }
    open var rightTipView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30)) {
        didSet {
            rightTipView.layer.zPosition = 1
            self.addSubview(rightTipView)
            updateRightTipViewPosition()
        }
    }
    
    open var delegate: SliderDelegate?
    //MARK:- Line Variables
    
    @IBInspectable
    var lineHeight: CGFloat = 2.0 {
        didSet {
            sliderLine.frame = CGRect(x: sliderLine.frame.origin.x, y: sliderLine.frame.origin.y, width: lineWidth, height: lineHeight)
        }
    }
    
    @IBInspectable
    open var lineBackgroundColor:UIColor = UIColor.gray {
        didSet{
            sliderLine.backgroundColor = lineBackgroundColor.cgColor
        }
    }
    
    @IBInspectable
    open var minimumValue: CGFloat = 0.0
    
    @IBInspectable
    open var maximumValue: CGFloat = 10.0
    
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
    
    //selection color from left side to left handler
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
    
    @IBInspectable
    open var leftHandlerColor: UIColor = UIColor.gray {
        didSet {
            leftHandler.backgroundColor = leftHandlerColor.cgColor
        }
    }
    
    @IBInspectable
    open var rightHandlerColor: UIColor = UIColor.gray {
        didSet {
            rightHandler.backgroundColor = rightHandlerColor.cgColor
        }
    }
    
    @IBInspectable
    open var isRoundLine: Bool = false
    
    var lineWidth: CGFloat = 2.0
    var lineY: CGFloat = 0.0
    var handlerY: CGFloat = 0.0
    
    //MARK:- LeftHandler
    var leftHandlerPreviousLocation = CGPoint(x: 0.0, y: 0.0)
    let leftHandlerWidth:CGFloat = 31.0
    let leftHandlerHeight:CGFloat = 31.0
    var isTrackingLeftHanlder = false
    
    //MARK:- RightHandler
    let rightHandlerWidth:CGFloat = 31.0
    let rightHandlerHeight:CGFloat = 31.0
    var isTrackingRightHanlder = false
    var rightHandlerPreviousLocation = CGPoint(x: 0, y: 0 )
    
    //MARK:- TitleView
    open var leftTitleView: UIView? = nil
    open var rightTitleView: UIView? = nil
    
    //MARK:- SelectionLine
    
    
    //MARK:- View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        drawSliderLine()
        drawLeftHandler()
        drawRightHanlder()
        drawLeftSelectionLine()
        drawMiddleSelectionLine()
        drawRightSelectionLine()
    }
    
    //MARK:- Draw Methods
    func drawSliderLine() {
        lineWidth = self.frame.width
        lineY = (frame.height - 45)
        sliderLine.frame = CGRect(x: 0, y: lineY, width: lineWidth, height: lineHeight)
        if isRoundLine {
            sliderLine.cornerRadius = lineHeight / 2
        }
        sliderLine.backgroundColor = lineBackgroundColor.cgColor
        sliderLine.zPosition = slideLineZposition
        self.layer.addSublayer(sliderLine)
    }
    
    func drawLeftHandler() {
        let handlerX = positionForValue(value: leftValue)
        handlerY = (lineY + (lineHeight / 2 )) - (leftHandlerHeight / 2)
        leftHandler.frame = CGRect(x: handlerX, y: handlerY, width: leftHandlerWidth, height: leftHandlerHeight)
        leftHandler.backgroundColor = leftHandlerColor.cgColor
        leftHandler.cornerRadius = (leftHandlerHeight / 2)
        leftHandlerPreviousLocation = CGPoint(x: handlerX, y: handlerY)
        leftHandler.zPosition = handlerLowerZPosition
        self.layer.addSublayer(leftHandler)
    }
    
    func drawRightHanlder() {
        let handlerX = positionForValue(value: rightValue)
        rightHandler.frame = CGRect(x: handlerX, y: handlerY, width: rightHandlerWidth, height: rightHandlerHeight)
        rightHandler.backgroundColor = rightHandlerColor.cgColor
        rightHandler.cornerRadius = (rightHandlerHeight / 2)
        rightHandlerPreviousLocation = CGPoint(x: handlerX, y: handlerY)
        rightHandler.zPosition = handlerLowerZPosition
        self.layer.addSublayer(rightHandler)
    }
    
    func drawLeftSelectionLine() {
        
        leftSelectionLine.frame = getLeftSelectionLineFrame()
        leftSelectionLine.zPosition = selectionLineZposition
        
        if isRoundLine {
            leftSelectionLine.cornerRadius = lineHeight / 2
        }
        leftSelectionLine.backgroundColor = leftSelectionColor.cgColor
        self.layer.addSublayer(leftSelectionLine)
    }
    
    func drawMiddleSelectionLine() {
        
        middleSelectionLine.frame = getMiddleSelectionFrame()
        middleSelectionLine.zPosition = selectionLineZposition
        if isRoundLine {
            middleSelectionLine.cornerRadius = lineHeight / 2
        }
        middleSelectionLine.zPosition = selectionLineZposition
        middleSelectionLine.backgroundColor = middleSelectionColor.cgColor
        self.layer.addSublayer(middleSelectionLine)
    }
    
    func drawRightSelectionLine() {
        
        rightSelectionLine.frame = getRightSelectionFrame()
        rightSelectionLine.zPosition = selectionLineZposition
        
        if isRoundLine {
            rightSelectionLine.cornerRadius = lineHeight / 2
        }
        rightSelectionLine.backgroundColor = rightSelectionColor.cgColor
        self.layer.addSublayer(rightSelectionLine)
    }
    
    //MARK:- Position Updates Methods
    func updateLeftTipViewPosition() {
        
        let xPosition = positionForValue(value: leftValue)
        updateZpositionOfHandler()
        if xPosition <= sliderLine.frame.origin.x {
            leftTipView.center.x = sliderLine.frame.origin.x + (leftHandlerWidth / 2)
        }
        else {
            leftTipView.center.x = xPosition + (leftHandlerWidth / 2)
        }
    }
    
    func updateRightTipViewPosition() {
        let xPosition = positionForValue(value: rightValue)
        updateZpositionOfHandler()
        if xPosition >= lineWidth {
            rightTipView.center.x = lineWidth - (leftHandlerWidth / 2)
        }
        else {
            rightTipView.center.x = xPosition + (leftHandlerWidth / 2 )
        }
    }
    
    func updateLeftHandlerPosition(){
        
        // Check if left handler cross right handler
        var newX = positionForValue(value: leftValue)
        let rightHandlerX = rightHandler.frame.origin.x
        
        // Stop lefthandler to reach ahead from right handler in right side
        if newX >= rightHandlerX{
            newX = rightHandlerX
        }
        
        //check if handler move outside line
        if newX <= sliderLine.frame.minX {
            newX = sliderLine.frame.minX
        }
        
        //update previous location of left hanlder
        leftHandlerPreviousLocation = CGPoint(x: newX + (leftHandlerWidth / 2), y: leftHandlerPreviousLocation.y)
        leftHandler.frame.origin.x = newX
    }
    
    func updateRightHandlerPosition() {
        var newX = positionForValue(value: rightValue)
        
        //        Check if right handler cross left handler
        if newX <= leftHandler.frame.origin.x {
            newX = leftHandler.frame.origin.x
        }
        
        //Check if hanlder move outside line
        let maxX = sliderLine.frame.maxX + (leftHandlerWidth / 2)
        if newX >= maxX {
            newX = maxX
        }
        
        //update handler previos location
        rightHandlerPreviousLocation = CGPoint(x: newX + (leftHandlerWidth / 2), y: rightHandlerPreviousLocation.y)
        rightHandler.frame.origin.x = newX
    }
    
    func updateLeftSelectionLineWidth() {
        leftSelectionLine.frame = getLeftSelectionLineFrame()
    }
    
    func updateMiddleSelectionLineWidth() {
        middleSelectionLine.frame = getMiddleSelectionFrame()
    }
    
    func updateRightSelectionLineWidth() {
        rightSelectionLine.frame = getRightSelectionFrame()
        
    }
    
    func updateZpositionOfHandler() {
        let leftMaxX = leftTipView.frame.origin.x + leftTipView.frame.width
        let rightMinx = rightTipView.frame.origin.x
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
    
    //MARK:- Refresh Methods.
    func reload() {
        leftValue = minimumValue
        rightValue = maximumValue
        setup()
    }
    
    func refreshLeftHanlder(touch: UITouch) {
        
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = location.x - leftHandlerPreviousLocation.x
        let deltaValue = ( maximumValue - minimumValue ) * ( deltaLocation  / lineWidth )
        var newValue = leftValue + deltaValue
        if newValue <= minimumValue {
            newValue = minimumValue
        }
        else if newValue >= rightValue {
            newValue = rightValue
        }
        leftValue = newValue
    }
    
    func isTouchRightHandler(location: CGPoint) -> Bool {
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
    
    func isTouchLeftHandler(location: CGPoint) -> Bool {
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
    
    func refreshRightHandler(touch: UITouch) {
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = location.x - rightHandlerPreviousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation  / (lineWidth + (rightHandlerWidth / 2))
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
    
    //MARK:- Value Functions
    func positionForValue(value: CGFloat) -> CGFloat {
        let v1 = (lineWidth - leftHandlerWidth) * (value - minimumValue)
        let v2 = (maximumValue - minimumValue)
        return (v1 / v2)
    }
    
    //MARK:- SelectionLine Frames
    func getLeftSelectionLineFrame() -> CGRect {
        
        //Starting Point
        let startingPoint = CGPoint(x: 0.0, y: lineY)
        
        //End Point
        let endX = positionForValue(value: leftValue)
        let endPoint = CGPoint(x: endX, y: lineY)
        
        let width = startingPoint.x + (endPoint.x + leftHandlerWidth / 2)
        
        return CGRect(x: startingPoint.x, y: lineY, width: width, height: lineHeight)
    }
    
    func getMiddleSelectionFrame() -> CGRect {
        
        //Starting point
        var startX = positionForValue(value: leftValue)
        startX = startX + ( leftHandlerWidth / 2 )
        let startingPoint = CGPoint(x: startX, y: lineY)
        
        //Ending Point
        var endX = positionForValue(value: rightValue)
        endX = endX + ( leftHandlerWidth / 2 )
        let endPoint = CGPoint(x: endX, y: lineY)
        
        let width = endPoint.x - startingPoint.x
        return  CGRect(x: startingPoint.x, y: lineY, width: width, height: lineHeight)
    }
    
    func getRightSelectionFrame() -> CGRect {
        
        //Starting point
        var startX = positionForValue(value: rightValue)
        startX = startX + ( leftHandlerWidth / 2 )
        let startingPoint = CGPoint(x: startX, y: lineY)
        
        //Ending Point
        let width = sliderLine.frame.width - startX
        
        return CGRect(x: startingPoint.x, y: lineY, width: width, height: lineHeight)
    }
}

//MARK:- Touch Events Delegates
extension HASlider {
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        // Get which handler touched
        isTrackingLeftHanlder = isTouchLeftHandler(location: location)
        isTrackingRightHanlder = isTouchRightHandler(location:  location)
        
        // Call delegates functions.
        delegate?.beginTracking(slider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        
        // Update Both Tip View postion.
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
        
        delegate?.continueTracking(slider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        
        //Update both tip view according to new value
        updateLeftTipViewPosition()
        updateRightTipViewPosition()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if isTrackingLeftHanlder {
            refreshLeftHanlder(touch: touch)
        }
        else if isTrackingRightHanlder {
            refreshRightHandler(touch: touch)
        }
        updateLeftSelectionLineWidth()
        updateMiddleSelectionLineWidth()
        updateRightSelectionLineWidth()
        CATransaction.commit()
        
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.endTracking(slider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        isTrackingLeftHanlder = false
        isTrackingRightHanlder = false
    }
}


