import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import Foundation
import RealmSwift
import CoreImage



class Reception: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let myInputImage = CIImage(image: UIImage(named: "kara")!)
    var addTimer = Timer()
    var timerCount = 0
    //テンキー用
    var tenkey:[[String]] = [[("1"),("2"),("3")],[("4"),("5"),("6")],[("7"),("8"),("9")]]
    var inputNum:String = ""
    var change:String = ""
    var warning:String = ""
    var calculation:Int = 0
    //年齢層用
    var generation:String = ""
    let genArray : [String] = ["12歳以下男性","12歳以下女性","13-19歳男性","13-19歳女性","20-29歳男性","20-29歳女性","30-49歳男性","30-49歳女性","50歳以上男性","50歳以上女性"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 1024,height: 768))
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)

        //クラスをインスタンス化
        let button = MakeButton()
        let label = MakeLabel()
        //集計操作
        let realm = try! Realm()
        let obj = realm.objects(guestData.self).last
        let dish = obj!.dish
        let dishFee = String(formatterMake().string(from: dish*100 as NSNumber)!)
        
        let scrollView = UIScrollView()
        //縦スクロールのみにする記述
        let scrollFrame = CGRect(x: 30, y: 50, width: view.frame.width/3, height: 640)
        scrollView.frame = scrollFrame
        //ここのhightはスクロール出来る上限
        //scrollView.contentSizeのheightはscrollFrameのheightより大きい必要がある。
        scrollView.contentSize = CGSize(width:self.view.frame.width/3, height: 770)
  
        scrollView.layer.borderWidth = 1.5
        scrollView.layer.borderColor = UIColor.black.cgColor
        scrollView.backgroundColor = UIColor.clear

        // スクロールの跳ね返り無し
        scrollView.bounces = false
        //スクロール位置の表示
        //scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)

        scrollView.addSubview(label.make(x:20,y:15,width:300,height:20,back:UIColor.clear,_text:"うまいすしを、精一杯。", _fontSize:25))
        scrollView.addSubview(label.make(x:20,y:35,width:300,height:50,back:UIColor.clear,_text:"スシロー",_fontSize:45))
        scrollView.addSubview(label.make(x:20,y:95,width:300,height:25,back:UIColor.clear,_text:"ホール・キッチンスタッフ募集中!!",_fontSize:35))
        scrollView.addSubview(label.make(x:20,y:130,width:300,height:25,back:UIColor.clear,_text:"詳しくはURLから",_fontSize:35))
        scrollView.addSubview(label.make(x:20,y:165,width:300,height:25,back:UIColor.clear,_text:"www.akindo-sushiro.co.jp/m",_fontSize:35))
        scrollView.addSubview(label.make(x:20,y:195,width:300,height:175,back:UIColor.clear,_borderWidth:1.5,_fontSize:35))
        scrollView.addSubview(label.make(x:70,y:210,width:200,height:40,back:UIColor.clear,_text:"アンケートに答えて\nお得なクーポンをゲット!",_fontSize:35))
       
        let qrc = makeQrcode()
        scrollView.addSubview(qrc.make(xv:30,yv:260,wv:100,hv:100,sum:"https://www.akindo-sushiro.co.jp"))
        scrollView.addSubview(label.make(x:130,y:260,width:185,height:35,back:UIColor.clear,_text:"QRからアンケートサイトにアクセス\n本レシートの招待番号を入力して下さい",_fontSize:10))
        
        let text = "www.mysushiro.jp"
//        // attributedTextを作成する.
//        let attributedText = NSMutableAttributedString(string: text)
//        let range = NSMakeRange(0, text.characters.count)
//        // 下線を引くようの設定をする.
//        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)

//        // 対象のラベルを作成して、attributedTextを設定する.
//       let label2 = UILabel(frame: CGRect(x:CGFloat(145), y: CGFloat(290), width: CGFloat(185), height: CGFloat(45)))
//        label2.attributedText = attributedText
//        scrollView.addSubview(label2)
        
        scrollView.addSubview(label.make(x:110,y:330,width:185,height:35,back:UIColor.clear,_text:"回答期限:本日より7日以内",_fontSize:10))
         let obj2 = realm.objects(allData.self)
        scrollView.addSubview(label.make(x:20,y:380,width:185,height:35,back:UIColor.clear,_text:"レシート#   \(obj2.count)",_fontSize:15,_alignment:NSTextAlignment.left))
        
       //覚える
        let num = (Int(obj!.adultCount)!) + (Int(obj!.childCount)!)
        
        //オプショナル型→!でキャスト
        scrollView.addSubview(label.make(x:20,y:410,width:300,height:35,back:UIColor.clear,_text:"席:\(obj!.seatType)"+"        \(num)名",_fontSize:25,_alignment:NSTextAlignment.left))
        
        let date = Date()
        let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
         scrollView.addSubview(label.make(x:20,y:440,width:300,height:35,back:UIColor.clear,_text:"\(dateAndTime)",_fontSize:25,_alignment:NSTextAlignment.left))
         scrollView.addSubview(label.make(x:20,y:470,width:300,height:35,back:UIColor.clear,_text:"扱者:佐藤と東",_fontSize:15,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:20,y:500,width:300,height:35,back:UIColor.clear,_text:"100円皿 (\(obj!.dish)点 × @¥100) ¥\(obj!.dish*100)",_fontSize:25,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:20,y:530,width:300,height:35,back:UIColor.clear,_text:"----------------------------------------------",_fontSize:25,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:20,y:560,width:300,height:35,back:UIColor.clear,_text:"小計　　　   　　¥\(obj!.dish*100)",_fontSize:25,_alignment:NSTextAlignment.left))
        
        let num2 = Int(Double(obj!.dish*100)*0.1)
        scrollView.addSubview(label.make(x:20,y:590,width:300,height:35,back:UIColor.clear,_text:"外税(10%)　　　　¥\(num2)",_fontSize:25,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:20,y:630,width:300,height:35,back:UIColor.clear,_text:"==================================",_fontSize:25,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:20,y:670,width:300,height:35,back:UIColor.clear,_text:"合計(\(obj!.dish))点　　　　¥\(obj!.dish*110)",_fontSize:25,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:20,y:700,width:300,height:35,back:UIColor.clear,_text:"お預り　　　　　　　　　　　　¥\(inputNum)",_fontSize:25,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:20,y:730,width:300,height:35,back:UIColor.clear,_text:"お釣　　　　　　　　　　　　　¥\(change)",_fontSize:25,_alignment:NSTextAlignment.left))

        //ラベル作成 //計算
        self.view.addSubview(label.make(x: 400, y: 29, width:50, height:20,back:UIColor.clear,_text:"預かり", _fontSize:10))
        self.view.addSubview(label.make(x: 400, y: 129, width:50, height:20,back:UIColor.clear,_text:"会計", _fontSize:10))
        self.view.addSubview(label.make(x: 400, y: 229, width:50, height:20,back:UIColor.clear,_text:"お釣り", _fontSize:10))
        self.view.addSubview(label.make(x: 400, y: 50, width:270, height:60,back:UIColor.clear,_borderWidth:1.5,_cornerRadius:6,_text:"¥\(inputNum)", _fontSize:50))
        self.view.addSubview(label.make(x: 400, y: 150, width:270, height:60,back:UIColor.clear,_borderWidth:1.5,_cornerRadius:6,_text:"¥\(dishFee)", _fontSize:50))
        self.view.addSubview(label.make(x: 400, y: 250, width:270, height:60,back:UIColor.clear,_borderWidth:1.5,_cornerRadius:6,_text:"¥\(change)", _fontSize:50))
        self.view.addSubview(label.make(x: 600, y: 29, width:50, height:20,back:UIColor.clear,_text:"\(warning)", _fontSize:10))
        //ボタン作成
        self.view.addSubview(button.make(x:30,y:700,width:100,height:50,back:UIColor.white,tag:20, _borderWidth:1.5,_cornerRadius:6,_text:"戻る", _fontSize:50))
        self.view.addSubview(button.make(x:750,y:650,width:200,height:80,back:UIColor.white,tag:21, _borderWidth:1.5,_cornerRadius:6,_text:"ENTER", _fontSize:50))
        
        //テンキー作成
        for i in 1...3{
            for j in 1...3{
                self.view.addSubview(button.make(x:CGFloat(300+j*100) ,y:CGFloat(250+i*100),width:70,height:70,back:UIColor.white,tag:Int(tenkey[i-1][j-1])!,_borderWidth:1.5,_cornerRadius:6, _text:tenkey[i-1][j-1], _fontSize:50))
            }
        }
        self.view.addSubview(button.make(x:400,y:650,width:180,height:70,back:UIColor.white,tag:10, _borderWidth:1.5,_cornerRadius:6, _text:"0", _fontSize:50))
        self.view.addSubview(button.make(x:600,y:650,width:70,height:70,back:UIColor.white,tag:22, _borderWidth:1.5,_cornerRadius:6, _text:"〆", _fontSize:50))
        //終わり
        //年齢層
        let gene:[UIButton] = [button.make(x:750,y:50,width:100,height:100,back:UIColor.white,tag:30, _borderWidth:1.5,_cornerRadius:6,_text:"12", _fontSize:50),
                               button.make(x:850,y:50,width:100,height:100,back:UIColor.white,tag:31, _borderWidth:1.5,_cornerRadius:6,_text:"12", _fontSize:50),
                               button.make(x:750,y:150,width:100,height:100,back:UIColor.white,tag:32, _borderWidth:1.5,_cornerRadius:6,_text:"19", _fontSize:50),
                               button.make(x:850,y:150,width:100,height:100,back:UIColor.white,tag:33, _borderWidth:1.5,_cornerRadius:6,_text:"19", _fontSize:50),
                               button.make(x:750,y:250,width:100,height:100,back:UIColor.white,tag:34, _borderWidth:1.5,_cornerRadius:6,_text:"29", _fontSize:50),
                               button.make(x:850,y:250,width:100,height:100,back:UIColor.white,tag:35, _borderWidth:1.5,_cornerRadius:6,_text:"29", _fontSize:50),
                               button.make(x:750,y:350,width:100,height:100,back:UIColor.white,tag:36, _borderWidth:1.5,_cornerRadius:6,_text:"49", _fontSize:50),
                               button.make(x:850,y:350,width:100,height:100,back:UIColor.white,tag:37, _borderWidth:1.5,_cornerRadius:6,_text:"49", _fontSize:50),
                               button.make(x:750,y:450,width:100,height:100,back:UIColor.white,tag:38, _borderWidth:1.5,_cornerRadius:6,_text:"50", _fontSize:50),
                               button.make(x:850,y:450,width:100,height:100,back:UIColor.white,tag:39, _borderWidth:1.5,_cornerRadius:6,_text:"50", _fontSize:50)]
        
        //年齢層年齢層マスク
        if appDelegate.geneMaskFlag != 100 {
            if appDelegate.geneMaskFlag % 2 == 0{
                self.view.addSubview(label.make(x:750 ,y:CGFloat(50 + ((appDelegate.geneMaskFlag - 30) * 50)),width:100,height:100,back:UIColor.black,_cornerRadius:6,_alpha:0.3,_fontSize:50))
            }else{
                self.view.addSubview(label.make(x:850 ,y:CGFloat(50 + ((appDelegate.geneMaskFlag - 31) * 50)),width:100,height:100,back:UIColor.black,_cornerRadius:6,_alpha:0.3,_fontSize:50))
            }
        }
        for i in 0...9{
            if i % 2 == 0 {
                gene[i].backgroundColor = UIColor(red:0.10, green:0.10, blue:1, alpha:0.5)
            }else{
                gene[i].backgroundColor = UIColor(red:0.96, green:0.25, blue:0.15, alpha:0.5)
            }
            self.view.addSubview(gene[i])
        }
        
        for i in 0...9{
            if i % 2 == 0 {
                gene[i].backgroundColor = UIColor(red:0.10, green:0.10, blue:1, alpha:0.5)
            }else{
                gene[i].backgroundColor = UIColor(red:0.96, green:0.25, blue:0.15, alpha:0.5)
            }
            self.view.addSubview(gene[i])
        }
        let geneAns = button.make(x:750,y:570,width:200,height:60,back:UIColor.white,tag:22,_borderWidth:1.5,_cornerRadius:6, _text:"\(generation)", _fontSize:50)
        geneAns.titleLabel?.font = UIFont(name: "Bold",size: CGFloat(25))
        self.view.addSubview(geneAns)
        //年齢層終わり
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }
    
    //テンキー用メソッド
    func tenkeyHandle(inputNum:String) -> String{
        var input = inputNum
        calculation = Int(input.replacingOccurrences(of: ",", with: ""))!
        if input.first == "0"{input = String(input.dropFirst())}
        if input.count >= 7 {
            warning = "これ以上入力できません"
            viewDidLoad()
            return input
        }else{
            warning = ""
            viewDidLoad()
            //if input.count == 4 {input = inputNum + ","}
            return input
        }
    }
    
    //formatterメソッド
    func formatterMake() -> NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter
    }
    
    //ボタンイベント
    @objc func selection(sender: UIButton){
        let view = viewSetting()
        if sender.tag <= 10 {
            k = sender.tag
        }
        if sender.tag >= 30 && sender.tag < 40{
            l = sender.tag
        }
        switch sender.tag{
         case k://tenkey
                       if inputNum.count <= 7{
                           if k == 10 {
                               inputNum += "0"
                           }else{
                               inputNum += "\(k)"
                           }
                           let value = Int(inputNum.replacingOccurrences(of: ",", with: ""))!
                           inputNum = String(formatterMake().string(from: value as NSNumber)!)
                       }
                       inputNum = tenkeyHandle(inputNum: inputNum)
                       audioPlayerInstance.play()
        case 20://戻るボタン
            self.present(view.viewSet(view: ViewController(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        case 21://Enter
            if inputNum == ""{break}
            let value = Int(inputNum.replacingOccurrences(of: ",", with: ""))! - (appDelegate.dishSum * 110)
            if value < 0 {
                let ngalert = UIAlertController(title: "再入力してください", message: "", preferredStyle: .alert)
                ngalert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
                // アラート表示
                self.present(ngalert, animated: true, completion: {
                    // アラートを閉じる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        ngalert.dismiss(animated: true, completion: nil)
                    })
                })
                inputNum = ""
                viewDidLoad()
                audioPlayerInstance.play()
                break
            }
            if generation == "" {
                let ngalert = UIAlertController(title: "未入力があります", message: "", preferredStyle: .alert)
                ngalert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
                // アラート表示
                self.present(ngalert, animated: true, completion: {
                    // アラートを閉じる
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        ngalert.dismiss(animated: true, completion: nil)
                    })
                })
                break
            }
            change = String(formatterMake().string(from: value as NSNumber)!)
            viewDidLoad()
            appDelegate.dishSum = 0
            appDelegate.choise = 0
            appDelegate.tagFlag2 = 0
            //realm書き込み
            let date = Date()
            let dateAndTime = date.formattedDateWith(style: .time)
            let realm = try! Realm()
            let obj = realm.objects(guestData.self).last
            try! realm.write {
                obj?.outTime = dateAndTime
            }
            try! realm.write {
                realm.add(appSetting())
            }
            let saveObj = realm.objects(appSetting.self).last
            try! realm.write {
                saveObj?.touchVolume = appDelegate.touchVolume
                saveObj?.movieVolume = appDelegate.movieVolume
                saveObj?.volumeM = appDelegate.volumeM
                saveObj?.volumeMstatus = appDelegate.volumeMstatus
                saveObj?.volumeVstatus = appDelegate.volumeVstatus
                saveObj?.soundNum = appDelegate.soundNum
                saveObj?.movieNum = appDelegate.movieNum
                saveObj?.pickerView1Ini = appDelegate.pickerView1Ini
                saveObj?.pickerView2Ini = appDelegate.pickerView2Ini
            }
            let allObj = realm.objects(allData.self).last
            try! realm.write{
                allObj?.inTime = obj!.inTime
                allObj?.outTime = obj!.outTime
                allObj?.adultCount = obj!.adultCount
                allObj?.childCount = obj!.childCount
                allObj?.dish = obj!.dish
                allObj?.generation = generation
                allObj?.seatNum = obj!.seatNum
                allObj?.seatType = obj!.seatType
            }
            appDelegate.geneMaskFlag = 100
            appDelegate.history = []
            audioPlayerInstance.play()
            //遅延
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.present(view.viewSet(view: Ticket(), anime: .flipHorizontal), animated: false, completion: nil)
            }
        case 22:
                       //✗
                       inputNum = String(inputNum.dropLast())
                       if inputNum == "" {
                           viewDidLoad()
                           audioPlayerInstance.play()
                           break
                       }
                       let value = Int(inputNum.replacingOccurrences(of: ",", with: ""))!
                       inputNum = String(formatterMake().string(from: value as NSNumber)!)
                       viewDidLoad()
                       audioPlayerInstance.play()
        //年齢層
        case l:
            generation = genArray[l - 30]
            appDelegate.geneMaskFlag = sender.tag
            viewDidLoad()
            audioPlayerInstance.play()
            //年齢層終わり
        default:break
        }
    }
}
