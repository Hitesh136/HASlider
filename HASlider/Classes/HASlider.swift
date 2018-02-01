import UIKit
import Foundation

//MARK:- Protocol
public protocol SliderDelegate {
    func beginTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
    func continueTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
    func endTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool)
}
 
 

@IBDesignable
open class HASlider: UIControl {
    
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
    
    @IBInspectable
    open var lineWidth: CGFloat = 0.0
    
    @IBInspectable
    open var lineHeight: CGFloat = 0.0 {
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
            updateLineCorner()
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
  
    
    open var delegate: SliderDelegate?
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
    func setup() {
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
    
    func isTouchRightHandler(location: CGPoint) -> Bool {
        
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
    
    func positionForValue(value: CGFloat) -> CGFloat {
        let availableGap = lineHeight - leftHandlerHeight
        let v1 = availableGap * (value - minimumValue)
        let v2 = (maximumValue - minimumValue)
        return (v1 / v2)
    }
}

//MARK:- Draw Frames
extension HASlider {
    
   fileprivate func drawSliderLine() {
         
        lineY = (frame.height - 45)
        lineX = 0.0
        lineWidth = frame.width
        
        sliderLine.frame = CGRect(x: lineX, y: lineY, width: lineWidth, height: lineHeight)
        if roundCorner {
            sliderLine.cornerRadius = lineHeight / 2
        }
        sliderLine.backgroundColor = lineBackgroundColor.cgColor
        sliderLine.zPosition = slideLineZposition
        self.layer.addSublayer(sliderLine)
    }
    
    fileprivate func drawLeftSelectionLine() {
        
        leftSelectionLine.frame = getLeftSelectionLineFrame()
        leftSelectionLine.zPosition = selectionLineZposition
        if roundCorner {
            leftSelectionLine.cornerRadius = lineHeight / 2
        }
        leftSelectionLine.backgroundColor = leftSelectionColor.cgColor
        self.layer.addSublayer(leftSelectionLine)
    }
    
    fileprivate func drawMiddleSelectionLine() {
        
        middleSelectionLine.frame = getMiddleSelectionFrame()
        middleSelectionLine.zPosition = selectionLineZposition
        if roundCorner {
            middleSelectionLine.cornerRadius = lineHeight / 2
        }
        middleSelectionLine.zPosition = selectionLineZposition
        middleSelectionLine.backgroundColor = middleSelectionColor.cgColor
        self.layer.addSublayer(middleSelectionLine)
    }
    
    fileprivate func drawRightSelectionLine() {
        
        rightSelectionLine.frame = getRightSelectionFrame()
        rightSelectionLine.zPosition = selectionLineZposition
        if roundCorner {
            rightSelectionLine.cornerRadius = lineHeight / 2
        }
        rightSelectionLine.backgroundColor = rightSelectionColor.cgColor
        self.layer.addSublayer(rightSelectionLine)
    }
    
    fileprivate func drawLeftTipView() {
        
        let minY = leftHandler.frame.origin.y
        let availableY = minY - 10.0
        //Check if left tip view frame height is greater than available space.
        if leftTipView.frame.height > availableY {
            print(kAlertLeftTipMinSpace)
            return
        }
        
        leftTipView.layer.zPosition = 1
        self.addSubview(leftTipView)
        updateLeftTipViewPosition()
    }
    
    fileprivate func drawRightTipView() {
        
        let minY = rightHandler.frame.origin.y
        let availableY = minY - 10.0
        //Check if Right tip view frame height is greater than available space.
        if rightHandler.frame.height > availableY {
            print(kAlertRightTipMinSpace)
            return
        }
        
        rightTipView.layer.zPosition = 1
        self.addSubview(rightTipView)
        updateRightTipViewPosition()
    }
    
}

//MARK:- Get Frames
extension HASlider {
    
    //Handlers frame
    fileprivate func getHandlerFrame(forValue value: CGFloat) -> CGRect{
        
        handlerX = positionForValue(value: value)
        handlerY = (lineY + (lineHeight / 2 )) - (leftHandlerHeight / 2)
        return CGRect(x: handlerX, y: handlerY, width: leftHandlerWidth, height: leftHandlerHeight)
    }
    
    //SelectionLine Frames
    fileprivate func getLeftSelectionLineFrame() -> CGRect {
        
        //Starting Point
        let startingPoint = CGPoint(x: 0.0, y: lineY)
        
        //End Point
        let endX = positionForValue(value: leftValue)
        let endPoint = CGPoint(x: endX, y: lineY)
        
        let width = startingPoint.x + (endPoint.x + leftHandlerWidth / 2)
        
        return CGRect(x: startingPoint.x, y: lineY, width: width, height: lineHeight)
    }
    
    fileprivate func getMiddleSelectionFrame() -> CGRect {
        
        var startX = positionForValue(value: leftValue)
        startX = startX + ( leftHandlerWidth / 2 )
        let startingPoint = CGPoint(x: startX, y: lineY)
        
        //Ending Point
        var endX: CGFloat = 0.0
        if disableRange {
            endX = sliderLine.frame.width
        }
        else {
            endX = positionForValue(value: rightValue)
            endX = endX + ( leftHandlerWidth / 2 )
        }
        
        let endPoint = CGPoint(x: endX, y: lineY)
        let width = endPoint.x - startingPoint.x
        return  CGRect(x: startingPoint.x, y: lineY, width: width, height: lineHeight)
    }
    
    fileprivate func getRightSelectionFrame() -> CGRect {
        
        //Starting point
        var startX = positionForValue(value: rightValue)
        startX = startX + ( leftHandlerWidth / 2 )
        
        //Ending Point
        let width = sliderLine.frame.width - startX
        
        return CGRect(x: startX, y: lineY, width: width, height: lineHeight)
    }
}

//MARK:- Update Frames
extension HASlider {
    
    //Update tip positions
    fileprivate func updateLeftTipViewPosition() {
        
        let xPosition = positionForValue(value: leftValue)
        updateZpositionOfHandler()
        if xPosition <= sliderLine.frame.origin.x {
            leftTipView.center.x = sliderLine.frame.origin.x + (leftHandlerWidth / 2)
        }
        else {
            leftTipView.center.x = xPosition + (leftHandlerWidth / 2)
        }
    }
    
    fileprivate func updateRightTipViewPosition() {
        
        //if range is disable than rightTipView is not visible
        if disableRange {
            return
        }
        
        let xPosition = positionForValue(value: rightValue)
        updateZpositionOfHandler()
        if xPosition >= lineWidth {
            rightTipView.center.x = lineWidth - (leftHandlerWidth / 2)
        }
        else {
            rightTipView.center.x = xPosition + (leftHandlerWidth / 2 )
        }
    }
    
    //Update handler positions
    fileprivate func updateLeftHandlerPosition(){
        
        // Check if left handler cross right handler
        var newX = positionForValue(value: leftValue)
        
        if disableRange {
            // if range is diable than check if handler reach don't reach beyond line.
            let maximumX = sliderLine.frame.maxX - leftHandlerWidth
            print(maximumX)
            if newX >= maximumX {
                newX = maximumX
            }
        }
        else {
            // Stop lefthandler to reach ahead from right handler in right side
            let rightHandlerX = rightHandler.frame.origin.x
            if newX >= rightHandlerX{
                newX = rightHandlerX
            }
        }
        
        //check if handler move outside line
        if newX <= sliderLine.frame.minX {
            newX = sliderLine.frame.minX
        }
        
        //update previous location of left hanlder
        leftHandlerPreviousLocation = CGPoint(x: newX + (leftHandlerWidth / 2), y: leftHandlerPreviousLocation.y)
        leftHandler.frame.origin.x = newX
        
    }
    
    fileprivate func updateRightHandlerPosition() {
        
        var newX = positionForValue(value: rightValue)
        
        //Check if right handler cross left handler
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
    
    //Update value
    fileprivate func upateLeftValue(touch: UITouch) {
        
        let location = touch.location(in: self)
        
        //Determine by how much user dragged
        let deltaLocation = location.x - leftHandlerPreviousLocation.x
        let deltaValue = ( maximumValue - minimumValue ) * ( deltaLocation  / lineWidth )
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
    
    //Make Slider Line round corner
    fileprivate func updateLineCorner() {
        let radius = lineHeight / 2
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
        
        leftHandlerPreviousLocation = CGPoint(x: leftHandler.frame.origin.x, y: handlerY)
        
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
        
        rightHandlerPreviousLocation = CGPoint(x: rightHandler.frame.origin.x, y: handlerY)
        
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
extension HASlider {
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        //Get which handler touched
        isTrackingLeftHanlder = isTouchLeftHandler(location: location)
        isTrackingRightHanlder = isTouchRightHandler(location:  location)
        
        //Call delegates functions.
        delegate?.beginTracking(slider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        
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
        
        delegate?.continueTracking(slider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        
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
        delegate?.endTracking(slider: self, isTrackingLeftHandler: isTrackingLeftHanlder, isTrackingRightHandler: isTrackingRightHanlder)
        isTrackingLeftHanlder = false
        isTrackingRightHanlder = false
    }
}


