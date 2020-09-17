import Foundation
import UIKit

class makeStepper:UIStepper{
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    func make(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,o:Int,o1:Int,o2:Double,ic:Int)->UIStepper{
        let stepper = UIStepper(frame: CGRect(x:CGFloat(xv), y: CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
        // 最小値, 最大値, 規定値の設定をする.
        stepper.minimumValue = 0
        stepper.maximumValue = 59
        stepper.value = 1
        stepper.layer.cornerRadius = 3.0
        stepper.backgroundColor = UIColor.clear
        // ボタンを押した際に動く値の.を設定する.
        stepper.stepValue = 1
        return(stepper)
    }
}
