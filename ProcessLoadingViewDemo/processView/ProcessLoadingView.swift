//
//  ProcessLoadingView.swift
//  test circle
//
//  Created by Ayman Ibrahim on 12/16/17.
//  Copyright Â© 2017 Ayman Ibrahim. All rights reserved.
//

import UIKit

fileprivate let textHeight:CGFloat = 28.0
fileprivate let animationKey = "animationKey"

public class ProcessLoadingView: UIView
{
    private let buttonsLayerParent = CAShapeLayer()
    private let curvesLayerParent = CAShapeLayer()
    private let textLayerParent = CAShapeLayer()
    private var myPath:(complete:Stroke?, unComplete:Stroke?)?
    private var processItems = [UIView]()
    private var myCenter:CGPoint!
    private var mainText:CATextLayer!
    private var subText:CATextLayer!
    
    public var options:ProcessOptions!
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        myCenter = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
    }
    
    //MARK - fire -
    public func start(completed: (()->())?)
    {
        guard options != nil else {
            assert(false, "Options must not be nil")
            return
        }
        guard options.images.count == options.totalStepsCount else {
            assert(false, "every step item should have an image")
            return
        }
        preparation()
        settingTextLayerProperties()
        
        if isAnimationRunning() {
            return
        }
        
        if processItems.count > 0
        {
            let p = self.getAllPathsAsTwoStrokes(for: options.stepComplete)
            myPath = p
            startPathAnimationForTheTwoStroks(myPath: p)
        }
        else
        {
            for i in 0  ..<  options.curvesStartRadians.count
            {
                drawShapeButtonAnimated(in: buttonsLayerParent, startAngle: options.curvesStartRadians[i], index: i, completed:
                    {
                        let p = self.getAllPathsAsTwoStrokes(for: self.options.stepComplete)
                        self.myPath = p
                        self.startPathAnimationForTheTwoStroks(myPath: p)
                        self.animatePositionAndOpacity(for: self.subText, posOrigin: CGPoint(x: self.subText.frame.origin.x, y: self.subText.frame.origin.y - 20), posDestination: self.subText.frame.origin, posAnimDuration: 0.5)
                        self.animateAlpha(layer: self.textLayerParent, isAppearing: true, duration: 0.8, completed:
                        {
                            completed?()
                        })
                })
            }
        }
    }
    
    public func reset(removeItems:Bool, completed: (()->())?)
    {
        guard let path = myPath else { return }
        if isAnimationRunning() { return }
        self.reverseStroke(layer: path.unComplete?.shapeLayer, stroke: path.unComplete)
        {
            self.reverseStroke(layer: path.complete?.shapeLayer, stroke: path.complete, completed:
                {
                    if removeItems
                    {
                        self.animateAlpha(layer: self.textLayerParent, isAppearing: false, completed: nil)
                        let count = self.processItems.count
                        for i in 0  ..<  count
                        {
                            let item = self.processItems[i]
                            self.animateAlpha(layer: item.layer, isAppearing: false, completed:
                                {
                                    self.processItems.removeLast()
                                    if self.processItems.count == 0
                                    {
                                        self.clearAllLayers()
                                        completed?()
                                    }
                            })
                        }
                    }
            })
        }
    }
    
    func startPathAnimationForTheTwoStroks(myPath:(complete:Stroke?, unComplete:Stroke?))
    {
        self.animatePath(of: myPath.complete, completed:
            {
                guard let uncompleted = myPath.unComplete else { return }//in case the shape is totally complete, there will be no uncomplete path
                self.animatePath(of: uncompleted, completed: nil)
        })
    }
    
    func isDrawed()->Bool
    {
        return processItems.count > 0
    }
    
    //MARK: - BezierPaths creation -
    func getBezierCurve(startRadian: CGFloat, endRadian: CGFloat, radius: CGFloat)->UIBezierPath
    {
        let path = UIBezierPath(arcCenter: myCenter, radius: radius, startAngle: startRadian, endAngle: endRadian, clockwise: true)
        return path
    }
    
    //MARK: -
    //The circle is divided into 5 bezierpaths ; this method creates a stroke per each
    func getStrokePerRadian()->[Stroke]
    {
        var strokes = [Stroke]()
        for i in 0  ..<  options.curvesStartRadians.count
        {
            let curve = getBezierCurve(startRadian: options.curvesStartRadians[i], endRadian: options.curvesEndRadians[i], radius: options.radius)
            let stroke = Stroke(lineDashPattern: nil, start: options.curvesStartRadians[i], end: options.curvesEndRadians[i], path: curve, isCompletePath: false, radius: options.radius)
            strokes.append(stroke)
        }
        return strokes
    }
    
    //get two paths one represent completed progress and other represents the uncompleted progress
    func getAllPathsAsTwoStrokes(for step: Int) -> (complete:Stroke?, unComplete:Stroke?)
    {
        let completePaths = getStrokePerRadian()
        var completePath:Stroke!
        var unCompletePath:Stroke!
        //
        for i in 0  ..<  completePaths.count
        {
            if i < step
            {
                if completePath == nil
                {
                    completePath = completePaths[i]
                }
                else
                {
                    completePath.path.append(completePaths[i].path)
                    completePath.end = completePaths[i].end
                }
            }
            else
            {
                if unCompletePath == nil
                {
                    unCompletePath = completePaths[i]
                }
                else
                {
                    unCompletePath.path.append(completePaths[i].path)
                    unCompletePath.end = completePaths[i].end
                }
            }
        }
        unCompletePath?.lineDashPattern = options.unCompletePathDashPattern
        completePath?.isCompletePath = true
        unCompletePath?.isCompletePath = false
        return (completePath, unCompletePath)
    }
    
    //MARK: - draw -
    func animatePath(of stroke:Stroke?, completed: (()->())?)
    {
        guard let stroke = stroke else { completed?() ; return }
        stroke.shapeLayer.path = stroke.path.cgPath
        stroke.shapeLayer.strokeColor = stroke.isCompletePath ? options.completedPathColor.cgColor : options.unCompletedPathColor.cgColor
        stroke.shapeLayer.lineWidth = 3
        stroke.shapeLayer.fillColor = UIColor.clear.cgColor
        stroke.shapeLayer.lineJoin = kCALineCapButt
        stroke.shapeLayer.lineDashPattern = stroke.lineDashPattern
        
        animateStroke(stroke: stroke, completed:
            {
                completed?()
        })
        self.curvesLayerParent.addSublayer(stroke.shapeLayer)
    }
    
    func drawShapeButtonAnimated(in layer: CALayer, startAngle:CGFloat, index:Int, completed: (()->())?)
    {
        let circleShap = circleShape(imgOpt: options.images[index])
        processItems.append(circleShap)
        let x = myCenter.x + options.radius * cos(startAngle)
        let y = myCenter.y + options.radius * sin(startAngle)
        
        circleShap.layer.position = CGPoint(x: x, y: y)
        layer.addSublayer(circleShap.layer)
        animateScalingWithAlpha(layer: circleShap.layer, delayTime: 0.05 + Double(index)/3 ,completed:
            {
                if index == self.options.curvesEndRadians.count - 2
                {
                    completed?()
                }
        })
    }
    
    func circleShape(imgOpt:(UIImage, UIColor?))->UIView
    {
        let imageSize = options.ItemSize - 6
        var viewRect = CGRect(x: 0, y: 0, width: options.ItemSize, height: options.ItemSize)
        let view = UIView(frame: viewRect)
        view.backgroundColor = options.bgColor
        view.layer.cornerRadius = options.ItemSize/2
        
        viewRect.size.width = imageSize
        viewRect.size.height = imageSize
        
        let imgV = UIImageView(frame: viewRect)
        var image:UIImage!
        if let color = imgOpt.1
        {
            image = imgOpt.0.withRenderingMode(.alwaysTemplate)
            imgV.tintColor = color
        }
        else
        {
            image = imgOpt.0
        }
        imgV.image = image
        imgV.layer.cornerRadius = imageSize / 2
        imgV.center = view.center
        view.layer.addSublayer(imgV.layer)
        
        return view
    }
    
    
    //MARK: - text -
    func addText()
    {
        mainText = getTextLayerWithCommontProperties()
        mainText.fontSize = 24//this font size will be overridden if the user provided a font
        let width = textLayerParent.frame.width - 16
        let height:CGFloat = textHeight
        mainText.frame.size = CGSize(width: width, height: height)
        mainText.frame.origin = CGPoint(x: (textLayerParent.frame.width / 2 - width / 2) , y: (textLayerParent.frame.height / 2 - height / 2) - 8)
        mainText.backgroundColor = UIColor.clear.cgColor
        self.textLayerParent.addSublayer(mainText)
        
        subText = getTextLayerWithCommontProperties()
        subText.anchorPoint = CGPoint(x: 0.0, y: 0.0)//to animate position
        subText.fontSize = 18//this font size will be overridden if the user provided a font
        subText.foregroundColor = UIColor.white.cgColor
        subText.frame.size = CGSize(width: width, height: textHeight)
        let origin = CGPoint(x: (textLayerParent.frame.width / 2 - width / 2) , y: (textLayerParent.frame.height / 2 - height / 2) + textHeight / 1.5)
        subText.frame.origin = origin
        subText.backgroundColor = UIColor.clear.cgColor
        if let font = options.mainTextfont
        {
            mainText.fontSize = font.pointSize
            mainText.font = font
        }
        if let font = options.subTextfont
        {
            subText.fontSize  = font.pointSize
            subText.font = font
        }
        self.textLayerParent.addSublayer(subText)
    }
    
    func getTextLayerWithCommontProperties()->CATextLayer
    {
        let text = CATextLayer()
        text.isWrapped = true
        text.contentsScale = UIScreen.main.scale
        text.alignmentMode = kCAAlignmentCenter
        return text
    }
    
    func settingTextLayerProperties()
    {
        mainText.string = options.mainText
        subText.string = options.subText
        mainText.foregroundColor = options.mainTextColor.cgColor
        subText.foregroundColor = options.subTextColor.cgColor
    }
    
    //MARK: - Animation mehtods -
    func animateStroke(stroke:Stroke, completed: (()->())?)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock
            {
                completed?()
        }
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration =  CFTimeInterval(stroke.length / options.inSpeed)
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        stroke.shapeLayer.add(pathAnimation, forKey: "strokeEnd")
        CATransaction.commit()
    }
    
    func reverseStroke(layer:CAShapeLayer?, stroke:Stroke?, completed: (()->())?)
    {
        guard let stroke = stroke else { completed?(); return }
        CATransaction.begin()
        CATransaction.setCompletionBlock
            {
                layer?.removeAllAnimations()
                layer?.path = nil
                completed?()
        }
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration =  CFTimeInterval(stroke.length / options.outSpeed)
        pathAnimation.fromValue = layer?.presentation()?.strokeEnd
        pathAnimation.toValue = 0
        pathAnimation.fillMode = kCAFillModeBoth
        pathAnimation.isRemovedOnCompletion = false
        layer?.add(pathAnimation, forKey: animationKey)
        CATransaction.commit()
    }
    
    func animateAlpha(layer:CALayer, isAppearing:Bool, duration:CGFloat = 0.4, completed: (()->())?)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock
            {
                completed?()
        }
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = CFTimeInterval(duration)
        opacityAnimation.fromValue = isAppearing ? 0 : 1
        opacityAnimation.toValue = isAppearing ? 1 : 0
        opacityAnimation.fillMode = kCAFillModeBoth
        layer.opacity = isAppearing ? 1 : 0
        layer.add(opacityAnimation, forKey: animationKey)
        CATransaction.commit()
    }
    
    func animateScalingWithAlpha(layer:CALayer, delayTime: Double, duration:CGFloat = 0.15, completed: (()->())?)
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock
            {
                completed?()
        }
        layer.opacity = 0
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = CFTimeInterval(duration + 0.2)
        opacityAnimation.beginTime = CACurrentMediaTime() + delayTime
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        
        opacityAnimation.fillMode = kCAFillModeBoth
        layer.opacity = 1
        layer.add(opacityAnimation, forKey: animationKey)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.beginTime = CACurrentMediaTime() + delayTime
        scaleAnimation.duration = CFTimeInterval(duration)
        scaleAnimation.fillMode = kCAFillModeBoth
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        
        layer.add(scaleAnimation, forKey: animationKey)
        CATransaction.commit()
    }
    
    func animatePositionAndOpacity(for layer:CALayer ,posOrigin:CGPoint, posDestination:CGPoint, posAnimDuration:CGFloat, opacityAnimDuration:CGFloat = 1)
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = CFTimeInterval(posAnimDuration)
        let origin = NSValue(cgPoint: posOrigin)
        animation.fromValue = origin
        animation.toValue = NSValue(cgPoint: posDestination)
        animation.fillMode = kCAFillModeForwards
        layer.add(animation, forKey: nil)
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = CFTimeInterval(opacityAnimDuration)
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.fillMode = kCAFillModeBoth
        layer.opacity = 1
        layer.add(opacityAnimation, forKey: animationKey)
    }
    
    //MARK: - private helpers -
    private func preparation()
    {
        guard curvesLayerParent.superlayer == nil else { return }
        buttonsLayerParent.frame = bounds
        curvesLayerParent.frame = bounds
        curvesLayerParent.backgroundColor = options.bgColor.withAlphaComponent(0.5).cgColor
        textLayerParent.backgroundColor = UIColor.clear.cgColor
        
        let textLayerSize = (options.radius * 2) - (options.ItemSize)
        textLayerParent.frame.size = CGSize(width: textLayerSize, height: textLayerSize)
        textLayerParent.position = self.myCenter
        
        layer.addSublayer(curvesLayerParent)
        layer.addSublayer(buttonsLayerParent)
        layer.addSublayer(textLayerParent)
        textLayerParent.opacity = 0.0
        addText()
    }
    
    private func clearAllLayers()
    {
        curvesLayerParent.removeAllAnimations()
        curvesLayerParent.sublayers?.removeAll()
        buttonsLayerParent.removeAllAnimations()
        buttonsLayerParent.sublayers?.removeAll()
    }
    
    private func isAnimationRunning()->Bool
    {
        for btn in processItems
        {
            if hasAnimationKeys(for: btn.layer)
            {
                return true
            }
        }
        
        if let strokePath = myPath, strokePath.complete != nil
        {
            if hasAnimationKeys(for: strokePath.complete!.shapeLayer)
            {
                return true
            }
            if let unCompletePath = strokePath.unComplete
            {
                if hasAnimationKeys(for: unCompletePath.shapeLayer)
                {
                    return true
                }
            }
        }
        
        if hasAnimationKeys(for: self.textLayerParent)
        {
            return true
        }
        
        if hasAnimationKeys(for: self.subText)
        {
            return true
        }
        return false
    }
    
    private func hasAnimationKeys(for layer:CALayer)->Bool
    {
        if let keys = layer.animationKeys()
        {
            return keys.count > 0
        }
        return false
    }
}

