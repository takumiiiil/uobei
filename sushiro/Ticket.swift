
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
        let button = makeButton()//m:backgrand,e:picture,e:border
        let label = makeLabel()//o:border,o1:backgrand,o2:0でalpha無効,ic:300でむテキスト無効

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
        self.view.addSubview(label.make(xv:40,yv:55,wv:300,hv:80,f:35,o:0,o1:0,o2:0.0,ic:"只今の待ち時間"))
        self.view.addSubview(label.make(xv:40,yv:160,wv:300,hv:150,f:90,o:0,o1:0,o2:0.0,ic:"約25分"))
        self.view.addSubview(label.make(xv:340,yv:55,wv:300,hv:80,f:35,o:0,o1:0,o2:0.0,ic:"次のご案内予定"))
        self.view.addSubview(label.make(xv:340,yv:160,wv:300,hv:150,f:90,o:0,o1:0,o2:0.0,ic:"218"))
        self.view.addSubview(label.make(xv:640,yv:55,wv:300,hv:80,f:35,o:0,o1:0,o2:0.0,ic:"ご案内済みのお客様"))
        self.view.addSubview(label.make(xv:640,yv:140,wv:300,hv:110,f:35,o:0,o1:0,o2:0.0,ic:"ご予約テーブル:1420"))
        self.view.addSubview(label.make(xv:640,yv:250,wv:300,hv:110,f:35,o:0,o1:0,o2:0.0,ic:"テーブル:1237"))
        self.view.addSubview(label.make(xv:640,yv:360,wv:300,hv:120,f:35,o:0,o1:0,o2:0.0,ic:"カウンター:237"))
        self.view.addSubview(label.make(xv:40,yv:320,wv:640,hv:60,f:90,o:0,o1:0,o2:0.0,ic:"待ち時間は状況により前後する場合がございます"))
        self.view.addSubview(label.make(xv:40,yv:490,wv:460,hv:270,f:50,o:0,o1:3,o2:0.0,ic:""))
        self.view.addSubview(label.make(xv:55,yv:490,wv:470,hv:100,f:50,o:0,o1:0,o2:0.0,ic:"お店で受付の方"))
        self.view.addSubview(button.make(xv:100,yv:590,wv:300,hv:150,f:50,b:"発券",c:1,d:1,e:0,m:1))
        self.view.addSubview(label.make(xv:540,yv:490,wv:460,hv:270,f:50,o:0,o1:4,o2:0.0,ic:""))
        self.view.addSubview(label.make(xv:555,yv:490,wv:470,hv:100,f:50,o:0,o1:0,o2:0.0,ic:"スマホで受付の方"))
        self.view.addSubview(button.make(xv:625,yv:590,wv:300,hv:150,f:50,b:"チックイン",c:2,d:1,e:0,m:1))
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }
    
    //ボタンイベント
    @objc func selection(sender: UIButton){
        let view = viewSetting()
        switch sender.tag{
        case 1:
            self.present(view.viewSet(view: Accounting(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        case 2:
            self.present(view.viewSet(view: Camera(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        default:break
        }
    }
}
