import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import RealmSwift

class Reception: UIViewController,UITextFieldDelegate,UITabBarDelegate{
    var change:String = ""
    let calculator = MakeCalculator()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //背景を設定
        view.backgroundColor = UIColor.white
        
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        
        //集計操作
        let realm = try! Realm()
        let guestObj = realm.objects(GuestData.self).last
        let allObj = realm.objects(AllData.self)
        let button = MakeButton()
        let scrollView = MakeScrollView()
        
        let people = (Int(guestObj!.adultCount)!) + (Int(guestObj!.childCount)!)//合計人数
        let tax = Int(Double(guestObj!.dish*100)*0.1)//消費税
        let date = Date()
        let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
        scrollView.make(x:30,y:50,width:Int(view.frame.width/3),height:640,contentHeight:770,view: self)
        scrollView.makeLabel(x:20,y:15,width:300,height:20,back:UIColor.clear,_text:"うまいすしを、精一杯。", _fontSize:25,view:scrollView)
        scrollView.makeLabel(x:20,y:35,width:300,height:50,back:UIColor.clear,_text:"スシロー",_fontSize:45,view:scrollView)
        scrollView.makeLabel(x:20,y:95,width:300,height:25,back:UIColor.clear,_text:"ホール・キッチンスタッフ募集中!!",_fontSize:35,view:scrollView)
        scrollView.makeLabel(x:20,y:130,width:300,height:25,back:UIColor.clear,_text:"詳しくはURLから",_fontSize:35,view:scrollView)
        scrollView.makeLabel(x:20,y:165,width:300,height:25,back:UIColor.clear,_text:"www.akindo-sushiro.co.jp/m",_fontSize:35,view:scrollView)
        scrollView.makeLabel(x:20,y:195,width:300,height:175,back:UIColor.clear,_borderWidth:1.5,_fontSize:35,view:scrollView)
        scrollView.makeLabel(x:70,y:210,width:200,height:40,back:UIColor.clear,_text:"アンケートに答えて\nお得なクーポンをゲット!",_fontSize:35,view:scrollView)
        scrollView.makeQrcode(xv:30,yv:260,wv:100,hv:100,sum:"https://www.akindo-sushiro.co.jp",view:scrollView)
        scrollView.makeLabel(x:130,y:260,width:185,height:35,back:UIColor.clear,_text:"QRからアンケートサイトにアクセス\n本レシートの招待番号を入力して下さい",_fontSize:10,view:scrollView)
        scrollView.makeLabel(x:110,y:330,width:185,height:35,back:UIColor.clear,_text:"回答期限:本日より7日以内",_fontSize:10,view:scrollView)
        scrollView.makeLabel(x:20,y:380,width:185,height:35,back:UIColor.clear,_text:"レシート#   \(allObj.count)",_fontSize:15,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:410,width:300,height:35,back:UIColor.clear,_text:"席:\(guestObj!.seatType)"+"        \(people)名",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:440,width:300,height:35,back:UIColor.clear,_text:"\(dateAndTime)",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:470,width:300,height:35,back:UIColor.clear,_text:"扱者:佐藤と東",_fontSize:15,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:500,width:300,height:35,back:UIColor.clear,_text:"100円皿 (\(guestObj!.dish)点 × @¥100) ¥\(guestObj!.dish*100)",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:530,width:300,height:35,back:UIColor.clear,_text:"----------------------------------------------",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:560,width:300,height:35,back:UIColor.clear,_text:"小計　　　   　　¥\(guestObj!.dish*100)",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:590,width:300,height:35,back:UIColor.clear,_text:"外税(10%)　　　　¥\(tax)",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:630,width:300,height:35,back:UIColor.clear,_text:"==================================",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:670,width:300,height:35,back:UIColor.clear,_text:"合計(\(guestObj!.dish))点　　　　¥\(guestObj!.dish*110)",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:700,width:300,height:35,back:UIColor.clear,_text:"お預り　　　　　　　　　　　　¥\(calculator.inputNum)",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        scrollView.makeLabel(x:20,y:730,width:300,height:35,back:UIColor.clear,_text:"お釣　　　　　　　　　　　　　¥\(change)",_fontSize:25,_alignment:NSTextAlignment.left,view:scrollView)
        
        button.make(x:30,y:700,width:100,height:50,back:UIColor.white,tag:1, _borderWidth:1.5,_cornerRadius:6,_text:"戻る", _fontSize:50,view:self)
        //レジ作成
        calculator.make(view:self,style:.full)
    }
    
    @objc func selection(sender: UIButton){
        let view = ViewSetting()
        switch sender.tag{
            case 1://戻るボタン
                appDelegate.geneMaskFlag = 100
                view.set(view: self, transition: History())
                audioPlayerInstance.play()
            default:
                break
        }
    }
}

