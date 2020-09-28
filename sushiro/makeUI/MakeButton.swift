
import Foundation
import UIKit


class MakeButton:UIButton,selection{
    
    @objc func selection(sender: UIButton) {}
    
        func make(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,back:UIColor,tag:Int,
                  _pic:String="",_borderWidth:CGFloat=0.0,_borderColor:CGColor=UIColor.black.cgColor,_cornerRadius:CGFloat=0.0,_alpha:CGFloat=1.0,
                  _text:String="",_textColor:UIColor=UIColor.black,_fontSize:CGFloat=30,_isAdjusts:Bool=true,_alignment:NSTextAlignment=NSTextAlignment.center,_font:String = "Bold",
                  _isSelf:Bool = true,_view2:AnyObject=Ticket(),view:AnyObject){
            
            //必須
            let button: UIButton = UIButton(frame: CGRect(x:x, y:y, width:width, height:height))
            button.backgroundColor = back
            button.tag = tag
            button.addTarget(self, action: #selector(selection(sender:)), for: .touchUpInside)
          
            //ビューオプション
            if _pic != ""{button.setBackgroundImage(UIImage(named: "\(_pic).jpeg"), for: .normal)}
            button.layer.borderWidth = _borderWidth
            button.layer.borderColor = _borderColor
            button.layer.masksToBounds = true//cornerRadiusを使用するために必要
            button.layer.cornerRadius = _cornerRadius
            button.alpha = _alpha
            
            //テキストオプション
            button.setTitleColor(_textColor, for: .normal)
            button.setTitle(_text, for: .normal)
            button.titleLabel?.font =  UIFont(name:_font,size:_fontSize)
            button.titleLabel?.font =  UIFont.systemFont(ofSize:_fontSize)
            button.titleLabel?.adjustsFontSizeToFitWidth = _isAdjusts
            view.view.addSubview(button)
    }
}
