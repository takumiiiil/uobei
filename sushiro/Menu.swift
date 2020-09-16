
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
        let button = makeButton()//m:backgrand,e:picture,e:border
        let label = makeLabel()//o:border,o1:backgrand,o2:0でalpha無効,ic:300でむテキスト無効
        //        let qrc = makeQrc()
        
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 1024,height: 768))
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
        
        //写真ボタン作成
        for d in 0..<appDelegate.data[tag_flag1][appDelegate.tagFlag2].count{
            var e = 0
            if d <= 2{e=0}else{e=1}
            self.view.addSubview(button.make(xv:30+(220*d)-(660*e),yv:225+(220*e),wv:200,hv:200,f:20,b:appDelegate.data[tag_flag1][appDelegate.tagFlag2][d].pic,c:0+d,d:0,e:1,m:0))
        }
        //共通ボタン作成
        self.view.addSubview(button.make(xv:30,yv:700,wv:100,hv:50,f:50,b:"戻る",c:50,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:950,yv:290,wv:60,hv:60,f:50,b:"➕",c:51,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:790,yv:290,wv:60,hv:60,f:50,b:"➖",c:52,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:650,yv:700,wv:100,hv:50,f:50,b:"注文",c:53,d:1,e:0,m:1))
        //商品名（1段目)
        if appDelegate.box[0].name == ""{
        }else{
            self.view.addSubview(button.make(xv:750,yv:450,wv:200,hv:60,f:35,b:"\(appDelegate.box[0].name)",c:13,d:0,e:0,m:0))
        }
        //商品名（2段目)
        if appDelegate.box[1].name == ""{
        }else{
            self.view.addSubview(button.make(xv:750,yv:510,wv:200,hv:60,f:35,b:"\(appDelegate.box[1].name)",c:14,d:0,e:0,m:0))
        }
        //商品名（2段目)
        if appDelegate.box[2].name == ""{
        }else{
            self.view.addSubview(button.make(xv:750,yv:570,wv:200,hv:60,f:35,b:"\(appDelegate.box[2].name)",c:15,d:0,e:0,m:0))
        }
        //tag1用ボタンの作成
        for k in 0...8{
            self.view.addSubview(button.make(xv:5+(80*k),yv:5,wv:80,hv:70,f:20,b:appDelegate.tag1[k],c:16+k,d:1,e:0,m:1))
        }
        //tag1 選択ラベル
        let r1 = (appDelegate.choise*80)
        self.view.addSubview(label.make(xv:5+r1,yv:5,wv:80,hv:70,f:50,o:0,o1:2,o2:0.3,ic:""))
        
        //tag2ボタン(tag2がある物だけ作成)
        for d in 0..<appDelegate.data[tag_flag1].count{
            self.view.addSubview(button.make(xv:5+(115*d),yv:90,wv:110,hv:70,f:25,b:appDelegate.tag2[tag_flag1][d],c:25+d,d:1,e:0,m:1))
        }
        //tag2 選択ラベル
        let r2 = (appDelegate.tagFlag2*115)
        self.view.addSubview(label.make(xv:5+r2,yv:90,wv:110,hv:70,f:50,o:0,o1:2,o2:0.3,ic:""))
        
        //数量用（共通)
        self.view.addSubview(label.make(xv:870,yv:290,wv:60,hv:60,f:50,o:2,o1:0,o2:0,ic:"\(appDelegate.box[appDelegate.counter].qty)"))
        //数量用（1段目)
        self.view.addSubview(label.make(xv:960,yv:450,wv:60,hv:60,f:50,o:0,o1:0,o2:0,ic:"\(appDelegate.box[0].qty)"))
        //数量用（2段目)
        self.view.addSubview(label.make(xv:960,yv:510,wv:60,hv:60,f:50,o:0,o1:0,o2:0,ic:"\(appDelegate.box[1].qty)"))
        //数量用（3段目)
        self.view.addSubview(label.make(xv:960,yv:570,wv:60,hv:60,f:50,o:0,o1:0,o2:0,ic:"\(appDelegate.box[2].qty)"))
        
        //商品マスク用view
        if  appDelegate.countType[0].now == "on"{
            self.view.addSubview(label.make(xv:752,yv:445,wv:212,hv:60,f:50,o:0,o1:3,o2:0.5,ic:""))
        }
        if  appDelegate.countType[1].now == "on"{
            self.view.addSubview(label.make(xv:752,yv:505,wv:212,hv:60,f:50,o:0,o1:3,o2:0.5,ic:""))
        }
        if  appDelegate.countType[2].now == "on"{
            self.view.addSubview(label.make(xv:752,yv:565,wv:212,hv:60,f:50,o:0,o1:3,o2:0.5,ic:""))
        }
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
        let label = makeLabel()//o:border,o1:backgrand,o2:alpha
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
            self.view.addSubview(label.make(xv:752,yv:445,wv:212,hv:60,f:50,o:0,o1:2,o2:0.5,ic:"\(appDelegate.box[2].qty)"))
            viewDidLoad()
        case 14://商品名(2段目)
            appDelegate.counter = 1
            appDelegate.countType[0].now = "off"
            appDelegate.countType[1].now = "on"
            appDelegate.countType[2].now = "off"
            self.view.addSubview(label.make(xv:752,yv:505,wv:212,hv:60,f:50,o:0,o1:2,o2:0.5,ic:"\(appDelegate.box[2].qty)"))
            viewDidLoad()
        case 15://商品名(3段目)
            appDelegate.counter = 2
            appDelegate.countType[0].now = "off"
            appDelegate.countType[1].now = "off"
            appDelegate.countType[2].now = "on"
            self.view.addSubview(label.make(xv:752,yv:565,wv:212,hv:60,f:50,o:0,o1:2,o2:0.5,ic:"\(appDelegate.box[2].qty)"))
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

