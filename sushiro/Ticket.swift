
import UIKit
import AVFoundation
import AVKit

//グローバルにする必要ある
var audioPlayerInstance : AVAudioPlayer! = nil

class Ticket: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var addTimer = Timer()
    var timerCount = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景を設定
        view.backgroundColor = UIColor.white
        
        //クラスをインスタンス化
        
        let button = MakeButton()
        let label = MakeLabel()
        let appSetting = AppSetting()
        let guestData = AllData()
        let LoginData = LogInData()
        
        
        //realm初期化
        guestData.doInit()
        appSetting.doInit()
        LoginData.doInit()
        

        
        let soundFilePath = Bundle.main.path(forResource: "\(appDelegate.soundNum)", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)

        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        audioPlayerInstance.prepareToPlay()
        audioPlayerInstance.volume = appDelegate.touchVolume
        
        //UI作成
        label.make(x:40,y:55,width:300,height:80,back:UIColor.clear,_text:"只今の待ち時間",_fontSize:35,view:self)
        label.make(x:40,y:160,width:300,height:150,back:UIColor.clear,_text:"約25分",_fontSize:90,view:self)
        label.make(x:340,y:55,width:300,height:80,back:UIColor.clear,_text:"次のご案内予定",_fontSize:35, view: self)
        label.make(x:340,y:160,width:300,height:150,back:UIColor.clear,_text:"218",_fontSize:90,view:self)
        label.make(x:640,y:55,width:300,height:80,back:UIColor.clear,_text:"ご案内済みのお客様",_fontSize:35,view:self)
        label.make(x:640,y:140,width:300,height:110,back:UIColor.clear,_text:"ご予約テーブル:1420",_fontSize:35,view:self)
        label.make(x:640,y:250,width:300,height:110,back:UIColor.clear,_text:"テーブル:1237",_fontSize:35,view:self)
        label.make(x:640,y:360,width:300,height:120,back:UIColor.clear,_text:"カウンター:237",_fontSize:35,view:self)
        label.make(x:40,y:320,width:640,height:60,back:UIColor.clear,_text:"待ち時間は状況により前後する場合がございます",_fontSize:90,view:self)
        label.make(x:40,y:490,width:460,height:270,back:UIColor.blue,view:self)
        label.make(x:55,y:490,width:470,height:100,back:UIColor.clear,_text:"お店で受付の方",_fontSize:50,view:self)
        label.make(x:540,y:490,width:460,height:270,back:UIColor.red,_fontSize:50,view:self)
        label.make(x:555,y:490,width:470,height:100,back:UIColor.clear,_text:"スマホで受付の方",_fontSize:50,view:self)
        
        button.make(x:100,y:590,width:300,height:150,back:UIColor.white,tag:0,_borderWidth:1.5,_cornerRadius:15,_text:"発券",_fontSize:50,view:self)
        button.make(x:625,y:590,width:300,height:150,back:UIColor.white,tag:1,_borderWidth:1.5,_cornerRadius:15,_text:"チェックイン",_fontSize:50,view:self)
    }
    
    //ボタンイベント
    @objc func selection(sender: UIButton){
        let view = ViewSetting()
        switch sender.tag{
        case 0:
            view.set(view: self, transition: Accounting())
            audioPlayerInstance.play()
        case 1:
            view.set(view: self, transition: CheckIn())
            audioPlayerInstance.play()
        default:break
        }
    }
}
