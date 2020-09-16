import UIKit
import AVFoundation
import AVKit
import Foundation
import UserNotifications // 
import RealmSwift


//時間作成
extension Date {
    enum FormattedStyle {
        case longDate
        case longDateAndTime
        case shortDate
        case shortDateAndTime
        case time
    }
    func format(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    var formattedWeekday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let symbol = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: self) - 1]
        switch symbol {
        case    "Sunday": return "日"
        case    "Monday": return "月"
        case   "Tuesday": return "火"
        case "Wednesday": return "水"
        case  "Thursday": return "木"
        case    "Friday": return "金"
        case  "Saturday": return "土"
        default: assertionFailure("error"); return ""
        }
    }
    func formattedDateWith(style: FormattedStyle) -> String {
        switch style {
        case .longDate:
            return format(with: "yyyy年M月d日\(formattedWeekday)")
        case .longDateAndTime:
            return format(with: "yyyy年M月d日(\(formattedWeekday)) H:mm")
        case .shortDateAndTime:
            return format(with: "M月d日\(formattedWeekday)曜日 H:mm")
        case .shortDate:
            return format(with: "M 月  d 日   \(formattedWeekday)  曜日")
        case .time:
            return format(with: "H:mm")
        }
    }
}


//realm作成 guest
class guestData:Object{
    @objc dynamic var seatNum = ""
    @objc dynamic var inTime = ""
    @objc dynamic var outTime = ""
    @objc dynamic var adultCount = ""
    @objc dynamic var childCount = ""
    @objc dynamic var seatType = ""
    @objc dynamic var dish = 0
}

//realm作成 設定初期値
class appSetting:Object{
    @objc dynamic var touchVolume: Float = 0.5
    @objc dynamic var movieVolume: Float = 0.5
    @objc dynamic var qrStatus: String = "qr"
    @objc dynamic var qrString: String = ""
    @objc dynamic var volumeM: Float = 0.5
    @objc dynamic var volumeV: Float = 0.5
    @objc dynamic var volumeMstatus: String = "on"
    @objc dynamic var volumeVstatus: String = "on"
    @objc dynamic var soundNum: String = "button01a"
    @objc dynamic var movieNum: String = "movie01"
    @objc dynamic var pickerView1Ini: Int = 0
    @objc dynamic var pickerView2Ini: Int = 0
}

//realm作成　全てのデータ
class allData:Object{
    @objc dynamic var seatNum = ""
    @objc dynamic var inTime = ""
    @objc dynamic var outTime = ""
    @objc dynamic var adultCount = ""
    @objc dynamic var childCount = ""
    @objc dynamic var seatType = ""
    @objc dynamic var dish = 0
    @objc dynamic var generation = ""
}

//ラベル作成class
class makeLabel:UILabel{
    func make(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,o:Int,o1:Int,o2:Double,ic:String)->UILabel{
        let label = UILabel(frame: CGRect(x:CGFloat(xv), y: CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.adjustsFontSizeToFitWidth = true
        if o == 2{
            label.layer.borderWidth = 1.5
            label.layer.borderColor = UIColor.black.cgColor
        }
        label.font = label.font.withSize(CGFloat(f))
        label.textAlignment = NSTextAlignment.center
        if ic != ""{
            label.text = ic
        }
        label.numberOfLines = 0
        label.layer.cornerRadius = 3.0
        if o1 == 0{
            label.backgroundColor = UIColor.clear
        }else if o1 == 1{
            label.backgroundColor = UIColor.white
        }else if o1 == 2{
            label.backgroundColor = UIColor.black
        }else{
            label.backgroundColor = UIColor.yellow
        }
        if o2 != 0{
            label.alpha = CGFloat(o2)
        }
        return(label)
    }
    func make(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,o:Int,o1:Int,o2:Double,ic:String,al:String)->UILabel{
        let label = UILabel(frame: CGRect(x:CGFloat(xv), y: CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
        if al=="c"{
            label.textAlignment = NSTextAlignment.center
        }else{
            label.textAlignment = NSTextAlignment.left
        }
        label.adjustsFontSizeToFitWidth = true
        if o == 2{
            label.layer.borderWidth = 1.5
            label.layer.borderColor = UIColor.black.cgColor
        }
        label.font = label.font.withSize(CGFloat(f))
        if ic != ""{
            label.text = ic
        }
        label.numberOfLines = 0
        label.layer.cornerRadius = 3.0
        if o1 == 0{
            label.backgroundColor = UIColor.clear
        }else if o1 == 1{
            label.backgroundColor = UIColor.white
        }else if o1 == 2{
            label.backgroundColor = UIColor.black
        }else{
            label.backgroundColor = UIColor.yellow
        }
        if o2 != 0{
            label.alpha = CGFloat(o2)
        }
        return(label)
    }
}

//ボタン作成class(イメージ有り)
class makeButton:UIButton,selection{
    @objc func selection(sender: UIButton) {}
    
    
    func make(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,b:String,c:Int,d:Int,e:Int,m:Int)->UIButton{
        let button: UIButton = UIButton(frame: CGRect(x:CGFloat(xv), y:CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
        button.titleLabel?.adjustsFontSizeToFitWidth = true  //文字列をボタンに収める設定
        if e == 1{
            let picture = UIImage(named: "\(b).png")
            button.setImage(picture, for: .normal)
        }else if e == 2{
            let picture = UIImage(named: "\(b).jpeg")
            button.setImage(picture, for: .normal)
        }
        if d == 0{
            button.layer.borderColor = UIColor.clear.cgColor
        } else if d == 1{
            button.layer.borderColor = UIColor.black.cgColor
        }else{
            button.layer.borderColor = UIColor.white.cgColor
        }
        button.layer.borderWidth = 1
        if m == 0{
            button.backgroundColor = UIColor.clear
        }else{
            button.backgroundColor = UIColor.white
        }
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitle("\(b)", for: .normal)
        button.tag = c
        button.layer.cornerRadius = 6
        button.titleLabel?.font =  UIFont.systemFont(ofSize: CGFloat(f))
        button.addTarget(self, action: #selector(selection(sender:)), for: .touchUpInside)
        return(button)
    }
    //m:backgrand,e:picture,e:border
    func make(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,b:String,c:Int,t:Int) -> UIButton{
        let button: UIButton = UIButton(frame: CGRect(x:CGFloat(xv), y:CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
        let picture = UIImage(named: "\(b).jpeg")
        button.layer.cornerRadius = 3.0
        button.tag = c
        button.setTitle("\(b)", for: .normal)
        if t == 0{
            button.backgroundColor = UIColor.clear
            button.setImage(picture, for: .normal)
        }else{
            button.backgroundColor = UIColor.white
            button.layer.borderColor = UIColor.brown.cgColor
            button.layer.borderWidth = 1.5
            button.setTitleColor(UIColor.red, for: .normal)
            button.titleLabel?.numberOfLines = 2//0:無限改行,2:2行表示
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 50)
        }
        button.addTarget(self, action: #selector(selection(sender:)), for: .touchUpInside)
        return(button)
    }
}

//スライダー作成class
class SliderClass: NSObject {
    var title: String
    var subtitle: String
    var sliderMinimum: Float
    var sliderMaximum: Float
    
    init(title: String, subtitle: String, sliderMinimum: Float, sliderMaximum: Float) {
        self.title = "a"
        self.subtitle = "b"
        self.sliderMinimum = 10
        self.sliderMaximum = 30
    }
}

//バーコード作成class
class makeBarcord:UIImageView{
    func make(string: String) -> UIImageView? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        guard let output = filter.outputImage else {
            return nil
        }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        let uiImage = UIImage(cgImage: cgImage, scale: 2.0, orientation: UIImage.Orientation.up)
        // 作成したバーコードを表示
        let barImageView = UIImageView(frame: CGRect(x:CGFloat(100), y: CGFloat(250), width: CGFloat(150), height: CGFloat(150)))
        barImageView.contentMode = .scaleAspectFit
        barImageView.image = uiImage
        return(barImageView)
    }
}

class makeQrcode:UIImageView{
  func make(xv:Int,yv:Int,wv:Int,hv:Int,sum:String)->UIImageView{
    let qrImageView = UIImageView(frame: CGRect(x:CGFloat(xv), y: CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
    let str = sum
    let data = str.data(using: String.Encoding.utf8)!
    let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])!
    let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
    let qrImage = qr.outputImage!.transformed(by: sizeTransform)
    let context = CIContext()
    let cgImage = context.createCGImage(qrImage, from: qrImage.extent)
    let uiImage = UIImage(cgImage: cgImage!)
    // 作成したQRコードを表示
    qrImageView.contentMode = .scaleAspectFit
    qrImageView.image = uiImage
    return(qrImageView)
  }
}

//サウンド作成class
class makeSound:AVAudioPlayer{
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    func make()->AVAudioPlayer{
        var audioPlayerInstance : AVAudioPlayer! = nil
        let soundFilePath = Bundle.main.path(forResource: "button01a", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        audioPlayerInstance.volume = appDelegate.volumeM
        return(audioPlayerInstance)
    }
}

//stepper
class makeStepper:UIStepper{
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    func make(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,o:Int,o1:Int,o2:Double,ic:Int)->UIStepper{
        let stepper = UIStepper(frame: CGRect(x:CGFloat(xv), y: CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
        // 最小値, 最大値, 規定値の設定をする.
        stepper.minimumValue = 0
        stepper.maximumValue = 59
        stepper.value = 1
        stepper.layer.cornerRadius = 3.0
        stepper.backgroundColor = UIColor.clear
        // ボタンを押した際に動く値の.を設定する.
        stepper.stepValue = 1
        return(stepper)
    }
}

//viewの設定
class viewSetting{
    func viewSet(view:UIViewController,anime:UIModalTransitionStyle) -> UIViewController{
        let SViewController: UIViewController = view
        //アニメーションを設定する.
        SViewController.modalTransitionStyle = anime
        //Viewの移動する.
        SViewController.modalPresentationStyle = .fullScreen
        return SViewController
    }
}

//ボタンイベントのための抽象メソッド
protocol selection {
    func selection(sender: UIButton)
}

////ジェスチャー作成class
//class makeGess:UISwipeGestureRecognizer{
//    func make()->UISwipeGestureRecognizer{
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(Menu.leftSwipeView(sender:)))  //Swift3
//        // レフトスワイプのみ反応するようにする
//        leftSwipe.direction = .left
//        return(leftSwipe)
//    }
//}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    var choise: Int = 0//メニュー選択
    var viewType: String = "アカウント"
    var history: [(name:String,num:Int)] = []//からの配列
    var touchVolume: Float = 0.5
    var movieVolume: Float = 0.5
    var scImage: UIImage?
    var qrStatus: String = "qr"
    var qrString: String = ""
    var volumeM: Float = 0.5
    var volumeV: Float = 0.5
    var volumeMstatus: String = "on"
    var volumeVstatus: String = "on"
    var soundNum: String = "button01a"
    var movieNum: String = "movie01"
    var pickerView1Ini: Int = 0
    var pickerView2Ini: Int = 0
    var maskFlag: Int = 100
    var maskFlag2: Int = 100
    var maskFlag3: Int = 100
    var geneMaskFlag: Int = 100
    var dishSum = 0
    var tagFlag2 = 0
    var counter = 0  //カウント用変数
    
    //メニュー関係
    var countType: [(k:Int,now:String)] = [
        (0,""),
        (0,""),
        (0,"")]
    var box: [(name: String, qty: Int ,view: String)] = [
        ("",0,"kara.png"),
        ("",0,"kara.png"),
        ("",0,"kara.png")]
    var tag1: [String] = ["セットメニュー・期間限定","どか盛りフェア","にぎり(おすすめ)","にぎり①","にぎり②","ぐんかん・巻物・いなり","サイドメニュー","デザート","ドリンク・アルコール" ]
    var tag2: [[String]] = [[("ページ1")],//tag0 セットメニュー・季節限定
        [("ページ1"), ("ページ2")],//tag1 どか盛り
        [("ページ1")],//tag2 にぎりおすすめ
        [("まぐろ"), ("サーモン"),("えび"),("いか・たこ"),("光物"),("貝")],//tag3 にぎり①
        [("うなぎ・穴子"), ("その他1"),("その他2")],//tag4 にぎり②
        [("ぐんかん1"), ("ぐんかん2"),("巻物・いなり")],//ぐんかん・巻物・いなり
        [("麺"), ("味噌汁"),("揚げ物"),("その他")],//サイドメニュー
        [("デザート1"), ("デザート2"),("デザート3")],//デザート
        [("アルコール"), ("ソフトドリンク")],//ドリンク・アルコール
    ]
    
    let data: [[[(name: String, pic: String)]]] =
        [
            [[(name:"蟹の豪華盛り",pic:"001"), (name:"生タコ梅キュウ",pic:"002"),(name:"よだれ鶏にぎり",pic:"003"),(name:"匠の本格海老マヨ",pic:"004"),(name:"すりながしカレーうどん",pic:"005")]],
            //
            [[(name:"どか盛りホタテ",pic:"006"), (name:"どか盛りいくらサーモン",pic:"007"),(name:"どか盛り甘えび",pic:"008"),(name:"どか盛りびんとろ",pic:"009"),(name:"ローストビーフマウンテン",pic:"010"),(name:"Wかつお",pic:"011")],[(name:"どか盛りねぎとろ",pic:"012")]],
            //おすすめ握り
            [[(name:"生ほっき貝",pic:"013"), (name:"生本まぐろ",pic:"014"),(name:"生本まぐろ大とろ",pic:"015"),(name:"特大天然車えび",pic:"016"),(name:"特大ジャンボほたて",pic:"017")]],
            //握り1
            [[(name:"まぐろ",pic:"018"), (name:"漬けまぐろ",pic:"019"),(name:"びんとろ",pic:"020"),(name:"中とろ",pic:"021"),(name:"大トロ",pic:"022")],[(name:"サーモン",pic:"023"),    (name:"オニオンサーモン",pic:"024"),(name:"焼サーモン",pic:"025"),(name:"おろしサーモン",pic:"026"),(name:"サーモンモッツアレラ",pic:"027"),(name:"生サーモン",pic:"028")],
             [(name:"赤えび",pic:"029"),(name:"えび",pic:"030"),(name:"生えび",pic:"031"),(name:"えびチーズ",pic:"032"),(name:"えびバジルチーズ",pic:"033"),                           (name:"えびアボカド",pic:"034")],
             [(name:"紋甲いか",pic:"035"), (name:"いか",pic:"036"),(name:"いか塩レモン",pic:"037"),(name:"こういか",pic:"038"),(name:"たこ",pic:"039"),(name:"生たこ",pic:"040")],
             [(name:"こはだ",pic:"041"), (name:"〆さば",pic:"042"),(name:"〆さば(ゴマねぎ)",pic:"043"),(name:"焼き鯖",pic:"044"),(name:"〆イワシ",pic:"045")],
             [(name:"つぶ貝",pic:"046"), (name:"赤貝",pic:"047"),(name:"ほっき貝",pic:"048"),(name:"ほたて貝柱",pic:"049"),(name:"黒みる貝",pic:"050"),(name:"白とり貝",pic:"051")]],
            //握り2
            [[(name:"うなぎ",pic:"052"), (name:"穴子",pic:"053"),(name:"炙り穴子",pic:"054"),(name:"一本穴子",pic:"055")],
             [(name:"生ハム",pic:"056"), (name:"生ハムモッツアレラ",pic:"057"),(name:"牛塩カルビ",pic:"058"),(name:"和牛さし",pic:"059")],
             [(name:"たまご",pic:"060"), (name:"キス天ぷら",pic:"061"),(name:"なす漬物",pic:"062")]],
            //ぐんかん・巻物・いなり
            [[(name:"まぐろたたき",pic:"063"), (name:"山かけ",pic:"064"),(name:"まぐろユッケ",pic:"065"),(name:"イカおくら",pic:"066"),(name:"えびマヨ",pic:"067"),(name:"カニみそ",pic:"068")],
             [(name:"いくら",pic:"069"),(name:"コーンマヨ",pic:"070"),(name:"ツナ",pic:"071")],
             [(name:"鉄火巻き",pic:"072"), (name:"かっぱ巻き",pic:"073"),(name:"かんぴょう巻き",pic:"074"),(name:"うなきゅう",pic:"075"), (name:"季節のいなり",pic:"076")]],
            //サイドメニュー
            [[(name:"コク旨まぐろ醤油ラーメン",pic:"077"), (name:"鯛だし塩ラーメン",pic:"078"),(name:"濃厚えび味噌ワンタンメン",pic:"079"),(name:"あさりと筍のおうどん",pic:"080"),(name:"かけうどん",pic:"081"),(name:"エビ天うどん",pic:"082")],
             [(name:"あおさと海苔の赤だし",pic:"083"),(name:"あさりの赤だし",pic:"084"),(name:"魚のアラの赤だし",pic:"085"),(name:"あおさと海苔の味噌汁",pic:"086"),(name:"あさりの味噌汁",pic:"087")],
             [(name:"なんこつ唐揚げ",pic:"088"), (name:"フライドポテト",pic:"089"),(name:"たこの唐揚げ",pic:"090"),(name:"天ぷら盛り合わせ",pic:"091"),(name:"かぼちゃの天ぷら",pic:"092"),(name:"鶏モモの唐揚げ",pic:"093")],
             [(name:"枝豆",pic:"094"), (name:"しらすとパンチェッタのサラダ",pic:"095"),(name:"茶碗蒸し",pic:"096"),(name:"だし巻き卵",pic:"097")]],
            //デザート
            [[(name:"練乳いちごパフェ",pic:"098"), (name:"チョコムースバナナパフェ",pic:"099"),(name:"カタラーナアイスブリュレ",pic:"100"),(name:"北海道ミルクレープメルバ",pic:"101"),(name:"わらびもち",pic:"102"),(name:"大学いも",pic:"103")],
             [(name:"ショコラケーキリッチ",pic:"104"),(name:"ニューヨークイチゴケーキ",pic:"105"),(name:"北海道ミルクレープ",pic:"106"),(name:"とろっとプリン",pic:"107"),(name:"北海道バニラアイス",pic:"108"),(name:"ベルギーショコラアイス",pic:"109")],
             [(name:"フローズンマンゴー",pic:"110"),(name:"懐かしのメロンシャーベット",pic:"111")]],
            //ソフトドリンク・アルコール
            [[(name:"生ビール",pic:"112"), (name:"角ハイボール",pic:"113"),(name:"レモンサワー",pic:"114"),(name:"大吟醸",pic:"115"),(name:"生貯蔵酒",pic:"116"),(name:"ノンアルコールビール",pic:"117")],
             [(name:"りんごジュース",pic:"118"),(name:"アイスコーヒー",pic:"119"),(name:"アイスカフェラテ",pic:"120"),(name:"ホットコーヒー",pic:"121"),(name:"ホットカフェラテ",pic:"122")]],
    ]

    //商品選択後
    func st(sn:String,pn:String){
        if counter < 3{
            if box[0].name == ""{
                counter = 0
                box[counter].name = sn
                box[counter].qty = 1
                box[counter].view = pn
            }else if  box[1].name == ""{
                counter = 1
                box[counter].name = sn
                box[counter].qty = 1
                box[counter].view = pn
            }else if  box[2].name == ""{
                counter = 2
                box[counter].name = sn
                box[counter].qty = 1
                box[counter].view = pn
            }
            countType[0].now = "off"
            countType[1].now = "off"
            countType[2].now = "off"
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 起動直後に遷移する画面をRootViewControllerに指定する
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = Ticket()
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
