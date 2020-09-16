import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import Foundation
import RealmSwift
import CoreImage


class History: UIViewController,UITextFieldDelegate,UITabBarDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let myInputImage = CIImage(image: UIImage(named: "history")!)
    var addTimer = Timer()
    var timerCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        
        // let drawView = DrawView(frame: self.view.bounds)
        //self.view.addSubview(drawView)
        
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 1024,height: 768))
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
        ////audioPlayerInstance.prepareToPlay()
        // audioPlayerInstance.volume = appDelegate.volume
        //クラスをインスタンス化
        let button = makeButton()//m:backgrand,e:picture,e:border
        let label = makeLabel()//o:border,o1:backgrand,o2:0でalpha無効,ic:300でむテキスト無効
        let scrollView = UIScrollView()
       
        //縦スクロールのみにする記述
        let scrollFrame = CGRect(x: 0, y: 150, width: view.frame.width/2, height: 540)
        scrollView.frame = scrollFrame
        //ここのhightはスクロール出来る上限
        if 50*(appDelegate.history.count+5) > 540 {
        scrollView.contentSize = CGSize(width:self.view.frame.width/2, height: CGFloat(50*(appDelegate.history.count+5)))
        }else{
            scrollView.contentSize = CGSize(width:self.view.frame.width/2, height: 540.1)
        }
        
        scrollView.backgroundColor = UIColor.clear
        scrollView.layer.borderWidth = 1.5
        scrollView.layer.borderColor = UIColor.black.cgColor

        // スクロールの跳ね返り無し
        scrollView.bounces = false
        //スクロール位置の表示
        //scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(label.make(xv:40,yv:15,wv:300,hv:40,f:35,o:0,o1:0,o2:0.0,ic:"商品名"))
        scrollView.addSubview(label.make(xv:420,yv:15,wv:80,hv:40,f:35,o:0,o1:0,o2:0.0,ic:"数量"))
        
        if appDelegate.history.count != 0 {
            for i in 0...appDelegate.history.count-1 {
                // UIScrollViewに追加
                scrollView.addSubview(label.make(xv:40,yv:55+(i*50),wv:300,hv:40,f:35,o:0,o1:0,o2:0.0,ic:appDelegate.history[i].name,al:"l"))
                scrollView.addSubview(label.make(xv:420,yv:55+(i*50),wv:80,hv:40,f:35,o:0,o1:0,o2:0.0,ic:"\(appDelegate.history[i].num)"))
            }
        }
        scrollView.addSubview(label.make(xv:40,yv:Int(scrollView.contentSize.height)-150,wv:80,hv:40,f:35,o:0,o1:0,o2:0.0,ic:"小計",al:"l"))
        scrollView.addSubview(label.make(xv:40,yv:Int(scrollView.contentSize.height)-100,wv:80,hv:40,f:35,o:0,o1:0,o2:0.0,ic:"消費税",al:"l"))
        scrollView.addSubview(label.make(xv:40,yv:Int(scrollView.contentSize.height)-50,wv:80,hv:40,f:35,o:0,o1:0,o2:0.0,ic:"合計",al:"l"))
        
        //ボタン作成
        self.view.addSubview(button.make(xv:750,yv:600,wv:100,hv:50,f:50,b:"戻る",c:0,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:700,yv:250,wv:200,hv:50,f:50,b:"スタッフ呼出",c:1,d:1,e:0,m:1))
        self.view.addSubview(button.make(xv:700,yv:500,wv:200,hv:50,f:50,b:"会計に進む",c:2,d:1,e:0,m:1))
        
        func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    }
    
    //ボタンイベント
    @objc func selection(sender: UIButton){
        let view = viewSetting()
        switch sender.tag{
        case 0:
            self.present(view.viewSet(view: ViewController(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        case 1:
            self.present(view.viewSet(view: Reception(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        case 2:
            self.present(view.viewSet(view: Reception(), anime: .flipHorizontal), animated: false, completion: nil)
            audioPlayerInstance.play()
        default:break
        }
    }
}
