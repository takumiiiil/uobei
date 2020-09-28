import UIKit
import AVFoundation
import AVKit
import RealmSwift


class First: UIViewController {
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayerInstance.prepareToPlay()
        
        //背景を設定
        let background = MakeBackgroundImage()
        self.view.addSubview(background.make(image:"first.jpeg"))
        
        //クラスをインスタンス化
        let button = MakeButton()
    
        //透明なボタンを作ってタップを反応させる
        button.make(x:0,y:0,width:1024,height:768,back:UIColor.clear,tag:0,view:self)
     
    }

    @objc func selection(sender: UIButton){
        let view = ViewSetting()
        switch sender.tag{
            case 0:
                let date = Date()
                let dateAndTime = date.formattedDateWith(style: .time)
                let realm = try! Realm()
                let obj = realm.objects(GuestData.self).last
                try! realm.write {
                    obj?.inTime = dateAndTime
                }
                view.set(view: self, transition: ViewController())
                audioPlayerInstance.play()
            default:break
        }
    }
    
    override func viewDidAppear(_ animated: Bool){
        loadView()//videoplayerを破棄 画面遷移なしで
        viewDidLoad()
    }
}
