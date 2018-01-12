import UIKit

infix operator %%
public func %% (left:CGFloat, right:CGFloat) -> CGFloat
{
    return left.truncatingRemainder(dividingBy: right)
}

//
extension FloatingPoint
{
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
