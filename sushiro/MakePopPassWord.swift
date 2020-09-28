import UIKit

class MakePopPassWord:UIAlertController{
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func make(title:String,pass:String,transition:AnyObject,view:AnyObject,_message:String = ""){
        let alert: UIAlertController!
        alert = UIAlertController(title: title,message: _message,preferredStyle: .alert)
 
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    if textField.text! == pass{
                        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
                        appDelegate.window?.rootViewController = transition as? UIViewController
                        appDelegate.window?.makeKeyAndVisible()
                    }else if textField.text! != pass{
                        MakePopUp().alert(title: "パスワードが違います", view: view)
                    }
                }
                
            }
        })
        alert.addAction(okAction)
        
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "パスワード"
            textField.isSecureTextEntry = true
        })
        
         view.present(alert, animated: true, completion:nil)

    }
    
    
}
