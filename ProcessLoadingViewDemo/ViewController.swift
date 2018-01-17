//
//  ViewController.swift
//  ProcessLoadingViewDemo
//
//  Created by Ayman Ibrahim on 1/12/18.
//  Copyright © 2018 Ayman Ibrahim. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class ViewController: UIViewController
{
    @IBOutlet weak var viewProcess: ProcessLoadingView!
    var options = ProcessOptions()
    let colorBlue = UIColor(displayP3Red: 100/255, green: 217/255, blue: 213/255, alpha: 1)
    let colorOrange = UIColor(displayP3Red: 191/255, green: 155/255, blue: 124/255, alpha: 1)
    let bgColor = UIColor(displayP3Red: 82/255, green: 75/255, blue: 96/255, alpha: 1)
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let step = 3
        let totalSteps = 8
        
        let curvesStartRadians = [(3 * CGFloat.pi)/2, (23 * CGFloat.pi) / 12, (CGFloat.pi / 3), ((2 * CGFloat.pi) / 3), (13 * CGFloat.pi) / 12]
        let curvesEndRadians   = [(23 * CGFloat.pi) / 12, (CGFloat.pi) / 3, (2 * CGFloat.pi) / 3, (13 * CGFloat.pi) / 12, (3 * CGFloat.pi)/2]
        
        options.curvesStartRadians = curvesStartRadians
        options.curvesEndRadians = curvesEndRadians
        options.setNumberOfItems(number: totalSteps)
        options.stepComplete = step
        
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
        
        viewProcess.options = options
    }
    //-------------------------
    //MARK: - Actions -
    @IBAction func start(_ sender: UIButton)
    {
        options.mainText = "CLEANING"//randomString(length: 9)
        options.subText = "IN PROCESS"
        viewProcess.start(completed:
        {
            print("done")
        })
    }
    
    @IBAction func replay(_ sender: UIButton)
    {
        viewProcess.reverse(removeBtns: false, completed: nil)
    }
    
    @IBAction func reset(_ sender: Any)
    {
        viewProcess.reverse(removeBtns: true, completed: nil)
    }
    
    //100 217 213
    //191 155 124
    func imageOpts(of stepNumber:Int, totalSteps:Int) ->[(UIImage, UIColor?)]
    {
        var optsImages = [(UIImage, UIColor?)]()
        for i in 0  ..< totalSteps
        {
            if stepNumber > i
            {
                optsImages.append((#imageLiteral(resourceName: "checkMark"), colorBlue))
            }
            else if stepNumber == i
            {
                optsImages.append((#imageLiteral(resourceName: "emptyCircle"), colorOrange))
            }
            else
            {
                optsImages.append((#imageLiteral(resourceName: "emptyCircle"), UIColor.gray))
            }
        }
        return optsImages
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

