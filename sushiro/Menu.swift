import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import Foundation
import RealmSwift
import CoreImage

var myImageView: UIImageView!

class Menu: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let myInputImage = CIImage(image: UIImage(named: "second.jpeg")!)
    var addTimer = Timer()
    var timerCount = 0
    
    //メソッド作成
    //スワイプの最大
    func tag_max(choise:Int)->Int{
        var tag_max = 0
        tag_max = appDelegate.data[choise].count
        return (tag_max)
    }
    // レフトスワイプ時に実行される
    @objc func leftSwipeView(sender: UISwipeGestureRecognizer) {
        let tag_flag1 = appDelegate.choise
        if appDelegate.tagFlag2 < tag_max(choise: tag_flag1)-1{
            appDelegate.tagFlag2 = appDelegate.tagFlag2 + 1
            viewDidLoad()
        }
    }
    // ライトスワイプ時に実行される
    @objc func rightSwipeView(sender: UISwipeGestureRecognizer) {
        if appDelegate.tagFlag2  > 0{
            appDelegate.tagFlag2 = appDelegate.tagFlag2 - 1
            viewDidLoad()
        }
    }
    //タイマー
    @objc func timerCall() {
        viewDidLoad()
        // タイマーを無効にする
        addTimer.invalidate()
    }
    
    //メソッド終わり
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tag_flag1 = appDelegate.choise
        //クラスをインスタンス化
        let button = MakeButton()
        let label = MakeLabel()
        
        
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 1024,height: 768))
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
        
        //写真ボタン作成
        for d in 0..<appDelegate.data[tag_flag1][appDelegate.tagFlag2].count{
            var e = 0
            if d <= 2{e=0}else{e=1}
            self.view.addSubview(button.make(x:CGFloat(30+(220*d)-(660*e)),y:CGFloat(225+(220*e)),width:200,height:200,back:UIColor.clear,tag:0+d,_pic:appDelegate.data[tag_flag1][appDelegate.tagFlag2][d].pic, _fontSize:20))
        }
        //共通ボタン作成
        self.view.addSubview(button.make(x:30,y:700,width:100,height:50,back:UIColor.white,tag:50, _borderWidth:1.5,_cornerRadius:6,_text:"戻る", _fontSize:50))
        self.view.addSubview(button.make(x:650,y:700,width:100,height:50,back:UIColor.white,tag:53, _borderWidth:1.5,_cornerRadius:6,_text:"注文", _fontSize:50))
        self.view.addSubview(button.make(x:950,y:290,width:60,height:60,back:UIColor.white,tag:51, _borderWidth:1.5,_cornerRadius:6,_text:"➕", _fontSize:50))
        self.view.addSubview(button.make(x:790,y:290,width:60,height:60,back:UIColor.white,tag:52, _borderWidth:1.5,_cornerRadius:6,_text:"➖", _fontSize:50))
     
        //商品名（1段目)
        if appDelegate.box[0].name == ""{
        }else{self.view.addSubview(button.make(x:750,y:450,width:200,height:60,back:UIColor.clear,tag:13, _text:"\(appDelegate.box[0].name)",_fontSize:35))}
        //商品名（2段目)
        if appDelegate.box[1].name == ""{
        }else{self.view.addSubview(button.make(x:750,y:510,width:200,height:60,back:UIColor.clear,tag:14, _text:"\(appDelegate.box[1].name)",_fontSize:35))}
        //商品名（2段目)
        if appDelegate.box[2].name == ""{
        }else{self.view.addSubview(button.make(x:750,y:570,width:200,height:60,back:UIColor.clear,tag:15, _text:"\(appDelegate.box[2].name)",_fontSize:35))}
        
        //tag1用ボタンの作成
        for k in 0...8{self.view.addSubview(button.make(x:CGFloat(5+(80*k)),y:5,width:80,height:70,back:UIColor.white,tag:16+k,_borderWidth:1.5, _cornerRadius:6,_text:appDelegate.tag1[k], _fontSize:20))}
        //tag1 選択ラベル
        let r1 = (appDelegate.choise*80)
        self.view.addSubview(label.make(x:CGFloat(5+r1),y:5,width:80,height:70,back:UIColor.black,_alpha:0.3, _fontSize:50))
        
        //tag2ボタン(tag2がある物だけ作成)
        for d in 0..<appDelegate.data[tag_flag1].count{self.view.addSubview(button.make(x:CGFloat(5+(115*d)),y:90,width:110,height:70,back:UIColor.white,tag:25+d,_borderWidth:1.5, _cornerRadius:6,_text:appDelegate.tag2[tag_flag1][d], _fontSize:25))}
        //tag2 選択ラベル
        let r2 = (appDelegate.tagFlag2*115)
        self.view.addSubview(label.make(x:CGFloat(5+r2),y:90,width:110,height:70,back:UIColor.black,_alpha:0.3, _fontSize:50))
        
        //数量用（共通)
        self.view.addSubview(label.make(x:870,y:290,width:60,height:60,back:UIColor.clear,_text:"\(appDelegate.box[appDelegate.counter].qty)",_fontSize:50))
        //数量用（1段目)
        self.view.addSubview(label.make(x:960,y:450,width:60,height:60,back:UIColor.clear,_text:"\(appDelegate.box[0].qty)",_fontSize:50))
        //数量用（2段目)
        self.view.addSubview(label.make(x:960,y:510,width:60,height:60,back:UIColor.clear,_text:"\(appDelegate.box[1].qty)",_fontSize:50))
        //数量用（3段目)
        self.view.addSubview(label.make(x:960,y:570,width:60,height:60,back:UIColor.clear,_text:"\(appDelegate.box[2].qty)",_fontSize:50))
        
        
        //商品マスク用view
        if  appDelegate.countType[0].now == "on"{self.view.addSubview(label.make(x:752,y:445,width:212,height:60,back:UIColor.yellow,_alpha:0.5))}
        if  appDelegate.countType[1].now == "on"{self.view.addSubview(label.make(x:752,y:505,width:212,height:60,back:UIColor.yellow,_alpha:0.5))}
        if  appDelegate.countType[2].now == "on"{self.view.addSubview(label.make(x:752,y:565,width:212,height:60,back:UIColor.yellow,_alpha:0.5))}
        //一度に4皿までメッセージ
        let mess = UIImageView(frame: CGRect(x:CGFloat(100), y: CGFloat(390), width: CGFloat(550), height: CGFloat(700)))
        mess.image = UIImage(named: "mess1.png")!
        if appDelegate.box[0].name == ""{
            self.view.addSubview(mess)
        }
        
        //右上view
        if appDelegate.box[0].view != ""{
            let view1 = UIImageView(frame: CGRect(x:CGFloat(770), y: CGFloat(80), width: CGFloat(250), height: CGFloat(200)))
            let v_Image:UIImage = UIImage(named: appDelegate.box[appDelegate.counter].view)!
            view1.backgroundColor = UIColor.black
            view1.image = v_Image
            self.view.addSubview(view1)
        }
        // viewにジェスチャーを登録
        // スワイプを定義
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Menu.leftSwipeView(sender:)))  //Swift3
        // ライトスワイプのみ反応するようにする
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        // スワイプを定義
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Menu.rightSwipeView(sender:)))  //Swift3
        // ライトスワイプのみ反応するようにする
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    //ボタンイベント処理
    @objc func selection(sender: UIButton){
        let label = MakeLabel()
        let view = viewSetting()
        let tag_flag1 = appDelegate.choise
        if sender.tag<=5{
            k = sender.tag
        }
        if sender.tag>=16 && sender.tag<=24{
            j = sender.tag
        }
        if sender.tag>=25{
            l = sender.tag
        }
        switch sender.tag{
        case k://写真ボタンを押した時
            appDelegate.st(sn:appDelegate.data[tag_flag1][appDelegate.tagFlag2][k].name,pn:appDelegate.data[tag_flag1][appDelegate.tagFlag2][k].pic)
            loadView()
            viewDidLoad()
            audioPlayerInstance.play()
        case 50://戻る
            //tag2の初期化
            appDelegate.tagFlag2 = 0
            self.dismiss(animated: false, completion: nil)
            loadView()
            viewDidLoad()
            audioPlayerInstance.play()
        case 51:// +ボタン
            if appDelegate.box[appDelegate.counter].qty < 4{
                appDelegate.box[appDelegate.counter].qty =  appDelegate.box[appDelegate.counter].qty+1
                viewDidLoad()
                audioPlayerInstance.play()
            }else if appDelegate.box[appDelegate.counter].qty == 4{
                // 画像を設定する.
                let myInputImage = CIImage(image: UIImage(named: "over.jpeg")!)
                // ImageViewを定義する.
                var myImageView: UIImageView!
                // UIImageViewを作成する.
                myImageView = UIImageView(frame: UIScreen.main.bounds)
                myImageView.image = UIImage(ciImage: myInputImage!)
                self.view.addSubview(myImageView)
                audioPlayerInstance.play()
                // タイマーの設定（5秒間隔でメソッド「timerCall」を呼び出す）
                addTimer =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)
                
            }
        case 52:// −ボタン
            if  appDelegate.box[appDelegate.counter].qty != 0  && appDelegate.box[appDelegate.counter].qty > 0{
                appDelegate.box[appDelegate.counter].qty =  appDelegate.box[appDelegate.counter].qty-1
            }
            viewDidLoad()
            audioPlayerInstance.play()
        case 53://注文ボタン
            appDelegate.counter = 0
            appDelegate.tagFlag2 = 0 //tag2の初期化
            self.present(view.viewSet(view: Order(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        case 13://商品名(1段目)
            appDelegate.counter = 0
            appDelegate.countType[0].now = "on"
            appDelegate.countType[1].now = "off"
            appDelegate.countType[2].now = "off"
            self.view.addSubview(label.make(x:752,y:445,width:212,height:60,back:UIColor.black,_alpha:0.5, _text:"\(appDelegate.box[2].qty)", _fontSize:50))
            viewDidLoad()
        case 14://商品名(2段目)
            appDelegate.counter = 1
            appDelegate.countType[0].now = "off"
            appDelegate.countType[1].now = "on"
            appDelegate.countType[2].now = "off"
            self.view.addSubview(label.make(x:752,y:505,width:212,height:60,back:UIColor.black,_alpha:0.5, _text:"\(appDelegate.box[2].qty)", _fontSize:50))
           
            viewDidLoad()
        case 15://商品名(3段目)
            appDelegate.counter = 2
            appDelegate.countType[0].now = "off"
            appDelegate.countType[1].now = "off"
            appDelegate.countType[2].now = "on"
            self.view.addSubview(label.make(x:752,y:5655,width:212,height:60,back:UIColor.black,_alpha:0.5, _text:"\(appDelegate.box[2].qty)", _fontSize:50))
         
            viewDidLoad()
        case j://tag1
            appDelegate.choise = j-16
            appDelegate.tagFlag2 = 0
            viewDidLoad()
        case l://tag2
            appDelegate.tagFlag2 = (l-25)
            viewDidLoad()
        default:break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//更新２
