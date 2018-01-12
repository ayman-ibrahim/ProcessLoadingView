#ProcessLoadingView

[![Pod Version](http://img.shields.io/cocoapods/v/KYDrawerController.svg?style=flat)](https://cocoapods.org/pods/ProcessLoadingView/)
[![Pod Platform](http://img.shields.io/cocoapods/p/KYDrawerController.svg?style=flat)](https://cocoapods.org/pods/ProcessLoadingView)
[![Pod License](http://img.shields.io/cocoapods/l/KYDrawerController.svg?style=flat)](https://github.com/ayman-ibrahim/ProcessLoadingView/blob/master/LICENSE)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
![Swift version](https://img.shields.io/badge/swift-4.0-orange.svg)

`ProcessLoadingView` is a CABasicAnimation based loading animation inspired from https://dribbble.com/shots/1118077-Proces-animation

![Alt Text](https://github.com/ayman-ibrahim/ProcessLoadingView/blob/master/ProcessLoadingViewDemo/5Items.gif)
![Alt Text](https://github.com/ayman-ibrahim/ProcessLoadingView/blob/master/ProcessLoadingViewDemo/8items.gif)


## Installation

### CocoaPods

`ProcessLoadingView ` is available on CocoaPods.
Add the following to your `Podfile`:

```ruby
pod 'ProcessLoadingView'
```

### Manually
Just add the processView folder to your project.

## Usage
(see sample Xcode project Demo)

create a view in the storyboard and give it's class 'ProcessLoadingView' then connect an outlet to it.


### Code
```Swift

let totalSteps = 8
var options = ProcessOptions()
        options.setNumberOfItems(number: totalSteps)
        options.stepComplete = 3
        options.inSpeed = 1.2
        options.images = imageOpts(of: step, totalSteps: totalSteps)
        options.mainTextfont = UIFont.boldSystemFont(ofSize: 22)
        options.subTextfont = UIFont.boldSystemFont(ofSize: 16)
        options.ItemSize = 30
        options.radius = 120
        options.bgColor = bgColor
        options.completedPathColor = colorBlue
        options.mainTextColor = .white
        options.subTextColor = colorOrange
        
        viewProcessOutlet.options = options

If you want a custom places on the circle shape:

do not use :

and use:
let curvesStartRadians = [(3 * CGFloat.pi)/2, (23 * CGFloat.pi) / 12, (CGFloat.pi / 3), ((2 * CGFloat.pi) / 3), (13 * CGFloat.pi) / 12]
        let curvesEndRadians   = [(23 * CGFloat.pi) / 12, (CGFloat.pi) / 3, (2 * CGFloat.pi) / 3, (13 * CGFloat.pi) / 12, (3 * CGFloat.pi)/2]

        options.curvesStartRadians = curvesStartRadians
        options.curvesEndRadians = curvesEndRadians
        options.stepComplete = 3
        options.inSpeed = 1.2
        options.images = imageOpts(of: step, totalSteps: curvesStartRadians.count)
        options.mainTextfont = UIFont.boldSystemFont(ofSize: 22)
        options.subTextfont = UIFont.boldSystemFont(ofSize: 16)
        options.ItemSize = 30
        options.radius = 120
        options.bgColor = bgColor
        options.completedPathColor = colorBlue
        options.mainTextColor = .white
        options.subTextColor = colorOrange
        
        viewProcessOutlet.options = options

```
 
to get the locations in the circle circumference:
![Alt Text](http://math.rice.edu/~pcmi/sphere/degrad.gif)

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE). 
