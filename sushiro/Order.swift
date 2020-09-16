
import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import Foundation
import RealmSwift
import CoreImage




//注文前画面クラス
class Order: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var myTabBar:UITabBar!
    let myInputImage = CIImage(image: UIImage(named: "order.jpeg")!)
    var myImageView: UIImageView!
    var selectView: UIView! = nil
    var image0: UIImageView!
    var count = 0
    var count2 = 0
    var i = 0
    var name = ""
    var label2: UILabel!
    var addTimer = Timer()
    var timerCount = 0
    
    //タイマー
    @objc func timerCall() {
        viewDidLoad()
        // タイマーを無効にする
        addTimer.invalidate()
    }

    //画像の設定
    func imageSetteng(picture:String){
        // 画像を設定する.
        let myInputImage = CIImage(image: UIImage(named: picture)!)
        // ImageViewを.定義する.
        var myImageView: UIImageView!
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: UIScreen.main.bounds)
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
    }
    
    //ボタン作成
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayerInstance.prepareToPlay()
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: UIScreen.main.bounds)
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
        
        //作成用メソッド
        //タグ作成
        func makeButtonOrderTag(xv:Int,yv:Int,wv:Int,hv:Int,b:String,c:Int){
            let button: UIButton = UIButton(frame: CGRect(x:CGFloat(xv), y:CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
            let picture = UIImage(named: "\(b).png")
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
            button.backgroundColor = UIColor.clear
            button.setTitle("\(b)", for: .normal)
            button.tag = c
            button.setImage(picture, for: .normal)
            button.layer.cornerRadius = 6
            button.addTarget(self, action: #selector(celection(sender:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
        //ボタン作成
        func makeButtonBeforeOrder(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,b:String,c:Int){
            let button: UIButton = UIButton(frame: CGRect(x:CGFloat(xv), y:CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
            button.backgroundColor = UIColor.white
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.5
            button.setTitle("\(b)", for: .normal)
            button.layer.cornerRadius = 6
            button.setTitleColor(UIColor.black, for: .normal)
            button.titleLabel?.numberOfLines = 2//0:無限改行,2:2行表示
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 25)
            button.tag = c
            //button.layer.position = CGPoint(x: self.view.bounds.width/2 , y:self.view.bounds.height-CGFloat(yh))
            button.addTarget(self, action: #selector(celection(sender:)), for: .touchUpInside)
            // ボタンを追加する.
            self.view.addSubview(button)
        }
        //商品増減
        func countButton(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,b:String,c:Int){
            let button: UIButton = UIButton(frame: CGRect(x:CGFloat(xv), y:CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
            let picture = UIImage(named: "button.jpeg")
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 0
            button.layer.cornerRadius = 3.0
            button.titleLabel?.numberOfLines = 2//0:無限改行,2:2行表示
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 45)
            button.tag = c
            button.setBackgroundImage(picture, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitle("\(b)", for: .normal)
            button.addTarget(self, action: #selector(celection(sender:)), for: .touchUpInside)
            self.view.addSubview(button)
        }
        //商品名用
        func nameButton(button:UIButton,num:Int) -> UIButton{
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1.5
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 35)
            button.setTitle("\(appDelegate.box[num].name)", for: .normal)
            button.titleLabel?.numberOfLines = 1//0:無限改行,2:2行表示
            button.setTitleColor(UIColor.black, for: UIControl.State.normal)
            button.backgroundColor = UIColor.clear
            button.tag = 13
            button.addTarget(self, action: #selector(celection(sender:)), for: .touchUpInside)
            return button
        }

        
        
        //数量用
        func countLabel(label:UILabel,num:Int) -> UILabel{
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 1.5
            label.font = label.font.withSize(CGFloat(50))
            label.textAlignment = NSTextAlignment.center
            if appDelegate.box[num].name  != ""{
                label.text = ("\(appDelegate.box[num].qty)")
            }
            label.numberOfLines = 0
            label.backgroundColor = UIColor.clear
            return label
        }
        //種類用
        func typeLabel(label:UILabel,num:String){
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 1.5
            label.font = label.font.withSize(CGFloat(50))
            label.textAlignment = NSTextAlignment.center
            label.text = (num)
            label.numberOfLines = 0
            label.backgroundColor = UIColor.clear
            self.view.addSubview(label)
        }
        //メソッド終わり
        
        //ボタン作成
        //種類作成
        for i in 0...2{
            let label = UILabel(frame: CGRect(x:CGFloat(50), y: CGFloat(280 + i * 60), width: CGFloat(60), height: CGFloat(60)))
            typeLabel(label: label,num: String(i+1))
        }
        //商品名作成
        for i in 0...2{
            let button = UIButton(frame: CGRect(x:CGFloat(110), y: CGFloat(280 + i * 60), width: CGFloat(200), height: CGFloat(60)))
            self.view.addSubview(nameButton(button: button,num:i))
        }
        //数量作成
        for i in 0...2{
            let label = UILabel(frame: CGRect(x:CGFloat(310), y: CGFloat(280 + i * 60), width: CGFloat(60), height: CGFloat(60)))
            self.view.addSubview(countLabel(label: label,num:i))
        }
        //タグ作成
        for i in 0...8{
            makeButtonOrderTag(xv: 5 + 80 * i, yv: 5, wv: 80, hv: 70, b: "tag\(i)", c: 16)
        }
        //上部ボタン作成
        let cate:[String] = ["まぐろ","サーモン","たこ・えび","貝","いか","光物"]
        for i in 0...5{
            makeButtonBeforeOrder(xv: 5 + i * 115, yv: 90, wv: 110, hv: 70, f: 20, b: cate[i], c: 17)
        }
        makeButtonBeforeOrder(xv:30,yv:700,wv:100,hv:50,f:20,b:"戻る",c:1)
        makeButtonBeforeOrder(xv:550,yv:210,wv:170,hv:100,f:20,b:"注文する",c:18)
        //+-ボタン作成
        for i in 0...2{
            if appDelegate.box[i].name != ""{
                countButton(xv:390,yv:280+i*60,wv:60,hv:50,f:20,b:"+",c:i*2+2)
                countButton(xv:460,yv:280+i*60,wv:60,hv:50,f:20,b:"−",c:i*2+3)
            }
        }
        //メッセージ（合計)
        let messageLabel = UILabel(frame: CGRect(x:CGFloat(190), y: CGFloat(460), width: CGFloat(120), height: CGFloat(60)))
        messageLabel.layer.borderColor = UIColor.black.cgColor
        messageLabel.layer.borderWidth = 1.5
        messageLabel.font = messageLabel.font.withSize(CGFloat(50))
        messageLabel.textAlignment = NSTextAlignment.center
        messageLabel.text = ("合計")
        messageLabel.numberOfLines = 0
        messageLabel.backgroundColor = UIColor.red
        self.view.addSubview(messageLabel)
        //数量用（合計)
        let sumLabel = UILabel(frame: CGRect(x:CGFloat(310), y: CGFloat(460), width: CGFloat(60), height: CGFloat(60)))
        _ = UILabel(frame: CGRect(x:CGFloat(310), y: CGFloat(460), width: CGFloat(60), height: CGFloat(60)))
        sumLabel.layer.borderColor = UIColor.black.cgColor
        sumLabel.layer.borderWidth = 1.5
        sumLabel.font = sumLabel.font.withSize(CGFloat(50))
        sumLabel.textAlignment = NSTextAlignment.center
        sumLabel.text = ("\(appDelegate.box[0].qty + appDelegate.box[1].qty + appDelegate.box[2].qty)")
        sumLabel.numberOfLines = 0
        sumLabel.backgroundColor = UIColor.clear
        self.view.addSubview(sumLabel)
    }
    
    //ボタンイベント処理
    @objc func celection(sender: UIButton){
        let view = viewSetting()
        switch sender.tag{
        case 1://戻ボタン
            self.present(view.viewSet(view: ViewController(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        case 2:// 一種類目+ボタン
            i = 0
            if appDelegate.box[i].qty < 4{
                appDelegate.box[i].qty =  appDelegate.box[i].qty+1
                viewDidLoad()
                audioPlayerInstance.play()
            }else if appDelegate.box[i].qty == 4{
                imageSetteng(picture: "over.jpg")
                audioPlayerInstance.play()
                // タイマーの設定（5秒間隔でメソッド「timerCall」を呼び出す）
                addTimer =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)
            }
        case 3:// 一種類目−ボタン
            i = 0
            if  appDelegate.box[i].qty != 0 && appDelegate.box[i].qty > 0{
                appDelegate.box[i].qty =  appDelegate.box[i].qty-1
            }
            viewDidLoad()
            audioPlayerInstance.play()
        case 4:// 2種類目+ボタン
            i = 1
            if appDelegate.box[i].qty < 4{
                appDelegate.box[i].qty =  appDelegate.box[i].qty+1
                viewDidLoad()
                audioPlayerInstance.play()
            }else if appDelegate.box[i].qty == 4{
                imageSetteng(picture: "over.jpg")
                audioPlayerInstance.play()
                // タイマーの設定（5秒間隔でメソッド「timerCall」を呼び出す）
                addTimer =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)
            }
        case 5:// 2種類目−ボタン
            i = 1
            if  appDelegate.box[i].qty != 0 && appDelegate.box[i].qty > 0{
                appDelegate.box[i].qty =  appDelegate.box[i].qty-1
            }
            viewDidLoad()
            audioPlayerInstance.play()
        case 6:// 3種類目+ボタン
            i = 2
            if appDelegate.box[i].qty < 4{
                appDelegate.box[i].qty =  appDelegate.box[i].qty+1
                viewDidLoad()
                audioPlayerInstance.play()
            }else if appDelegate.box[i].qty == 4{
                imageSetteng(picture: "over.jpg")
                audioPlayerInstance.play()
                // タイマーの設定（5秒間隔でメソッド「timerCall」を呼び出す）
                addTimer =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)
            }
        case 7:// 3種類目−ボタン
            i = 2
            if  appDelegate.box[i].qty != 0 && appDelegate.box[i].qty > 0{
                appDelegate.box[i].qty =  appDelegate.box[i].qty-1
            }
            viewDidLoad()
            audioPlayerInstance.play()
        case 13://商品名(1段目)
            i = 0
            appDelegate.countType[0].now = "on"
            appDelegate.countType[1].now = "off"
            appDelegate.countType[2].now = "off"
            viewDidLoad()
        case 14://商品名(2段目)
            i = 1
            appDelegate.countType[0].now = "off"
            appDelegate.countType[1].now = "on"
            appDelegate.countType[2].now = "off"
            viewDidLoad()
        case 15://商品名(3段目)
            i = 2
            appDelegate.countType[0].now = "off"
            appDelegate.countType[1].now = "off"
            appDelegate.countType[2].now = "on"
            viewDidLoad()
        case 18://注文
            appDelegate.dishSum += appDelegate.box[0].qty + appDelegate.box[1].qty + appDelegate.box[2].qty
            appDelegate.qrString = "注文は\(appDelegate.dishSum)皿で会計金額は\(appDelegate.dishSum * 110)円です"
            for i in 0...2{
                if "\(appDelegate.box[i].name)" != ""{
                    let history = (name:"\(appDelegate.box[i].name)", num:appDelegate.box[i].qty)
                    appDelegate.history.append(history)
                }
            }

            //realm　皿数
            let realm = try! Realm()
            let dishCount = realm.objects(guestData.self).last
            try! realm.write {
                dishCount!.dish = appDelegate.dishSum
            }
            imageSetteng(picture: "end.jpg")
            appDelegate.countType = [(0,""),(0,""),(0,"")]
            appDelegate.box = [("",0,"kara.png"),("",0,"kara.png"),("",0,"kara.png")]
            i = 0
            audioPlayerInstance.play()
            //遅延処理
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.present(view.viewSet(view: ViewController(), anime: .flipHorizontal), animated: false, completion: nil)
            }
        default:break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
