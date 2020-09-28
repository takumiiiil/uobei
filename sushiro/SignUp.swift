import UIKit
import AVFoundation
import RealmSwift


class SignUp: UIViewController,UITabBarDelegate {
   
    let textfield = MakeTextField()
    var loginData = LogInData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景を設定
        let background = MakeBackgroundImage()
        self.view.addSubview(background.make(image:"hakken2"))
        
        audioPlayerInstance.prepareToPlay()
        
        //クラスをインスタンス化
        let button = MakeButton()
        let label = MakeLabel()
        
        //textFIeldの位置を指定
        textfield.make(x: 100, y: 220, width: 500, height: 40, tag: 1, _placeholder: "名前" ,_keyboardType:UIKeyboardType.namePhonePad , view: self)
        textfield.make(x: 100, y: 320, width: 500, height: 40, tag: 2, _placeholder: "住所" ,_keyboardType:UIKeyboardType.default, view: self)
        textfield.make(x: 100, y: 420, width: 500, height: 40, tag: 3, _placeholder: "電話番号" ,_keyboardType:UIKeyboardType.phonePad, view: self)
        textfield.make(x: 100, y: 520, width: 500, height: 40, tag: 4, _placeholder: "メールアドレス" ,_keyboardType:UIKeyboardType.emailAddress, view: self)
        textfield.make(x: 100, y: 620, width: 500, height: 40, tag: 5, _placeholder: "パスワード" ,_keyboardType:UIKeyboardType.default, view: self)
        label.make(x: 100, y: 180, width: 200, height: 40, back: UIColor.white, _text:"名前" ,_fontSize: 20, _alignment: NSTextAlignment.left ,view: self)
        label.make(x: 100, y: 280, width: 200, height: 40, back: UIColor.white, _text:"住所", _fontSize: 20, _alignment: NSTextAlignment.left, view: self)
        label.make(x: 100, y: 380, width: 200, height: 40, back: UIColor.white, _text:"電話番号", _fontSize: 20, _alignment: NSTextAlignment.left, view: self)
        label.make(x: 100, y: 480, width: 200, height: 40, back: UIColor.white, _text:"メールアドレス", _fontSize: 20, _alignment: NSTextAlignment.left, view: self)
        label.make(x: 100, y: 580, width: 200, height: 40, back: UIColor.white, _text:"パスワード", _fontSize: 20, _alignment: NSTextAlignment.left, view: self)
        button.make(x: 670, y: 220, width: 300, height: 100, back: UIColor.white, tag: 1, _borderWidth:1.5,_cornerRadius:10,_text: "登録" , view: self)
        button.make(x: 670, y: 390, width: 300, height: 100, back: UIColor.white, tag: 2, _borderWidth:1.5,_cornerRadius:10,_text: "リセット" , view: self)
        button.make(x: 670, y: 560, width: 300, height: 100,back:UIColor.white,tag:3, _borderWidth:1.5,_cornerRadius:10,_text:"キャンセル" ,view:self)
        
        
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
            if loginData.name.isEmpty || loginData.address.isEmpty || loginData.phone.isEmpty || loginData.mailAddress.isEmpty || loginData.password.isEmpty {
                //ポップアップ表示
                MakePopUp().alert(title: "未入力があります", view: self)
                break
            }
            
            let realm = try! Realm()
            let obj = realm.objects(LogInData.self).last
            try! realm.write {
                obj!.name = loginData.name
                obj!.address = loginData.address
                obj!.phone = loginData.phone
                obj!.mailAddress = loginData.mailAddress
                obj!.password = loginData.password
            }
            try! realm.write {
                realm.add(LogInData())
            }
            view.set(view: self, transition: Ticket())
            audioPlayerInstance.play()
            
        case 2:
            textfield.text = ""
            loginData.name = ""
            loginData.address = ""
            loginData.phone = ""
            loginData.mailAddress = ""
            loginData.password = ""
            viewDidLoad()
            audioPlayerInstance.play()
        case 3:
            view.set(view: self, transition: CheckIn())
            audioPlayerInstance.play()
        default:break
        }
    }
    
   
}

extension SignUp:UITextFieldDelegate{
    //Doneが押されれた時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField.tag {
            case 1:
                loginData.name = textField.text!
            case 2:
                loginData.address = textField.text!
            case 3:
                loginData.phone = textField.text!
            case 4:
                loginData.mailAddress = textField.text!
            case 5:
                loginData.password = textField.text!
            default:
                break
        }
        return true
    }
}
