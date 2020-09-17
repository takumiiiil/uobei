import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import Foundation
import RealmSwift
import CoreImage


class Accounting: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let myInputImage = CIImage(image: UIImage(named: "hakken2")!)
    var addTimer = Timer()
    var timerCount = 0
    var flag:[Bool] = [false,false,false]
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayerInstance.prepareToPlay()
        
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 1024,height: 768))
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
        
        //クラスをインスタンス化
        let button = MakeButton()
        let label = MakeLabel()
        //共通ボタン作成
        self.view.addSubview(label.make(x:40,y:180,width:160,height:70,back:UIColor.clear,_text:"大人・子供\n(7歳〜)", _fontSize:50))
        self.view.addSubview(label.make(x:40,y:310,width:160,height:70,back:UIColor.clear,_text:"未就学児\n(〜6歳)", _fontSize:50))
       
        for i in 0...7{
            if i == 7 {
                self.view.addSubview(button.make(x:CGFloat(215+(i*95)),y:180,width:80,height:80,back:UIColor.white,tag:i,_borderWidth:1.5,_cornerRadius:6,_text:"7+", _fontSize:50))
            }else{
                self.view.addSubview(button.make(x:CGFloat(215+(i*95)),y:180,width:80,height:80,back:UIColor.white,tag:i,_borderWidth:1.5,_cornerRadius:6,_text:"\(i)", _fontSize:50))
            }
        }
        for i in 8...15{
              if i == 15 {
              self.view.addSubview(button.make(x:CGFloat(215+((i-8)*95)),y:310,width:80,height:80,back:UIColor.white,tag:i,_borderWidth:1.5,_cornerRadius:6,_text:"7+", _fontSize:50))
              }else{
              self.view.addSubview(button.make(x:CGFloat(215+((i-8)*95)),y:310,width:80,height:80,back:UIColor.white,tag:i,_borderWidth:1.5,_cornerRadius:6,_text:"\(i-8)", _fontSize:50))
                  }
              }
        
        self.view.addSubview(button.make(x:215,y:440,width:365,height:100,back:UIColor.white,tag:16,_borderWidth:1.5,_cornerRadius:6,_text:"カウンター", _fontSize:50))
        self.view.addSubview(button.make(x:595,y:440,width:365,height:100,back:UIColor.white,tag:17,_borderWidth:1.5,_cornerRadius:6,_text:"テーブル", _fontSize:50))
        self.view.addSubview(button.make(x:215,y:570,width:745,height:100,back:UIColor.white,tag:18,_borderWidth:1.5,_cornerRadius:6,_text:"発券", _fontSize:50))
        self.view.addSubview(button.make(x:40,y:710,width:100,height:50,back:UIColor.white,tag:19,_borderWidth:1.5,_cornerRadius:6,_text:"戻る", _fontSize:50))
    
        //マスク用label上段
        if appDelegate.maskFlag != 100 {self.view.addSubview(label.make(x:CGFloat(215+(appDelegate.maskFlag*95)),y:180,width:80,height:80,back:UIColor.black,_alpha:0.3))}
        //マスク用label中段
        if appDelegate.maskFlag2 != 100 {self.view.addSubview(label.make(x:CGFloat(215+(appDelegate.maskFlag2*95)),y:310,width:80,height:80,back:UIColor.black,_alpha:0.3))}
        //マスク用label下段
        if appDelegate.maskFlag3 != 100 {self.view.addSubview(label.make(x:CGFloat(215+(appDelegate.maskFlag3*380)),y:440,width:365,height:100,back:UIColor.black,_alpha:0.3))}
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }

    //ボタンイベント
    @objc func selection(sender: UIButton){
        let view = viewSetting()
        if sender.tag <= 7 {
            k = sender.tag
            let realm = try! Realm()
            let guestDataObj = realm.objects(guestData.self).last
            try! realm.write {
                guestDataObj?.adultCount = "\(k)"
            }
            flag[0] = true
            appDelegate.maskFlag = k
            viewDidLoad()
            audioPlayerInstance.play()
        }
        if sender.tag >= 8 && sender.tag <= 15{
            l = sender.tag - 8
            let realm = try! Realm()
            let guestDataObj = realm.objects(guestData.self).last
            try! realm.write {
                guestDataObj?.childCount = "\(l)"
            }
            flag[1] = true
            appDelegate.maskFlag2 = l
            viewDidLoad()
            audioPlayerInstance.play()
        }
        switch sender.tag{
        case 16:
            let realm = try! Realm()
            let guestDataObj = realm.objects(guestData.self).last
            try! realm.write {
                guestDataObj?.seatType = "カウンター"
            }
            flag[2] = true
            appDelegate.maskFlag3 = sender.tag - 16
            viewDidLoad()
            audioPlayerInstance.play()
        case 17:
            let realm = try! Realm()
            let guestDataObj = realm.objects(guestData.self).last
            try! realm.write {
                guestDataObj?.seatType = "テーブル"
            }
            flag[2] = true
            appDelegate.maskFlag3 = sender.tag - 16
            viewDidLoad()
            audioPlayerInstance.play()
        case 18:
            if flag[0] && flag[1] && flag[2] {
                for i in 0...2{
                    flag[i] = false
                }
                appDelegate.maskFlag = 100
                appDelegate.maskFlag2 = 100
                appDelegate.maskFlag3 = 100
                self.present(view.viewSet(view: First(), anime: .flipHorizontal), animated: false, completion: nil)
                audioPlayerInstance.play()
            }else{
                //ポップアップ表示
                let ngalert = UIAlertController(title: "未入力があります", message: "", preferredStyle: .alert)
                ngalert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
                self.present(ngalert, animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    ngalert.dismiss(animated: true, completion: nil)
                    })
                })
                break
            }
        case 19:
            for i in 0...2{
                flag[i] = false
            }
            appDelegate.maskFlag = 100
            appDelegate.maskFlag2 = 100
            appDelegate.maskFlag3 = 100
            self.present(view.viewSet(view: Ticket(), anime: .flipHorizontal), animated: false, completion: nil)
        default:break
        }
    }
}
