import Foundation
import UIKit

//ラベル作成class
class MakeLabel:UILabel{
    
    func make(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,back:UIColor,
              _borderWidth:CGFloat=0.0,_cornerRadius:CGFloat=0.0,_alpha:CGFloat=1.0,
              _text:String="",_textColer:UIColor=UIColor.black,_fontSize:CGFloat=30,_adjustsFontSizeToFitWidth:Bool=true,_alignment:NSTextAlignment=NSTextAlignment.center)->UILabel{
        
        //必須
        let label = UILabel(frame: CGRect(x:x, y:y, width:width, height:height))
        label.backgroundColor = back
        
        //ビューオプション
        label.layer.borderWidth = _borderWidth
        if _borderWidth != 0.0{label.layer.borderColor = UIColor.black.cgColor}
        label.layer.masksToBounds = true//cornerRadiusを使用するために必要
        label.layer.cornerRadius = _cornerRadius
        label.alpha = _alpha
        
        //テキストオプション
        label.text = _text
        label.textColor = _textColer
        label.font = label.font.withSize(_fontSize)
        label.adjustsFontSizeToFitWidth = _adjustsFontSizeToFitWidth
        label.textAlignment = _alignment
        
        return(label)
    }
    
}
