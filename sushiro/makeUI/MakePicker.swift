import UIKit


class MakePicker{

    func make(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,back:UIColor,
              tag:Int,_setNum:Int = 0,view:AnyObject) -> UIPickerView{
    
        let pickerView = UIPickerView(frame: CGRect(x:x, y:y, width:width, height:height))
        
        pickerView.backgroundColor = back
        pickerView.tag = tag
        pickerView.center = view.view.center
        return(pickerView)
    }
}
