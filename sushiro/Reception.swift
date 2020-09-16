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
        ////audioPlayerInstance.prepareToPlay()
        // audioPlayerInstance.volume = appDelegate.volume
        //クラスをインスタンス化
        let button = makeButton()//m:backgrand,e:picture,e:border
        let label = makeLabel()//o:border,o1:backgrand,o2:0でalpha無効,ic:300でむテキスト無効
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

        scrollView.addSubview(label.make(xv:20,yv:15,wv:300,hv:20,f:25,o:0,o1:0,o2:0.0,ic:"うまいすしを、精一杯。"))
        scrollView.addSubview(label.make(xv:20,yv:35,wv:300,hv:50,f:45,o:0,o1:0,o2:0.0,ic:"スシロー"))
        scrollView.addSubview(label.make(xv:20,yv:95,wv:300,hv:25,f:35,o:0,o1:0,o2:0.0,ic:"ホール・キッチンスタッフ募集中!!"))
        scrollView.addSubview(label.make(xv:20,yv:130,wv:300,hv:25,f:35,o:0,o1:0,o2:0.0,ic:"詳しくはURLから"))
        scrollView.addSubview(label.make(xv:20,yv:165,wv:300,hv:25,f:35,o:0,o1:0,o2:0.0,ic:"www.akindo-sushiro.co.jp/m"))
        
     
        scrollView.addSubview(label.make(xv:20,yv:195,wv:300,hv:175,f:35,o:2,o1:0,o2:0.0,ic:""))
        scrollView.addSubview(label.make(xv:70,yv:210,wv:200,hv:40,f:35,o:2,o1:0,o2:0.0,ic:"アンケートに答えて\nお得なクーポンをゲット!"))
        let qrc = makeQrcode()
        scrollView.addSubview(qrc.make(xv:30,yv:260,wv:100,hv:100,sum:"https://www.akindo-sushiro.co.jp"))
        scrollView.addSubview(label.make(xv:130,yv:260,wv:185,hv:35,f:10,o:0,o1:0,o2:0.0,ic:"QRからアンケートサイトにアクセス\n本レシートの招待番号を入力して下さい"))
        
        let text = "www.mysushiro.jp"
        
//        // attributedTextを作成する.
//        let attributedText = NSMutableAttributedString(string: text)
//        let range = NSMakeRange(0, text.characters.count)
//
//        // 下線を引くようの設定をする.
//        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
//
//        // 対象のラベルを作成して、attributedTextを設定する.
//       let label2 = UILabel(frame: CGRect(x:CGFloat(145), y: CGFloat(290), width: CGFloat(185), height: CGFloat(45)))
//        label2.attributedText = attributedText
//        scrollView.addSubview(label2)
        
        scrollView.addSubview(label.make(xv:110,yv:330,wv:185,hv:35,f:10,o:0,o1:0,o2:0.0,ic:"回答期限:本日より7日以内"))
        
         let obj2 = realm.objects(allData.self)
        scrollView.addSubview(label.make(xv:20,yv:380,wv:185,hv:35,f:15,o:0,o1:0,o2:0.0,ic:"レシート#   \(obj2.count)",al:"l"))
        
       //覚える
        let num = (Int(obj!.adultCount)!) + (Int(obj!.childCount)!)
        
        //オプショナル型→!でキャスト
        scrollView.addSubview(label.make(xv:20,yv:410,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"席:\(obj!.seatType)"+"        \(num)名",al:"l"))
        
        let date = Date()
        let dateAndTime = date.formattedDateWith(style: .longDateAndTime)
        scrollView.addSubview(label.make(xv:20,yv:440,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"\(dateAndTime)",al:"l"))
        scrollView.addSubview(label.make(xv:20,yv:470,wv:300,hv:35,f:15,o:0,o1:0,o2:0.0,ic:"扱者:佐藤と東",al:"l"))
        scrollView.addSubview(label.make(xv:20,yv:500,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"100円皿 (\(obj!.dish)点 × @¥100) ¥\(obj!.dish*100)",al:"l"))
        scrollView.addSubview(label.make(xv:20,yv:530,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"----------------------------------------------",al:"l"))
        scrollView.addSubview(label.make(xv:20,yv:560,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"小計　　　   　　¥\(obj!.dish*100)",al:"l"))
        
        let num2 = Int(Double(obj!.dish*100)*0.1)
        scrollView.addSubview(label.make(xv:20,yv:590,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"外税(10%)　　　　¥\(num2)",al:"l"))
        scrollView.addSubview(label.make(xv:20,yv:630,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"==================================",al:"l"))
        scrollView.addSubview(label.make(xv:20,yv:670,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"合計(\(obj!.dish))点　　　　¥\(obj!.dish*110)",al:"l"))
        scrollView.addSubview(label.make(xv:20,yv:700,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"お預り　　　　　　　　　　　　¥\(inputNum)",al:"l"))
        scrollView.addSubview(label.make(xv:20,yv:730,wv:300,hv:35,f:25,o:0,o1:0,o2:0.0,ic:"お釣　　　　　　　　　　　　　¥\(change)",al:"l"))
        
        


        //ラベル作成 //計算
        self.view.addSubview(label.make(xv: 400, yv: 29, wv: 50, hv: 20, f: 10, o: 0, o1: 0, o2: 0, ic: "預かり"))
        self.view.addSubview(label.make(xv: 400, yv: 129, wv: 50, hv: 20, f: 10, o: 0, o1: 0, o2: 0, ic: "会計"))
        self.view.addSubview(label.make(xv: 400, yv: 229, wv: 50, hv: 20, f: 10, o: 0, o1: 0, o2: 0, ic: "お釣り"))
        self.view.addSubview(label.make(xv: 400, yv: 50, wv: 270, hv: 60, f: 50, o: 2, o1: 0, o2: 0, ic: "¥\(inputNum)"))
        self.view.addSubview(label.make(xv: 400, yv: 150, wv: 270, hv: 60, f: 50, o: 2, o1: 0, o2: 0, ic: "¥\(dishFee)"))
        self.view.addSubview(label.make(xv: 400, yv: 250, wv: 270, hv: 60, f: 50, o: 2, o1: 0, o2: 0, ic: "¥\(change)"))
        self.view.addSubview(label.make(xv: 600, yv: 29, wv: 50, hv: 20, f: 10, o: 0, o1: 0, o2: 0, ic: "\(warning)"))
        //ボタン作成
        self.view.addSubview(button.make(xv:30,yv:700,wv:100,hv:50,f:50,b:"戻る",c:20,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:750,yv:650,wv:200,hv:80,f:50,b:"ENTER",c:21,d:1,e:0,m:1))
        //テンキー作成
        for i in 1...3{
            for j in 1...3{
                self.view.addSubview(button.make(xv:(300 + j * 100) ,yv:250 + i * 100,wv:70,hv:70,f:50,b:tenkey[i-1][j-1],c:Int(tenkey[i-1][j-1])!,d:1,e:0,m:1))
            }
        }
        self.view.addSubview(button.make(xv:400,yv:650,wv:180,hv:70,f:50,b:"0",c:10,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:600,yv:650,wv:70,hv:70,f:50,b:"✗",c:22,d:1,e:0,m:1))
        //終わり
        //年齢層
        let gene:[UIButton] = [button.make(xv:750,yv:50,wv:100,hv:100,f:50,b:"12",c:30,d:1,e:0,m:1),
                               button.make(xv:850,yv:50,wv:100,hv:100,f:50,b:"12",c:31,d:1,e:0,m:1),
                               button.make(xv:750,yv:150,wv:100,hv:100,f:50,b:"19",c:32,d:1,e:0,m:1),
                               button.make(xv:850,yv:150,wv:100,hv:100,f:50,b:"19",c:33,d:1,e:0,m:1),
                               button.make(xv:750,yv:250,wv:100,hv:100,f:50,b:"29",c:34,d:1,e:0,m:1),
                               button.make(xv:850,yv:250,wv:100,hv:100,f:50,b:"29",c:35,d:1,e:0,m:1),
                               button.make(xv:750,yv:350,wv:100,hv:100,f:50,b:"49",c:36,d:1,e:0,m:1),
                               button.make(xv:850,yv:350,wv:100,hv:100,f:50,b:"49",c:37,d:1,e:0,m:1),
                               button.make(xv:750,yv:450,wv:100,hv:100,f:50,b:"50",c:38,d:1,e:0,m:1),
                               button.make(xv:850,yv:450,wv:100,hv:100,f:50,b:"50",c:39,d:1,e:0,m:1)]
        
        //年齢層年齢層マスク
        if appDelegate.geneMaskFlag != 100 {
            if appDelegate.geneMaskFlag % 2 == 0{
                self.view.addSubview(label.make(xv:750 ,yv:50 + ((appDelegate.geneMaskFlag - 30) * 50),wv:100,hv:100,f:50,o:0,o1:2,o2:0.3, ic: ""))
            }else{
                self.view.addSubview(label.make(xv:850 ,yv:50 + ((appDelegate.geneMaskFlag - 31) * 50),wv:100,hv:100,f:50,o:0,o1:2,o2:0.3, ic: ""))
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
        let geneAns = button.make(xv:750,yv:570,wv:200,hv:60,f:50,b:"\(generation)",c:22,d:1,e:0,m:1)
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
