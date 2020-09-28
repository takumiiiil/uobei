import UIKit


class MakeTextField:UITextField{
    
    func make(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,tag:Int,_back:UIColor = UIColor.white,
              _placeholder:String = "",_keyboardType:UIKeyboardType = .default,_borderStyle: UITextField.BorderStyle = .roundedRect,
              _returnKeyType:UIReturnKeyType = .done, _clearButtonMode:UITextField.ViewMode = .always,view:AnyObject){
        
        //必須
        let textField = UITextField()
        textField.frame = CGRect(x: x, y: y, width: width, height: height)
        textField.tag = tag
        
        
        //プレースホルダを設定
        textField.placeholder = _placeholder
        // キーボードタイプを指定
        textField.keyboardType = _keyboardType
        // 枠線のスタイルを設定
        textField.borderStyle = _borderStyle
        // 改行ボタンの種類を設定記入して
        //textField.returnKeyType = _returnKeyType
        // テキストを全消去するボタンを表示
        textField.clearButtonMode = _clearButtonMode
        //背景を設定
        textField.backgroundColor = _back
        //テキストを設定
        textField.text = textField.text!
        // UITextFieldを追加
        view.view.addSubview(textField)
        // デリゲートを指定
        textField.delegate = view as? UITextFieldDelegate
    }
}
