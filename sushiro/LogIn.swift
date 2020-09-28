import UIKit
import AVFoundation
import RealmSwift

class LogIn: UIViewController,UITabBarDelegate {
    
    let textfield = MakeTextField()
    var mailAddress = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayerInstance.prepareToPlay()
        
        //背景を設定
        let background = MakeBackgroundImage()
        self.view.addSubview(background.make(image:"hakken2"))
        
        //クラスをインスタンス化
        let button = MakeButton()
        let label = MakeLabel()
        
        
        textfield.make(x: 250, y: 300, width: 500, height: 40, tag: 1, _placeholder: "メールアドレス" ,_keyboardType:UIKeyboardType.emailAddress, view: self)
        textfield.make(x: 250, y: 400, width: 500, height: 40, tag: 2, _placeholder: "パスワード" ,_keyboardType:UIKeyboardType.default ,view: self)
        label.make(x: 250, y: 260, width: 200, height: 40, back: UIColor.white, _text:"メールアドレス", _fontSize: 20, _alignment: NSTextAlignment.left ,view: self)
        label.make(x: 250, y: 360, width: 200, height: 40, back: UIColor.white, _text:"パスワード", _fontSize: 20,_alignment: NSTextAlignment.left, view: self)
        button.make(x: (view.frame.width / 2) - 350, y: 500, width: 300, height: 100, back: UIColor.white, tag: 1, _borderWidth:1.5,_cornerRadius:10,_text: "ログイン" , view: self)
        button.make(x: (view.frame.width / 2) + 50, y: 500, width: 300, height: 100, back: UIColor.white, tag: 2, _borderWidth:1.5,_cornerRadius:10,_text: "キャンセル" , view: self)
        
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }

    //ボタンイベント
    @objc func selection(sender: UIButton){
        let view = ViewSetting()
        
        switch sender.tag{
            case 1:
                if mailAddress.isEmpty || password.isEmpty {
                    //ポップアップ表示
                    let popUp = MakePopUp()
                    popUp.alert(title: "未入力があります", view: self)
                    break
                }
                let realm = try! Realm()
                let obj = realm.objects(LogInData.self)
                
                //データ照合
                for i in 0...obj.count-1{
                    if obj[i].mailAddress == mailAddress && obj[i].password == password{
                        view.set(view: self, transition: Accounting())
                        break
                    }
                }
                MakePopUp().alert(title: "アドレスかパスワードが間違っています", view: self)
                audioPlayerInstance.play()
            case 2:
                view.set(view: self, transition: CheckIn())
                audioPlayerInstance.play()
            default:
                break
            }
    }
}

extension LogIn:UITextFieldDelegate{
    //Doneが押されれた時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        switch textField.tag {
            case 1:
                mailAddress = textField.text!
            case 2:
                password = textField.text!
            default:
                break
        }
        return true
    }
}
