import UIKit
import AVFoundation
import RealmSwift

class CheckIn: UIViewController,UITextFieldDelegate,UITabBarDelegate {
  
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayerInstance.prepareToPlay()
        
        //背景を設定
        let background = MakeBackgroundImage()
        self.view.addSubview(background.make(image:"hakken2"))
        
        //クラスをインスタンス化
        let button = MakeButton()
        
        button.make(x: (view.frame.width / 2) - 350, y: 350, width: 300, height: 100, back: UIColor.white, tag: 1, _borderWidth:1.5,_cornerRadius:10,_text: "登録済み" , view: self)
        button.make(x: (view.frame.width / 2) + 50, y: 350, width: 300, height: 100, back: UIColor.white, tag: 2, _borderWidth:1.5,_cornerRadius:10,_text: "新規登録" , view: self)
        button.make(x:30,y:700,width:100,height:50,back:UIColor.white,tag:3, _borderWidth:1.5,_cornerRadius:6,_text:"戻る", _fontSize:50,view:self)
        
        
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
                view.set(view: self, transition: LogIn())
                audioPlayerInstance.play()
            case 2:
                view.set(view: self, transition: SignUp())
                audioPlayerInstance.play()
            case 3:
                view.set(view: self, transition: Ticket())
                audioPlayerInstance.play()
            default:
                break
        }
    }
      
}
