import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import CoreImage
import RealmSwift


class First: UIViewController {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        
        loadView()//videoplayerを破棄
        super.viewDidLoad()
        // 画像を設定する.
        let myInputImage = CIImage(image: UIImage(named: "first.jpeg")!)
        // ImageViewを.定義する.
        var myImageView: UIImageView!
        audioPlayerInstance.prepareToPlay()
        // 起動直後に遷移させる画面を宣言
        let launchViewController: UIViewController = Menu()
        // 子ViewのViewControllerを指定
        self.addChild(launchViewController)
        // 子Viewの所有権を譲渡
        launchViewController.didMove(toParent: self)

        myImageView = UIImageView(frame: self.view.frame)
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)

        //透明なボタンを作ってタップを反応させる
        let button: UIButton = UIButton(frame: CGRect(x:CGFloat(0), y:CGFloat(0), width: CGFloat(1024), height: CGFloat(768)))
        button.tag = 0
        button.addTarget(self, action: #selector(selection(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func play(){
        let path = Bundle.main.path(forResource: "\(appDelegate.movieNum)", ofType: "mp4")
        let fileURL = NSURL(fileURLWithPath: path!)
        let avAsset = AVAsset(url: fileURL as URL)
        // AVPlayerに再生させるアイテムを生成.
        let playerItem = AVPlayerItem(asset: avAsset)
        // AVPlayerを生成.
        let videoPlayer = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayer.volume = appDelegate.movieVolume
        // 出力先判定
        func IsHeadSetConnected() -> Bool{
            let route = AVAudioSession.sharedInstance().currentRoute;
            for desc  in route.outputs{
                let portType = desc.portType;
                if (portType == AVAudioSession.Port.headphones){
                    return true;
                }
            }
            return false;
        }
        // イヤホンが刺された、出された時に呼ばれる
        func setAudioNotification(){
            //NotificationCenter.default.addObserver(self,
            // selector: #selector(self.didChangeAudioSessionRoute(notification:)),
            //name: NSNotification.Name.AVAudioSessionRouteChange,
            //object: nil)
        }
        /* func didChangeAudioSessionRoute(notification:Notification){
            for desc in AVAudioSession.sharedInstance().currentRoute.outputs{
                if desc.portType == AVAudioSession.Port.headphones{
                    // イヤホン刺さった
                }else{
                    // イヤホン抜けた
                if !self.isSetSpeeker{
                    self.setupSpeeker()
                }
            }
        }*/
        // 変える実装
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            do{
                let audioSession = AVAudioSession.sharedInstance()
                try audioSession.setMode(AVAudioSession.Mode.videoChat)
                try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                try audioSession.setActive(true)
            }catch _ as NSError{
                print("NSError")
            }
        }
            
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //サイズを決める
        playerLayer.frame = CGRect(x:0, y:0, width:1024, height:768)
        self.view.layer.addSublayer(playerLayer)
        // 動画が再生し終わったことを監視する設定
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        //透明なボタンを作ってタップを反応させる
        let button: UIButton = UIButton(frame: CGRect(x:CGFloat(0), y:CGFloat(0), width: CGFloat(1024), height: CGFloat(768)))
        button.tag = 0
        button.addTarget(self, action: #selector(selection(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        videoPlayer.play()
    }
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        play()
    }
    @objc func selection(sender: UIButton){
        let view = viewSetting()
        switch sender.tag{
            case 0:
                let date = Date()
                let dateAndTime = date.formattedDateWith(style: .time)
                let realm = try! Realm()
                let obj = realm.objects(guestData.self).last
                try! realm.write {
                    obj?.inTime = dateAndTime
                }
                self.present(view.viewSet(view: ViewController(), anime: .flipHorizontal), animated: false, completion: nil)
                audioPlayerInstance.play()
            default:break
        }
    }
    override func viewDidAppear(_ animated: Bool){
        loadView()//videoplayerを破棄 画面遷移なしで
        viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        print("メモリ使いすぎ")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
