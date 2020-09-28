import UIKit
import AVFoundation
import AVKit
import RealmSwift


class Menu: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var addTimer = Timer()
    var timerCount = 0
    
    //スワイプの最大
    func tagMax(choise:Int)->Int{
        var tagMax = 0
        tagMax = MenuData().data[choise].count
        return (tagMax)
    }
    // レフトスワイプ時に実行される
    @objc func leftSwipeView(sender: UISwipeGestureRecognizer) {
        let tagFlag1 = appDelegate.choise
        if appDelegate.tagFlag2 < tagMax(choise: tagFlag1)-1{
            appDelegate.tagFlag2 += 1
            viewDidLoad()
        }
    }
    // ライトスワイプ時に実行される
    @objc func rightSwipeView(sender: UISwipeGestureRecognizer) {
        if appDelegate.tagFlag2  > 0{
            appDelegate.tagFlag2 -= 1
            viewDidLoad()
        }
    }
    //タイマー
    @objc func timerCall() {
        viewDidLoad()
        // タイマーを無効にする
        addTimer.invalidate()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tagFlag1 = appDelegate.choise
        
        //背景を設定
        let background = MakeBackgroundImage()
        self.view.addSubview(background.make(image:"second.jpeg"))
        
        //クラスをインスタンス化
        let button = MakeButton()
        let label = MakeLabel()
        
        //写真ボタン作成
        for i in 0..<MenuData().data[tagFlag1][appDelegate.tagFlag2].count{
            var e = 0
            if i <= 2{e=0}else{e=1}
            button.make(x:CGFloat(30+(220*i)-(660*e)),y:CGFloat(225+(220*e)),width:200,height:200,back:UIColor.clear,tag:0+i,_pic:MenuData().data[tagFlag1][appDelegate.tagFlag2][i].pic, _fontSize:20,view:self)
        }
        //共通ボタン作成
        button.make(x:30,y:700,width:100,height:50,back:UIColor.white,tag:50, _borderWidth:1.5,_cornerRadius:6,_text:"戻る", _fontSize:50,view:self)
        button.make(x:650,y:700,width:100,height:50,back:UIColor.white,tag:53, _borderWidth:1.5,_cornerRadius:6,_text:"注文", _fontSize:50,view:self)
        button.make(x:950,y:290,width:60,height:60,back:UIColor.white,tag:51, _borderWidth:1.5,_cornerRadius:6,_text:"➕", _fontSize:50,view:self)
        button.make(x:790,y:290,width:60,height:60,back:UIColor.white,tag:52, _borderWidth:1.5,_cornerRadius:6,_text:"➖", _fontSize:50,view:self)
        
        //商品名（1段目)
        if appDelegate.box[0].name == ""{
        }else{button.make(x:750,y:450,width:200,height:60,back:UIColor.clear,tag:13, _text:"\(appDelegate.box[0].name)",_fontSize:35,view:self)}
        //商品名（2段目)
        if appDelegate.box[1].name == ""{
        }else{button.make(x:750,y:510,width:200,height:60,back:UIColor.clear,tag:14, _text:"\(appDelegate.box[1].name)",_fontSize:35,view:self)}
        //商品名（2段目)
        if appDelegate.box[2].name == ""{
        }else{button.make(x:750,y:570,width:200,height:60,back:UIColor.clear,tag:15, _text:"\(appDelegate.box[2].name)",_fontSize:35,view:self)}
        
        //tag1用ボタンの作成
        for i in 0...8{button.make(x:CGFloat(5+(80*i)),y:5,width:80,height:70,back:UIColor.white,tag:16+i,_borderWidth:1.5, _cornerRadius:6,_text:MenuData().tag1[i], _fontSize:20,view:self)}
        //tag1 選択ラベル
        let r1 = (appDelegate.choise*80)
        label.make(x:CGFloat(5+r1),y:5,width:80,height:70,back:UIColor.black,_alpha:0.3, _fontSize:50,view:self)
        
        //tag2ボタン(tag2がある物だけ作成)
        for i in 0..<MenuData().data[tagFlag1].count{button.make(x:CGFloat(5+(115*i)),y:90,width:110,height:70,back:UIColor.white,tag:25+i,_borderWidth:1.5, _cornerRadius:6,_text:MenuData().tag2[tagFlag1][i], _fontSize:25,view:self)}
        //tag2 選択ラベル
        let r2 = (appDelegate.tagFlag2*115)
        label.make(x:CGFloat(5+r2),y:90,width:110,height:70,back:UIColor.black,_alpha:0.3, _fontSize:50,view:self)
        
        //数量用（共通)
        label.make(x:870,y:290,width:60,height:60,back:UIColor.clear,_text:"\(appDelegate.box[appDelegate.counter].qty)",_fontSize:50,view:self)
        //数量用（1段目)
        label.make(x:960,y:450,width:60,height:60,back:UIColor.clear,_text:"\(appDelegate.box[0].qty)",_fontSize:50,view:self)
        //数量用（2段目)
        label.make(x:960,y:510,width:60,height:60,back:UIColor.clear,_text:"\(appDelegate.box[1].qty)",_fontSize:50,view:self)
        //数量用（3段目)
        label.make(x:960,y:570,width:60,height:60,back:UIColor.clear,_text:"\(appDelegate.box[2].qty)",_fontSize:50,view:self)
        
        
        //商品マスク用view
        if  appDelegate.countType[0].now == "on"{label.make(x:752,y:445,width:212,height:60,back:UIColor.yellow,_alpha:0.5,view:self)}
        if  appDelegate.countType[1].now == "on"{label.make(x:752,y:505,width:212,height:60,back:UIColor.yellow,_alpha:0.5,view:self)}
        if  appDelegate.countType[2].now == "on"{label.make(x:752,y:565,width:212,height:60,back:UIColor.yellow,_alpha:0.5,view:self)}
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
        let view = ViewSetting()
        var j:Int = 0
        var k:Int = 0
        var l:Int = 0
        let tagFlag1 = appDelegate.choise
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
        case 50://戻る
            //tag2の初期化
            appDelegate.tagFlag2 = 0
            view.set(view: self, transition: ViewController())
            audioPlayerInstance.play()
        case 51:// +ボタン
            if appDelegate.box[appDelegate.counter].name != "" && appDelegate.box[appDelegate.counter].qty < 4{
                appDelegate.box[appDelegate.counter].qty += 1
                viewDidLoad()
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
            audioPlayerInstance.play()
        case 52:// −ボタン
            if  appDelegate.box[appDelegate.counter].qty != 0  && appDelegate.box[appDelegate.counter].qty > 0{
                appDelegate.box[appDelegate.counter].qty =  appDelegate.box[appDelegate.counter].qty-1
            }
            viewDidLoad()
            audioPlayerInstance.play()
        case 53://注文ボタン
            appDelegate.counter = 0
            appDelegate.tagFlag2 = 0 //tag2の初期化
            view.set(view: self, transition: Order())
            audioPlayerInstance.play()
        case 13://商品名(1段目)
            appDelegate.counter = 0
            appDelegate.countType[0].now = "on"
            appDelegate.countType[1].now = "off"
            appDelegate.countType[2].now = "off"
            label.make(x:752,y:445,width:212,height:60,back:UIColor.black,_alpha:0.5, _text:"\(appDelegate.box[0].qty)",view:self)
            viewDidLoad()
        case 14://商品名(2段目)
            appDelegate.counter = 1
            appDelegate.countType[0].now = "off"
            appDelegate.countType[1].now = "on"
            appDelegate.countType[2].now = "off"
            label.make(x:752,y:505,width:212,height:60,back:UIColor.black,_alpha:0.5, _text:"\(appDelegate.box[1].qty)",view:self)
            
            viewDidLoad()
        case 15://商品名(3段目)
            appDelegate.counter = 2
            appDelegate.countType[0].now = "off"
            appDelegate.countType[1].now = "off"
            appDelegate.countType[2].now = "on"
            label.make(x:752,y:565,width:212,height:60,back:UIColor.black,_alpha:0.5, _text:"\(appDelegate.box[2].qty)",view:self)
            viewDidLoad()
        case k://写真ボタンを押した時
            if MenuData().data[tagFlag1][appDelegate.tagFlag2].count <= k {
                break
            }
            appDelegate.st(sn:MenuData().data[tagFlag1][appDelegate.tagFlag2][k].name,pn:MenuData().data[tagFlag1][appDelegate.tagFlag2][k].pic)
            loadView()
            viewDidLoad()
            audioPlayerInstance.play()
        case j://tag1
            appDelegate.choise = j-16
            appDelegate.tagFlag2 = 0
            viewDidLoad()
            audioPlayerInstance.play()
        case l://tag2
            appDelegate.tagFlag2 = (l-25)
            viewDidLoad()
            audioPlayerInstance.play()
       
        default:break
        }
    }

}
