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
        //クラスをインスタンス化
        let button = MakeButton()
        let label = MakeLabel()

        // UIImageViewを作成する.
        myImageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 1024,height: 768))
        myImageView.image = UIImage(ciImage: myInputImage!)
        self.view.addSubview(myImageView)
        
        
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
        
        scrollView.addSubview(label.make(x:40,y:15,width:300,height:40,back:UIColor.clear,_text:"商品名",_fontSize:35))
        scrollView.addSubview(label.make(x:420,y:15,width:80,height:40,back:UIColor.clear,_text:"数量",_fontSize:35))
        
        if appDelegate.history.count != 0 {
            for i in 0...appDelegate.history.count-1 {
                // UIScrollViewに追加
                scrollView.addSubview(label.make(x:40,y:CGFloat(55+(i*50)),width:300,height:40,back:UIColor.clear,_text:appDelegate.history[i].name,_fontSize:35,_alignment:NSTextAlignment.left))
                scrollView.addSubview(label.make(x:420,y:CGFloat(55+(i*50)),width:80,height:40,back:UIColor.clear,_text:"\(appDelegate.history[i].num)",_fontSize:35))
            }
        }
        scrollView.addSubview(label.make(x:40,y:CGFloat(Int(scrollView.contentSize.height)-150),width:80,height:40,back:UIColor.clear,_text:"小計",_fontSize:35,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:40,y:CGFloat(Int(scrollView.contentSize.height)-100),width:80,height:40,back:UIColor.clear,_text:"消費税",_fontSize:35,_alignment:NSTextAlignment.left))
        scrollView.addSubview(label.make(x:40,y:CGFloat(Int(scrollView.contentSize.height)-50),width:80,height:40,back:UIColor.clear,_text:"合計",_fontSize:35,_alignment:NSTextAlignment.left))
       
        //ボタン作成
        self.view.addSubview(button.make(x:750,y:600,width:100,height:50,back:UIColor.white,tag:0, _borderWidth:1.5,_cornerRadius:6,_text:"戻る",_adjustsFontSizeToFitWidth:true))
         self.view.addSubview(button.make(x:700,y:250,width:200,height:50,back:UIColor.white,tag:1, _borderWidth:1.5,_cornerRadius:6,_text:"スタッフ呼出",_adjustsFontSizeToFitWidth:true))
         self.view.addSubview(button.make(x:700,y:500,width:200,height:50,back:UIColor.white,tag:2, _borderWidth:1.5,_cornerRadius:6,_text:"会計に進む",_adjustsFontSizeToFitWidth:true))
        
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
