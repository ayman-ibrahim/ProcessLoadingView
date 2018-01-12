
import UIKit

struct Stroke
{
    var lineDashPattern: [NSNumber]?
    var start: CGFloat
    var end: CGFloat
    let path: UIBezierPath
    let shapeLayer = CAShapeLayer()
    var isCompletePath = true
    var radius:CGFloat = 0
    
    //calculating the length of the arc
    var length: CGFloat
    {
        let startDegrees = start.radiansToDegrees
        let endDegrees =  end.radiansToDegrees
        
        let angle:CGFloat
        if startDegrees > endDegrees
        {
            angle = 360 - abs(endDegrees - startDegrees)
        }
        else
        {
            angle = abs(endDegrees - startDegrees)
        }
        let area = (2 * CGFloat.pi * radius)
        let arcLength = (area * angle) / 360
        return arcLength == 0 ? area : arcLength
    }
}
