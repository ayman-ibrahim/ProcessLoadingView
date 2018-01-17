
import UIKit

public class ProcessOptions
{
    //MARK: - properties -
    private let speedConstant:CGFloat = 1000
    public typealias ImageWithSelectedTint = (UIImage, UIColor?)
    public var images:[ImageWithSelectedTint] = []
    public var stepComplete:Int = 0
    public var mainText = ""
    public var subText = ""
    public var mainTextfont:UIFont?
    public var subTextfont:UIFont?
    public var unCompletePathDashPattern:[NSNumber] = [3, 2]
    public var bgColor = UIColor.black
    public var ItemSize:CGFloat = 44.0
    public var radius:CGFloat = 120
    public var totalStepsCount = 0
    //
    public var completedPathColor = UIColor.white
    public var unCompletedPathColor = UIColor.gray
    public var mainTextColor = UIColor.white
    public var subTextColor = UIColor.brown
    //
    public var curvesStartRadians = [CGFloat]()
    {
        didSet
        {
            totalStepsCount = curvesStartRadians.count
        }
    }
    public var curvesEndRadians   = [CGFloat]()
    //
    //Giving a default duration of 1.0
    private var _inSpeed: CGFloat = 1.0
    private var _outSpeed: CGFloat = 1.0
    public var inSpeed: CGFloat
    {
        set { _inSpeed = speedConstant * newValue }
        get
        {
            if _inSpeed == 1
            {
                return _inSpeed * speedConstant
            }
            return _inSpeed
        }
    }
    public var outSpeed: CGFloat
    {
        set { _outSpeed = speedConstant * newValue }
        get
        {
            if _outSpeed == 1
            {
                return _outSpeed * speedConstant
            }
            return _outSpeed
        }
    }
    
    //MARK: - Initializers -
    public init() {
        
    }
    
    //
    //MARK: - methods -
    public func setNumberOfItems(number:Int = 0)
    {
        totalStepsCount = number
        let angle:CGFloat = 360 / CGFloat(number)
        
        var start:[CGFloat] = []
        var end:[CGFloat] = []
        for i in stride(from: 1, to: CGFloat(number + 1), by: 1)
        {
            let startAngle = (180 + (angle * i))
            var startCircleAngle:CGFloat = 0
            
            let endAngle = (180 + (angle * (i + 1)))
            var endCircleAngle:CGFloat = 0
            
            if startAngle != 360
            {
                startCircleAngle = startAngle %% 360
            }
            else
            {
                startCircleAngle = startAngle
            }
            
            if endAngle != 360
            {
                endCircleAngle = endAngle %% 360
            }
            else
            {
                endCircleAngle = endAngle
            }
            
            start.append(startCircleAngle.degreesToRadians)
            end.append(endCircleAngle.degreesToRadians)
            curvesStartRadians = start
            curvesEndRadians = end
        }
    }
}

