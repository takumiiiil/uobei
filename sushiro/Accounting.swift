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
        let button = makeButton()//m:backgrand,e:picture,e:border
        let label = makeLabel()//o:border,o1:backgrand,o2:0でalpha無効,ic:300でむテキスト無効
        
        //共通ボタン作成
        self.view.addSubview(label.make(xv:40,yv:180,wv:160,hv:70,f:50,o:0,o1:0,o2:0.0,ic:"大人・子供\n(7歳〜)"))
        self.view.addSubview(label.make(xv:40,yv:310,wv:160,hv:70,f:50,o:0,o1:0,o2:0.0,ic:"未就学児\n(〜6歳)"))
        for i in 0...7{
            if i == 7 {
                self.view.addSubview(button.make(xv:215 + (i*95),yv:180,wv:80,hv:80,f:50,b:"7+",c:i,d:1,e:0,m:1))
            }else{
                self.view.addSubview(button.make(xv:215 + (i*95),yv:180,wv:80,hv:80,f:50,b:"\(i)",c:i,d:1,e:0,m:1))
            }
        }
        for i in 8...15{
              if i == 15 {
              self.view.addSubview(button.make(xv:215 + ((i-8)*95),yv:310,wv:80,hv:80,f:50,b:"7+",c:i,d:1,e:0,m:1))
              }else{
                  self.view.addSubview(button.make(xv:215 + ((i-8)*95),yv:310,wv:80,hv:80,f:50,b:"\(i-8)",c:i,d:1,e:0,m:1))
                  }
              }
        
        self.view.addSubview(button.make(xv:215,yv:440,wv:365,hv:100,f:50,b:"カウンター",c:16,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:595,yv:440,wv:365,hv:100,f:50,b:"テーブル",c:17,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:215,yv:570,wv:745,hv:100,f:50,b:"発券",c:18,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:40,yv:710,wv:100,hv:50,f:50,b:"戻る",c:19,d:1,e:0,m:1))
        
        //マスク用label上段
        if appDelegate.maskFlag != 100 {
            self.view.addSubview(label.make(xv:215 + (appDelegate.maskFlag*95),yv:180,wv:80,hv:80,f:50,o:0,o1:2,o2:0.3, ic: ""))
        }
        //マスク用label中段
        if appDelegate.maskFlag2 != 100 {
            self.view.addSubview(label.make(xv:215 + (appDelegate.maskFlag2*95),yv:310,wv:80,hv:80,f:50,o:0,o1:2,o2:0.3, ic: ""))
        }
        //マスク用label下段
        if appDelegate.maskFlag3 != 100 {
            self.view.addSubview(label.make(xv:215 + (appDelegate.maskFlag3*380),yv:440,wv:365,hv:100,f:50,o:0,o1:2,o2:0.3, ic: ""))
        }
        
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
