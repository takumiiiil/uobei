import UIKit
import AVFoundation
import AVKit
import RealmSwift


class Call: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var addTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //背景を設定
        let background = MakeBackgroundImage()
        self.view.addSubview(background.make(image:"call.jpeg"))
        
        //クラスをインスタンス化
        let button = MakeButton()

        //UI作成
        button.make(x:80,y:500,width:280,height:180,back:UIColor.red, tag:0,_borderWidth:1.5, _cornerRadius:6,_text:"会計", _textColor:UIColor.white,_fontSize:50,view:self)
        button.make(x:380,y:500,width:280,height:180,back:UIColor.white,tag:1,_borderWidth:1.5, _cornerRadius:6,_text:"キャンセル", _fontSize:50,view:self)
        button.make(x:680,y:500,width:280,height:180,back:UIColor.white,tag:2,_borderWidth:1.5, _cornerRadius:6,_text:"戻る", _fontSize:50,view:self)

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
        let view = ViewSetting()
        switch sender.tag{
            case 0:
                addTimer.invalidate()
                view.set(view: self, transition: Call())
                audioPlayerInstance.play()
                // UIImageViewを作成.
               let imageView = UIImageView(frame: CGRect(x:CGFloat(0), y: CGFloat(0), width: CGFloat(550), height: CGFloat(700)))
               // 画像をUIImageViewに設定する.
                imageView.image = UIImage(named: "call.jpeg")!
                self.view.addSubview(imageView)
            case 1:
                view.set(view: self, transition: ViewController())
                audioPlayerInstance.play()
            case 2:
                view.set(view: self, transition: ViewController())
                audioPlayerInstance.play()
            default:break
        }
    }
    
    override func viewDidAppear(_ animated: Bool){
        addTimer.invalidate()
        loadView()//videoplayerを破棄 画面遷移なしで
        viewDidLoad()
    }
}
