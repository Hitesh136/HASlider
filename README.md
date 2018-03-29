# HASlider

[![CI Status](http://img.shields.io/travis/Hitesh136/HASlider.svg?style=flat)](https://travis-ci.org/Hitesh136/HASlider)
[![Version](https://img.shields.io/cocoapods/v/HASlider.svg?style=flat)](http://cocoapods.org/pods/HASlider)
[![License](https://img.shields.io/cocoapods/l/HASlider.svg?style=flat)](http://cocoapods.org/pods/HASlider)
[![Platform](https://img.shields.io/cocoapods/p/HASlider.svg?style=flat)](http://cocoapods.org/pods/HASlider)

## Overview
HASlider provide slider with two handler and custom tip view over them. Developer has to pass his custom view in tip view. HASlider has delegates methods for track change in value and update tipview according to new value.

## Requirements
Swift 4, Xcode 9.0+

## Installation

HASlider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HASlider', :git => 'https://github.com/Hitesh136/HASlider'
```
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![](/Example/Resources/Gif/slider1.gif)
![](/Example/Resources/Gif/slider2.gif)
![](/Example/Resources/Gif/verticalSlider.gif)
![](/Example/Resources/Gif/slider3.gif)


## Usage

Add UIView in interface builder and open its identityinspector and set its custom class as HASlider or HAVerticalSlider.

HASlider --- Horizontal Slider

HAVerticalSlider --- Vertical Slider

![](/Example/Resources/Images/ic_setup.png)
![](/Example/Resources/Images/ic_demo.png)

Set it's property in interface builder or programmatically.

#### `minimumValue`
minimum possible value slider could have.
#### `maximumValue`
Maximum possible value slider could have.
#### `leftValue`
value of left cirlcle.
#### `rightValue`
value of right circle
#### `lineBackgroundColor`
Color of slider line
#### `leftHandlerColor`
Background color of left circle. If `lefthandlerimage` is set than left circle's background color is clear.
#### `leftHandlerImage`
Image shown on lefthandler. handler's size change equal to image size.
#### `rightHandlerColor`
Background color of right circle. If `righthandlerimage` is set than right circle's background color is clear.
#### `rightHandlerImage`
Image shown on righthandler. Handler's size change equal to image size.
#### `leftSelectionColor`
Color between slider's starting point and left handler. If leftselectioncolor is clear than linebackgroundcolor is visiable.
#### `middleSelectionColor`
Color between left handler and right handler. If middleSelectionColor is clear than linebackgroundcolor is visiable.
#### `rightSelectionColor`
Color between right handler and sliderline's end point. If rightSelectionColor is clear than linebackgroundcolor is visiable.
#### `leftTipView`
Custom view over left circle. assign your custom view in leftTipView
programmatically
```swift
slider1.leftTipView = leftView
```
If any view is not assign in leftTipView than nothing will show above left circle.
#### `rightTipView`
Custom view over right circle. assign your custom view in rightTipView programmatically
```swift
slider1.rightTipView = rightView
```

If any view is not assign in rightTipView than nothing will show above right circle.

#### `disableRange`
if `true` than slider have only one circle and left value work as main value. </br>
default value is false.

#### `roundCorner`
set roundCorner of slider line.


#### `Delegates`
Implement delegate methods for listen change in value and update cutom tip view for new value.

```swift
// isTrackingLeftHandler = if tracking left handler
// isTrackingRightHandler = if tracking right handler

extension ViewController: SliderDelegate {
    func beginTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        // Begin tracking of handler
    }

    func continueTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        // Continuously moving handler
    }

    func endTracking(slider: HASlider, isTrackingLeftHandler: Bool, isTrackingRightHandler: Bool) {
        // Stop moving handler
    } 
}
```

## Author

Hitesh Agarwal, agarwal.hitesh94@gmail.com

## License

HASlider is available under the MIT license. See the LICENSE file for more info.





