import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import Foundation
import CoreImage
import RealmSwift



class Call: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // 画像を設定する.
    let myInputImage = CIImage(image: UIImage(named: "call.jpeg")!)
    // ImageViewを.定義する.
    var myImageView: UIImageView!
    var addTimer = Timer()

    override func viewDidLoad() {
        loadView()//videoplayerを破棄
        print("overfuncのloadviewはした")
        super.viewDidLoad()
        myImageView = UIImageView(frame: self.view.frame)
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
        if appDelegate.qrStatus == "bc"{
            let bc = makeBarcord()
            self.view.addSubview(bc.make(string: "12-34")!)
        }else{
//            let qrc = makeQrcode()
//            self.view.addSubview(qrc.make(sum: appDelegate.qr_string))
        }

        //ボタン作成メソッド
        func makeButton(xv:Int,yv:Int,wv:Int,hv:Int,f:Int,b:String,c:Int){
            let button: UIButton = UIButton(frame: CGRect(x:CGFloat(xv), y:CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
            button.backgroundColor = UIColor.white
            button.layer.borderColor = UIColor.brown.cgColor
            button.layer.borderWidth = 1.5
            button.setTitle("\(b)", for: .normal)
            button.layer.cornerRadius = 3.0
            button.setTitleColor(UIColor.red, for: .normal)
            button.titleLabel?.numberOfLines = 2//0:無限改行,2:2行表示
            button.titleLabel?.font =  UIFont.systemFont(ofSize: 50)
            button.tag = c
            button.addTarget(self, action: #selector(selection(sender:)), for: .touchUpInside)
            // ボタンを追加する.
            self.view.addSubview(button)
        }
        
        //ボタン作成
        makeButton(xv:80,yv:500,wv:280,hv:180,f:20,b:"会計",c:0)
        makeButton(xv:380,yv:500,wv:280,hv:180,f:20,b:"キャンセル",c:1)
        makeButton(xv:680,yv:500,wv:280,hv:180,f:20,b:"戻る",c:2)
    }
    

    func showPrinterPicker() {
        // UIPrinterPickerControllerのインスタンス化
        let printerPicker = UIPrinterPickerController(initiallySelectedPrinter: nil)
        
        // UIPrinterPickerControllerをモーダル表示する
    //printerPicker.present(animated: true, completionHandler://iphoneの場合
        printerPicker.present(from: CGRect(x: 20, y: 20, width: 10, height: 10), in: view, animated: true, completionHandler:
            {
                [unowned self] printerPickerController, userDidSelect, error in
                if (error != nil) {
                    // エラー
                    print("Error")
                } else {
                    // 選択したUIPrinterを取得する
                    if let printer: UIPrinter = printerPickerController.selectedPrinter {
                        print("Printer's URL : \(printer.url)")
                        self.printToPrinter(printer: printer)
                    } else {
                        print("Printer is not selected")
                    }
                }
            }
        )
        
    }
    
    func printToPrinter(printer: UIPrinter) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        // 印刷してみる
        let printIntaractionController = UIPrintInteractionController.shared
        let info = UIPrintInfo(dictionary: nil)
        info.jobName = "Sample Print"
        info.orientation = .portrait
        printIntaractionController.printInfo = info
        //印刷する内容
        printIntaractionController.printingItem = appDelegate.scImage
        printIntaractionController.print(to: printer, completionHandler: {
            controller, completed, error in
        })
    }
    
    
    func getScreenShot() -> UIImage {
        let rect = self.view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.view.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    @objc internal func selection(sender: UIButton){
        let view = viewSetting()
        switch sender.tag{
            
            case 0:
                addTimer.invalidate()
                self.present(view.viewSet(view: Call(), anime: .flipHorizontal), animated: false, completion: nil)
                audioPlayerInstance.play()
                // UIImageViewを作成.
               let imageView = UIImageView(frame: CGRect(x:CGFloat(0), y: CGFloat(0), width: CGFloat(550), height: CGFloat(700)))
               // 画像をUIImageViewに設定する.
                imageView.image = UIImage(named: "call.jpeg")!
                self.view.addSubview(imageView)
            case 1://動画再生中のタップ
                addTimer.invalidate()
                loadView()//videoplayerを破棄 画面遷移なしで
                viewDidLoad()
            case 2:
                self.present(view.viewSet(view: ViewController(), anime: .flipHorizontal), animated: false, completion: nil)
                audioPlayerInstance.play()
            default:break
        }
    }
    override func viewDidAppear(_ animated: Bool){
        addTimer.invalidate()
        loadView()//videoplayerを破棄 画面遷移なしで
        viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        print("メモリ使いすぎ")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

