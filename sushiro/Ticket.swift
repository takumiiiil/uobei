
import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import Foundation
import RealmSwift
import CoreImage

//グローバルにする必要ある
var audioPlayerInstance : AVAudioPlayer! = nil

class Ticket: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let myInputImage = CIImage(image: UIImage(named: "kara")!)
    var addTimer = Timer()
    var timerCount = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //クラスをインスタンス化
        let button = MakeButton()
        let label = MakeLabel()
        
        //UIImageViewを作成する.
        myImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 1024,height: 768))
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
        let realm = try! Realm()
        let obj = realm.objects(guestData.self).last
        if obj != nil{
            try! realm.write {
                obj?.seatNum = ""
                obj?.dish = 0
                obj?.inTime = ""
                obj?.outTime = ""
                obj?.adultCount = ""
                obj?.childCount = ""
                obj?.seatType = ""
            }
        }else{
            try! realm.write {
                realm.add(guestData())
            }
        }
        try! realm.write {
            realm.add(allData())
        }
        
    
        let saveObj = realm.objects(appSetting.self).last
            if saveObj != nil {
                try! realm.write {
                    appDelegate.touchVolume = saveObj!.touchVolume
                    appDelegate.movieVolume = saveObj!.movieVolume
                    appDelegate.volumeM = saveObj!.volumeM
                    appDelegate.volumeMstatus = saveObj!.volumeMstatus
                    appDelegate.volumeVstatus = saveObj!.volumeVstatus
                    appDelegate.soundNum = saveObj!.soundNum
                    appDelegate.movieNum = saveObj!.movieNum
                    appDelegate.pickerView1Ini = saveObj!.pickerView1Ini
                    appDelegate.pickerView2Ini = saveObj!.pickerView2Ini
                }
        }else{
            try! realm.write {
                realm.add(appSetting())
            }
        }
        
        
        let soundFilePath = Bundle.main.path(forResource: "\(appDelegate.soundNum)", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        audioPlayerInstance.volume = appDelegate.touchVolume
        
        //共通ボタン作成
        self.view.addSubview(label.make(x:40,y:55,width:300,height:80,back:UIColor.clear,_text:"只今の待ち時間",_fontSize:35))
        self.view.addSubview(label.make(x:40,y:160,width:300,height:150,back:UIColor.clear,_text:"約25分",_fontSize:90))
        self.view.addSubview(label.make(x:340,y:55,width:300,height:80,back:UIColor.clear,_text:"次のご案内予定",_fontSize:35))
        self.view.addSubview(label.make(x:340,y:160,width:300,height:150,back:UIColor.clear,_text:"218",_fontSize:90))
        self.view.addSubview(label.make(x:640,y:55,width:300,height:80,back:UIColor.clear,_text:"ご案内済みのお客様",_fontSize:35))
        self.view.addSubview(label.make(x:640,y:140,width:300,height:110,back:UIColor.clear,_text:"ご予約テーブル:1420",_fontSize:35))
        self.view.addSubview(label.make(x:640,y:250,width:300,height:110,back:UIColor.clear,_text:"テーブル:1237",_fontSize:35))
        self.view.addSubview(label.make(x:640,y:360,width:300,height:120,back:UIColor.clear,_text:"カウンター:237",_fontSize:35))
        self.view.addSubview(label.make(x:40,y:320,width:640,height:60,back:UIColor.clear,_text:"待ち時間は状況により前後する場合がございます",_fontSize:90))
        self.view.addSubview(label.make(x:40,y:490,width:460,height:270,back:UIColor.blue))
        self.view.addSubview(label.make(x:55,y:490,width:470,height:100,back:UIColor.clear,_text:"お店で受付の方",_fontSize:50))
        self.view.addSubview(label.make(x:540,y:490,width:460,height:270,back:UIColor.red,_fontSize:50))
        self.view.addSubview(label.make(x:555,y:490,width:470,height:100,back:UIColor.clear,_text:"スマホで受付の方",_fontSize:50))
        self.view.addSubview(button.make(x:100,y:590,width:300,height:150,back:UIColor.white,tag:0,_borderWidth:1.5,_cornerRadius:15,_text:"発券",_fontSize:50))
        self.view.addSubview(button.make(x:625,y:590,width:300,height:150,back:UIColor.white,tag:1,_borderWidth:1.5,_cornerRadius:15,_text:"チェックイン",_fontSize:50))
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }
    
    //ボタンイベント
    @objc func selection(sender: UIButton){
        let view = viewSetting()
        switch sender.tag{
        case 0:
            self.present(view.viewSet(view: Accounting(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        case 1:
            self.present(view.viewSet(view: Camera(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        default:break
        }
    }
}
