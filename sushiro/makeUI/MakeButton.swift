
import Foundation
import UIKit
//ボタン作成class(イメージ有り)
class MakeButton:UIButton,selection{
    @objc func selection(sender: UIButton) {}
    func make(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,back:UIColor,tag:Int,
              _pic:String="",_borderWidth:CGFloat=0.0,_cornerRadius:CGFloat=0.0,_alpha:CGFloat=1.0,
              _text:String="",_textColer:UIColor=UIColor.black,_fontSize:CGFloat=30,_adjustsFontSizeToFitWidth:Bool=true,_alignment:NSTextAlignment=NSTextAlignment.center)->UIButton{
        
        //必須
        let button: UIButton = UIButton(frame: CGRect(x:x, y:y, width:width, height:height))
        button.backgroundColor = back
        button.tag = tag
        button.addTarget(self, action: #selector(selection(sender:)), for: .touchUpInside)
        
        //ビューオプション
        
        if _pic != ""{button.setBackgroundImage(UIImage(named: "\(_pic).jpeg"), for: .normal)}
        button.layer.borderWidth = _borderWidth
        if _borderWidth != 0.0 {button.layer.borderColor = UIColor.black.cgColor}
        button.layer.masksToBounds = true//cornerRadiusを使用するために必要
        button.layer.cornerRadius = _cornerRadius
        button.alpha = _alpha
        
        //テキストオプション
        button.setTitleColor(_textColer, for: .normal)
        button.setTitle(_text, for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize:_fontSize)
        
        return(button)
    }
}
