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
    func beginTracking(verticalSlider slider: HAVerticalSlider, isTrackingTopHandler: Bool, isTrackingBottomHandler: Bool)
    func continueTracking(verticalSlider slider: HAVerticalSlider, isTrackingTopHandler: Bool, isTrackingBottomHandler: Bool)
    func endTracking(verticalSlider slider: HAVerticalSlider, isTrackingTopHandler: Bool, isTrackingBottomHandler: Bool)
}

//MARK:- Global Constant
let kSliderLine = "SliderLineLayer"
let kTopSelectionLine = "TopoSelectionLineLayer"
let kMiddleSlectionLine = "MiddleSelectionLayer"
let kBottomSelectionLine = "BottomSelectionLayer"
let kTopHandler = "TopHandler"
let kBottomHandler = "BottomHandler"
let kTopTipView = "KTopTipView"
let kBottomTipView = "BottomTipView"

@IBDesignable
open class HAVerticalSlider: UIControl {
    //MARK:- Top Handler variables
    var topHandler = CALayer()
    var handlerY: CGFloat = 0.0
    var handlerX: CGFloat = 0.0
    
    var topHandlerPreviousLocation = CGPoint(x: 0.0, y: 0.0)
    var topHandlerWidth:CGFloat = 31.0
    var topHandlerHeight:CGFloat = 31.0
    var isTrackingTopHanlder = false
    var isTrackingTopView = false
    
    @IBInspectable
    open var topHandlerColor: UIColor = UIColor.gray {
        didSet {
            topHandler.backgroundColor = topHandlerColor.cgColor
        }
    }
    
    @IBInspectable
    open var topHandlerImage: UIImage? = nil {
        didSet{
            if let image = topHandlerImage {
                let size = image.size
                topHandlerWidth = size.width
                topHandlerHeight = size.height
            }
        }
    }
    fileprivate var topTipView: UIView? = nil
    open var customTopTipView: UIView? = nil
    
    //MARK:- Bottom Handler variables
    var bottomHandler = CALayer()
    var bottomHandlerWidth:CGFloat = 31.0
    var bottomHandlerHeight:CGFloat = 31.0
    var isTrackingBottomHanlder = false
    var isTrackingBottomView = false
    var bottomHandlerPreviousLocation = CGPoint(x: 0, y: 0 )
    
    @IBInspectable
    open var bottomHandlerColor: UIColor = UIColor.gray {
        didSet {
            bottomHandler.backgroundColor = bottomHandlerColor.cgColor
        }
    }
    
    @IBInspectable
    open var bottomHandlerImage: UIImage? = nil {
        didSet{
            if let image = bottomHandlerImage {
                let size = image.size
                bottomHandlerWidth = size.width
                bottomHandlerHeight = size.height
            }
        }
    }
    
    open var bottomTipView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    //MARK:- Line Variables
    var sliderLine = CALayer()
    var lineX: CGFloat = 0.0
    var lineY: CGFloat = 0.0
    var lineHeight: CGFloat = 0.0
    
    @IBInspectable
    open var lineWidth: CGFloat = 0.0 {
        didSet{ 
            sliderLine.frame = CGRect(x: lineX, y: lineY, width: lineWidth, height: lineHeight)
            updateTopHanlderFrame(addInView: false)
            updateBottomHanlderFrame(addInView: false)
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
    open var topValue: CGFloat = 0.0 {
        didSet {
            updateTopHandlerPosition()
            updateTopTipViewPosition()
            updateTopSelectionLineWidth()
            updateMiddleSelectionLineWidth()
            updateBottomSelectionLineWidth()
        }
    }
    
    @IBInspectable
    open var bottomValue: CGFloat = 5.0 {
        didSet{
            updateBottomHandlerPosition()
            updateBottomTipViewPosition()
            updateTopSelectionLineWidth()
            updateMiddleSelectionLineWidth()
            updateBottomSelectionLineWidth()
        }
    }
    
    //MARK:- Selection Variables
    var topSelectionLine = CALayer()
    var middleSelectionLine = CALayer()
    var bottomSelectionLine = CALayer()
    @IBInspectable
    open var topSelectionColor: UIColor = UIColor.blue {
        didSet{
            topSelectionLine.backgroundColor = topSelectionColor.cgColor
        }
    }
    
    //  Selection Color between top handler and bottom handler
    @IBInspectable
    open var middleSelectionColor: UIColor = UIColor.red {
        didSet {
            middleSelectionLine.backgroundColor = middleSelectionColor.cgColor
        }
    }
    
    //  Selcetion Color between bottom handler and end of line
    @IBInspectable
    open var bottomSelectionColor: UIColor = UIColor.green {
        didSet {
            bottomSelectionLine.backgroundColor = bottomSelectionColor.cgColor
        }
    }
    
    
    //MARK:- Other Variables
    @IBInspectable
    open var isTipTouchEnable: Bool = true
    
    @IBInspectable
    open var isRightAlign: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    open var delegate: VerticalSliderDelegate?
    @IBInspectable
    open var disableRange: Bool = false {
        didSet {
            if disableRange {
                bottomHandler.isHidden = true
                bottomTipView.isHidden = true
                bottomValue = maximumValue
                bottomSelectionLine.isHidden = true
            }
            else {
                bottomHandler.isHidden = false
                bottomTipView.isHidden = false
                bottomSelectionLine.isHidden = false
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
        updateTopHanlderFrame(addInView: true)
        updateBottomHanlderFrame(addInView: true)
        drawTopSelectionLine()
        drawMiddleSelectionLine()
        drawBottomSelectionLine()
        
        updateTopHandlerPosition()
        updateBottomHandlerPosition()
        
        drawTopTipView()
        drawBottomTipView()
    }
    
    func reload() {
        topValue = minimumValue
        bottomValue = maximumValue
        setup()
    }
    
    fileprivate func isTouchBottomHandler(location: CGPoint) -> Bool {
        
        //Check if slider type in single handler
        if disableRange {
            return false
        }
        
        let totalX = bottomHandler.frame.origin.x + bottomHandler.frame.width
        let totalY = bottomHandler.frame.origin.y + bottomHandler.frame.height
        
        // Check if top Handler above bottom handler
        if topHandler.zPosition > bottomHandler.zPosition {
            return false
        }
        
        // if touch location inside handler frame
        if ( location.x >= bottomHandler.frame.origin.x && location.x <= totalX ) &&  ( location.y >= bottomHandler.frame.origin.y && location.y <= totalY ){
            return true
        }
        return false
    }
    
    fileprivate func isTouchBottomTipView(location: CGPoint) -> Bool {
        
        guard let topTipView = topTipView else {
            return false
        }
        //Check if slider type in single handler
        if disableRange {
            return false
        }
        
        let totalX = bottomTipView.frame.origin.x + bottomTipView.frame.width
        let totalY = bottomTipView.frame.origin.y + bottomTipView.frame.height
        
        //Check If IBInspectable property isTipTouchEnable is set false
        if !isTipTouchEnable {
            return false
        }
        
        // Check if top Handler above bottom handler
        if topTipView.layer.zPosition > bottomTipView.layer.zPosition {
            return false
        }
        
        // if touch location inside handler frame
        if ( location.x >= bottomTipView.frame.origin.x && location.x <= totalX ) &&  ( location.y >= bottomTipView.frame.origin.y && location.y <= totalY ){
            return true
        }
        return false
    }
    
    fileprivate func isTouchTopHandler(location: CGPoint) -> Bool {
        let totalX = topHandler.frame.origin.x + topHandler.frame.width
        let totalY = topHandler.frame.origin.y + topHandler.frame.height
        
        //Check if bottom handler is above top handler
        if topHandler.zPosition < bottomHandler.zPosition {
            return false
        }
        
        // if touch location inside handler frame
        if (location.x >= topHandler.frame.origin.x && location.x <= totalX) && ( location.y >= topHandler.frame.origin.y && location.y <= totalY ) {
            return true
        }
        return false
    }
    
    fileprivate func isTouchTopView(location: CGPoint) -> Bool {
        guard let topTipView = topTipView else {
            return false
        }
        
        let totalX = topTipView.frame.origin.x + topTipView.frame.width
        let totalY = topTipView.frame.origin.y + topTipView.frame.height
        
        //check if bottomtipview above toptipview
        if topTipView.layer.zPosition < bottomTipView.layer.zPosition {
            return false
        }
        
        //Check If IBInspectable property isTipTouchEnable is set false
        if !isTipTouchEnable {
            return false
        }
        
        // if touch location inside toptipview frame
        if (location.x >= topTipView.frame.origin.x && location.x <= totalX) && ( location.y >= topTipView.frame.origin.y && location.y <= totalY ) {
            return true
        }
        return false
    }
    
    fileprivate func positionForValue(value: CGFloat) -> CGFloat {
        let availableGap = frame.height - topHandlerHeight
        let v1 = availableGap * (value - minimumValue)
        let v2 = (maximumValue - minimumValue)
        return (v1 / v2)
    }
}

//MARK:- Draw Frames
extension HAVerticalSlider {
    
    fileprivate func drawSliderLine() {
        
        if isRightAlign {
            lineX = frame.width - 20.0
        }
        else {
            lineX = 20.0
        }
    
        lineY = 0.0
        lineHeight = self.frame.height
    
        sliderLine.frame = CGRect(x: lineX, y: lineY, width: lineWidth, height: lineHeight)
        if roundCorner {
            sliderLine.cornerRadius = lineWidth / 2
        }
        sliderLine.backgroundColor = lineBackgroundColor.cgColor
        sliderLine.zPosition = slideLineZposition
        if sliderLine.superlayer != self.layer {
            sliderLine.setValue(kSliderLine, forKeyPath: kSliderLine)
            self.layer.addSublayer(sliderLine)
        }
    }
    
    fileprivate func drawTopSelectionLine() {
        
        
        topSelectionLine.frame = getTopSelectionLineFrame()
        topSelectionLine.zPosition = selectionLineZposition
        
        if roundCorner {
            topSelectionLine.cornerRadius = lineWidth / 2
        }
        topSelectionLine.backgroundColor = topSelectionColor.cgColor
        if topSelectionLine.superlayer != self.layer {
            topSelectionLine.setValue(kTopSelectionLine, forKeyPath: kTopSelectionLine)
            self.layer.addSublayer(topSelectionLine)
        }
    }
    
    fileprivate func drawMiddleSelectionLine() {
        
        middleSelectionLine.frame = getMiddleSelectionFrame()
        middleSelectionLine.zPosition = selectionLineZposition
        
        if roundCorner {
            middleSelectionLine.cornerRadius = lineWidth / 2
        }
        middleSelectionLine.backgroundColor = middleSelectionColor.cgColor
        if middleSelectionLine.superlayer != self.layer {
            middleSelectionLine.setValue(kMiddleSlectionLine, forKeyPath: kMiddleSlectionLine)
            self.layer.addSublayer(middleSelectionLine)
        }
    }
    
    fileprivate func drawBottomSelectionLine() {
        
        bottomSelectionLine.frame = getBottomSelectionFrame()
        bottomSelectionLine.zPosition = selectionLineZposition
        
        if roundCorner {
            bottomSelectionLine.cornerRadius = lineWidth / 2
        }
        bottomSelectionLine.backgroundColor = bottomSelectionColor.cgColor
        if bottomSelectionLine.superlayer != self.layer {
            bottomSelectionLine.setValue(kBottomSelectionLine, forKeyPath: kBottomSelectionLine)
            self.layer.addSublayer(bottomSelectionLine)
        }
    }
    
    fileprivate func drawTopTipView() {
     
        guard let customTopTipView = customTopTipView else {
            return
        }
        
        var minX: CGFloat = 0.0
        var availableX: CGFloat = 0.0
        if isRightAlign {
            minX = 0.0
            availableX = topHandler.frame.origin.x
        }
        else {
            minX = topHandler.frame.origin.x + topHandlerWidth
            availableX = frame.width - minX
        }
        //Check if top tip view frame height is greater than available space.
        if customTopTipView.frame.width > availableX {
            print(kAlertLeftTipMinSpace)
            return
        }
        
        let tempTopTipView = UIView(frame: customTopTipView.frame)
        tempTopTipView.layer.zPosition = 1
        tempTopTipView.frame.origin.x = minX
        tempTopTipView.isUserInteractionEnabled = false
        tempTopTipView.layer.setValue(kTopTipView, forKeyPath: kTopTipView)
        tempTopTipView.layer.zPosition = topHandler.zPosition - 10
        topTipView = tempTopTipView
        
        customTopTipView.frame.origin.x = 0.0
        customTopTipView.frame.origin.y = 0.0
        topTipView?.addSubview(customTopTipView)
        self.addSubview(topTipView!)
        updateTopTipViewPosition()
    }
    
    fileprivate func drawBottomTipView() {
        
        var minX: CGFloat = 0.0
        var availableX: CGFloat = 0.0
        if isRightAlign {
            availableX = bottomHandler.frame.origin.x
        }
        else {
            minX = bottomHandler.frame.origin.x + bottomHandlerWidth
            availableX = frame.width - minX
            
        }
        
        //Check if top tip view frame height is greater than available space.
        if bottomTipView.frame.width > availableX {
            print(kAlertRightTipMinSpace)
            return
        }
        bottomTipView.layer.zPosition = 1
        bottomTipView.frame.origin.x = minX
        bottomTipView.isUserInteractionEnabled = false
        bottomTipView.layer.setValue(kBottomTipView, forKeyPath: kBottomTipView)
        self.bottomTipView.layer.zPosition = bottomHandler.zPosition + 10
        self.addSubview(bottomTipView)
        updateBottomTipViewPosition()
        showAllSublayers()
    }
    
    func showAllSublayers() {
        print("************************")
        for subLayer in self.layer.sublayers! {
            
            print("\(subLayer.zPosition)")
        }
        print("************************")
    }
}

//MARK:- Get Frames
extension HAVerticalSlider {
    
    //Handlers frame
    fileprivate func getHandlerFrame(forValue value: CGFloat) -> CGRect{
        
        handlerY = positionForValue(value: value)
        handlerX = (lineX + (lineWidth / 2 )) - (topHandlerWidth / 2)
        return CGRect(x: handlerX, y: handlerY, width: topHandlerWidth, height: topHandlerHeight)
    }
    
    //SelectionLine Frames
    fileprivate func getTopSelectionLineFrame() -> CGRect {
        //Starting Point
        let startingPoint = CGPoint(x: lineX, y: lineY)
        
        //End Point
        let endY = positionForValue(value: topValue)
        let endPoint = CGPoint(x: lineX, y: endY)
        
        let height = startingPoint.y + (endPoint.y + topHandlerHeight / 2)
        
        return CGRect(x: lineX, y: lineY, width: lineWidth, height: height)
    }
    
    fileprivate func getMiddleSelectionFrame() -> CGRect {
        //Starting point
        var startY = positionForValue(value: topValue)
        startY = startY + ( topHandlerHeight / 2 )
        let startingPoint = CGPoint(x: lineX, y: startY)
        
        //Ending Point
        var endY: CGFloat = 0.0
        if disableRange {
            endY = sliderLine.frame.height
        }
        else {
            endY = positionForValue(value: bottomValue)
            endY = endY + ( topHandlerHeight / 2 )
        }
        
        let endPoint = CGPoint(x: lineX, y: endY)
        let height = endPoint.y - startingPoint.y
        return  CGRect(x: lineX, y: startingPoint.y, width: lineWidth, height: height)
    }
    
    fileprivate func getBottomSelectionFrame() -> CGRect {
        //Starting point
        var startY = positionForValue(value: bottomValue)
        startY = startY + ( topHandlerHeight / 2 )
        
        //Ending Point
        let height = sliderLine.frame.height - startY
        
        return CGRect(x: lineX, y: startY, width: lineWidth, height: height)
    }
}

//MARK:- Update Frames
extension HAVerticalSlider {
    
    //Update tip positions
    fileprivate func updateTopTipViewPosition() {
        
        guard let topTipView = topTipView else {
            return
        }
        
        let yPosition = positionForValue(value: topValue)
        updateZpositionOfHandler()
        if yPosition <= sliderLine.frame.origin.y {
            topTipView.center.y = sliderLine.frame.origin.y + (topHandlerHeight / 2)
        }
        else {
            topTipView.center.y = yPosition + (topHandlerHeight / 2)
        }
    }
    
    fileprivate func updateBottomTipViewPosition() {
        //if range is disable than bottomTipView is not visible
        if disableRange {
            return
        }
        
        let yPosition = positionForValue(value: bottomValue)
        updateZpositionOfHandler()
        if yPosition >= lineHeight {
            bottomTipView.center.y = lineHeight - (topHandlerHeight / 2)
        }
        else {
            bottomTipView.center.y = yPosition + (topHandlerHeight / 2 )
        }
        
    }
    
    //Update handler positions
    fileprivate func updateTopHandlerPosition(){
        
        // Check if top handler cross bottom handler
        var newY = positionForValue(value: topValue)
        
        if disableRange {
            // if range is diable than check if handler reach don't reach beyond line.
            let maximumY = sliderLine.frame.maxY - topHandlerHeight
            if newY >= maximumY {
                newY = maximumY
            }
        }
        else {
            // Stop tophandler to reach ahead from bottom handler in bottom side
            let bottomHandlerY = bottomHandler.frame.origin.y
            if newY >= bottomHandlerY {
                newY = bottomHandlerY
            }
        }
        
        //check if handler move outside line
        if newY <= sliderLine.frame.minY {
            newY = sliderLine.frame.minY
        }
        
        //update previous location of top hanlder
        topHandlerPreviousLocation = CGPoint(x: topHandlerPreviousLocation.x, y: newY + (topHandlerHeight / 2))
        topHandler.frame.origin.y = newY
    }
    
    fileprivate func updateBottomHandlerPosition() {
        
        var newY = positionForValue(value: bottomValue)
        
        //Check if bottom handler cross top handler
        if newY <= topHandler.frame.origin.y {
            newY = topHandler.frame.origin.y
        }
        
        //Check if hanlder move outside line
        let maxY = sliderLine.frame.maxY + (topHandlerHeight / 2)
        if newY >= maxY {
            newY = maxY
        }
        
        //update handler previos location
        bottomHandlerPreviousLocation = CGPoint(x: bottomHandlerPreviousLocation.x, y: newY + (topHandlerHeight / 2))
        bottomHandler.frame.origin.y = newY
    }
    //Update Selection lines width
    fileprivate func updateTopSelectionLineWidth() {
        topSelectionLine.frame = getTopSelectionLineFrame()
    }
    
    fileprivate func updateMiddleSelectionLineWidth() {
        middleSelectionLine.frame = getMiddleSelectionFrame()
    }
    
    fileprivate func updateBottomSelectionLineWidth() {
        bottomSelectionLine.frame = getBottomSelectionFrame()
    }
    
    fileprivate func updateZpositionOfHandler() {
        let topMaxX = topHandler.frame.origin.y + topHandler.frame.height
        let bottomMinx = bottomHandler.frame.origin.y
        if topMaxX > bottomMinx {
            if isTrackingTopHanlder || isTrackingTopView {
                topTipView?.layer.zPosition = handlerHigherZPosition
                bottomTipView.layer.zPosition = handlerLowerZPosition
                topHandler.zPosition = handlerHigherZPosition
                bottomHandler.zPosition = handlerLowerZPosition
            }
            else if isTrackingBottomHanlder || isTrackingBottomView {
                topTipView?.layer.zPosition = handlerLowerZPosition
                bottomTipView.layer.zPosition = handlerHigherZPosition
                topHandler.zPosition = handlerLowerZPosition
                bottomHandler.zPosition = handlerHigherZPosition
            }
        }
        else {
            topTipView?.layer.zPosition = handlerLowerZPosition
            bottomTipView.layer.zPosition = handlerLowerZPosition
            topHandler.zPosition = handlerLowerZPosition
            bottomHandler.zPosition = handlerLowerZPosition
        }
    }
    
    //Update value
    fileprivate func upateTopValue(touch: UITouch) {
        
        let location = touch.location(in: self)
        
        //Determine by how much user dragged
        let deltaLocation = location.y - topHandlerPreviousLocation.y
        let deltaValue = ( maximumValue - minimumValue ) * ( deltaLocation  / lineHeight )
        var newValue = topValue + deltaValue
        
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
            //If range is enable than new value can't be greater than bottom value
            if newValue >= bottomValue {
                newValue = bottomValue
            }
        }
        topValue = newValue
    }
    
    fileprivate func updateBottomValue(touch: UITouch) {
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = location.y - bottomHandlerPreviousLocation.y
        let deltaValue = (maximumValue - minimumValue) * deltaLocation  / (lineHeight + (bottomHandlerHeight / 2))
        var newValue = bottomValue + deltaValue
        
        //If new value greater than equal to maximum value than assign maximum value in new value
        if newValue >= maximumValue {
            newValue = maximumValue
        }
            //If new value in less than tophanlder's value than assign top value in new value
        else if newValue <= topValue {
            newValue = topValue
        }
        bottomValue = newValue
    }
    
    //Make Slider Line round corner
    fileprivate func updateLineCorner() { 
        let radius = lineWidth / 2
        if roundCorner {
            sliderLine.cornerRadius = radius
            middleSelectionLine.cornerRadius = radius
            topSelectionLine.cornerRadius = radius
            bottomSelectionLine.cornerRadius = radius
        }
        else {
            sliderLine.cornerRadius = 0.0
            topSelectionLine.cornerRadius = 0.0
            middleSelectionLine.cornerRadius = 0.0
            bottomSelectionLine.cornerRadius = 0.0
        }
    }
    
    //Update handler frames
    fileprivate func updateTopHanlderFrame(addInView isAddSubLayer: Bool) {
        
        // Parameter isAddsublayer use to check if tophandler need to add layer in view. if view is already added and only need to get update than isAddSublayer is false.
        
        topHandler.zPosition = handlerLowerZPosition
        topHandler.frame = getHandlerFrame(forValue: topValue)
        topHandler.backgroundColor = topHandlerColor.cgColor
        topHandler.cornerRadius = (topHandlerHeight / 2)
        topHandlerPreviousLocation = CGPoint(x: handlerX, y: topHandler.frame.origin.y)
        
        if let image = topHandlerImage {
            topHandler.contents = image.cgImage
            topHandler.backgroundColor = UIColor.red.cgColor
        }
        
        if isAddSubLayer {
            topHandler.setValue(kTopHandler, forKeyPath: kTopHandler)
            self.layer.addSublayer(topHandler)
        }
    }
    
    fileprivate func updateBottomHanlderFrame(addInView isAddSubLayer: Bool = true ) {
        
        // Parameter isAddsublayer use to check if bottomhandler need to add layer in view. if view is already added and only need to get update than isAddSublayer is false.
        
        bottomHandler.zPosition = handlerLowerZPosition
        bottomHandler.frame = getHandlerFrame(forValue: bottomValue)
        bottomHandler.backgroundColor = bottomHandlerColor.cgColor
        bottomHandler.cornerRadius = (bottomHandlerHeight / 2)
        
        bottomHandlerPreviousLocation = CGPoint(x: handlerX, y: bottomHandler.frame.origin.y)
        
        if let image = bottomHandlerImage {
            bottomHandler.contents = image.cgImage
            bottomHandler.backgroundColor = UIColor.clear.cgColor
        }
        
        if isAddSubLayer {
            bottomHandler.setValue(kBottomHandler, forKey: kBottomHandler)
            self.layer.addSublayer(bottomHandler)
        }
    }
    
}

//MARK:- Touch EventsDelegates
extension HAVerticalSlider {
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        //Get which handler touched
        isTrackingTopHanlder = isTouchTopHandler(location: location)
        isTrackingTopView = isTouchTopView(location: location)
    
        isTrackingBottomHanlder = isTouchBottomHandler(location:  location)
        isTrackingBottomView = isTouchBottomTipView(location: location)
        
        //Call delegates functions.
        delegate?.beginTracking(verticalSlider: self, isTrackingTopHandler: isTrackingTopHanlder, isTrackingBottomHandler: isTrackingBottomHanlder)
        
        //Update Both Tip View postion.
        updateTopTipViewPosition()
        updateBottomTipViewPosition()
        
        if isTrackingTopHanlder || isTrackingTopView{
            topHandlerPreviousLocation = location
        }
        else if isTrackingBottomHanlder || isTrackingBottomView {
            bottomHandlerPreviousLocation = location
        }
        updateTopSelectionLineWidth()
        updateMiddleSelectionLineWidth()
        updateBottomSelectionLineWidth()
        return true
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        delegate?.continueTracking(verticalSlider: self, isTrackingTopHandler: isTrackingTopHanlder, isTrackingBottomHandler: isTrackingBottomHanlder)
        
        //Update both tip view according to new value
        updateTopTipViewPosition()
        updateBottomTipViewPosition()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if isTrackingTopHanlder || isTrackingTopView {
            upateTopValue(touch: touch)
        }
        else if isTrackingBottomHanlder || isTrackingBottomView {
            updateBottomValue(touch: touch)
        }
        updateTopSelectionLineWidth()
        updateMiddleSelectionLineWidth()
        updateBottomSelectionLineWidth()
        CATransaction.commit()
        
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.endTracking(verticalSlider: self, isTrackingTopHandler: isTrackingTopHanlder, isTrackingBottomHandler: isTrackingBottomHanlder)
        isTrackingTopHanlder = false
        isTrackingTopView = false
        
        isTrackingBottomView = false
        isTrackingBottomHanlder = false
        
    }
}



