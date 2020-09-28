import UIKit
import RealmSwift


class MakeCalculator:UIViewController{
    var show:AnyObject = self as AnyObject
    
    enum Style {
        case normal
        case full
    }
    
    func make(view:AnyObject,style: Style){
        switch style {
        case .normal:
             makeNumerickeypad(view:view)
        case .full:
            makeNumerickeypad(view:view)
            makeCustomer(view:view)
        }
    }
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var tenkey:[[String]] = [[("1"),("2"),("3")],[("4"),("5"),("6")],[("7"),("8"),("9")]]
    var inputNum:String = ""
    var change:String = ""
    var warning:String = ""
    var calculation:Int = 0
    
    //年齢層用
    var generation:String = ""
    let genArray : [String] = ["12歳以下男性","12歳以下女性","13-19歳男性","13-19歳女性","20-29歳男性","20-29歳女性","30-49歳男性","30-49歳女性","50歳以上男性","50歳以上女性"]
    
    //ラベル作成 //計算
    let label = MakeLabel()
    let button = MakeButton()
    
    
    func makeNumerickeypad(view:AnyObject){
        
        let realm = try! Realm()
        let obj = realm.objects(GuestData.self).last
        let dish = obj!.dish
        
        makeLabel(x: 400, y: 29, width:50, height:20,back:UIColor.clear,_text:"預かり", _fontSize:10,view:view)
        makeLabel(x: 400, y: 129, width:50, height:20,back:UIColor.clear,_text:"会計", _fontSize:10,view:view)
        makeLabel(x: 400, y: 229, width:50, height:20,back:UIColor.clear,_text:"お釣り", _fontSize:10,view:view)
        makeLabel(x: 400, y: 50, width:270, height:60,back:UIColor.clear,_borderWidth:1.5,_cornerRadius:6,_text:"¥\(inputNum)", _fontSize:50,view:view)
        makeLabel(x: 400, y: 150, width:270, height:60,back:UIColor.clear,_borderWidth:1.5,_cornerRadius:6,_text:"¥\(dish * 110)", _fontSize:50, view:view)
        makeLabel(x: 400, y: 250, width:270, height:60,back:UIColor.clear,_borderWidth:1.5,_cornerRadius:6,_text:"¥\(change)", _fontSize:50,view:view)
        makeLabel(x: 600, y: 29, width:50, height:20,back:UIColor.clear,_text:"\(warning)", _fontSize:10,view:view)
        //ボタン作成

        makeButton(x:750,y:650,width:200,height:80,back:UIColor.white,tag:21, _borderWidth:1.5,_cornerRadius:6,_text:"ENTER", _fontSize:50,view:view)
        
        //テンキー作成
        for i in 1...3{
            for j in 1...3{
                makeButton(x:CGFloat(300+j*100) ,y:CGFloat(250+i*100),width:70,height:70,back:UIColor.white,tag:Int(tenkey[i-1][j-1])!,_borderWidth:1.5,_cornerRadius:6, _text:tenkey[i-1][j-1], _fontSize:50,_isSelf:false,view:view)
                
            }
        }
        makeButton(x:400,y:650,width:180,height:70,back:UIColor.white,tag:10, _borderWidth:1.5,_cornerRadius:6, _text:"0", _fontSize:50,view:view)
        makeButton(x:600,y:650,width:70,height:70,back:UIColor.white,tag:22, _borderWidth:1.5,_cornerRadius:6, _text:"〆", _fontSize:50,view:view)
    }

    func makeCustomer(view:AnyObject){
        //年齢層
        makeButton(x:750,y:50,width:100,height:100,back:UIColor(red:0.10, green:0.10, blue:1, alpha:0.5),tag:30, _borderWidth:1.5,_cornerRadius:6,_text:"12", _fontSize:50,view:view)
        makeButton(x:850,y:50,width:100,height:100,back:UIColor(red:0.96, green:0.25, blue:0.15, alpha:0.5),tag:31, _borderWidth:1.5,_cornerRadius:6,_text:"12", _fontSize:50,view:view)
        makeButton(x:750,y:150,width:100,height:100,back:UIColor(red:0.10, green:0.10, blue:1, alpha:0.5),tag:32, _borderWidth:1.5,_cornerRadius:6,_text:"19", _fontSize:50,view:view)
        makeButton(x:850,y:150,width:100,height:100,back:UIColor(red:0.96, green:0.25, blue:0.15, alpha:0.5),tag:33, _borderWidth:1.5,_cornerRadius:6,_text:"19", _fontSize:50,view:view)
        makeButton(x:750,y:250,width:100,height:100,back:UIColor(red:0.10, green:0.10, blue:1, alpha:0.5),tag:34, _borderWidth:1.5,_cornerRadius:6,_text:"29", _fontSize:50,view:view)
        makeButton(x:850,y:250,width:100,height:100,back:UIColor(red:0.96, green:0.25, blue:0.15, alpha:0.5),tag:35, _borderWidth:1.5,_cornerRadius:6,_text:"29", _fontSize:50,view:view)
        makeButton(x:750,y:350,width:100,height:100,back:UIColor(red:0.10, green:0.10, blue:1, alpha:0.5),tag:36, _borderWidth:1.5,_cornerRadius:6,_text:"49", _fontSize:50,view:view)
        makeButton(x:850,y:350,width:100,height:100,back:UIColor(red:0.96, green:0.25, blue:0.15, alpha:0.5),tag:37, _borderWidth:1.5,_cornerRadius:6,_text:"49", _fontSize:50,view:view)
        makeButton(x:750,y:450,width:100,height:100,back:UIColor(red:0.10, green:0.10, blue:1, alpha:0.5),tag:38, _borderWidth:1.5,_cornerRadius:6,_text:"50", _fontSize:50,view:view)
        makeButton(x:850,y:450,width:100,height:100,back:UIColor(red:0.96, green:0.25, blue:0.15, alpha:0.5),tag:39, _borderWidth:1.5,_cornerRadius:6,_text:"50", _fontSize:50,view:view)
        makeButton(x:750,y:570,width:200,height:60,back:UIColor.white,tag:22,_borderWidth:1.5,_cornerRadius:6, _text:"\(generation)", _fontSize:25,_font:"Bold",view:view)
        
        //年齢層年齢層マスク
        if appDelegate.geneMaskFlag != 100 {
            if appDelegate.geneMaskFlag % 2 == 0{
                label.make(x:750 ,y:CGFloat(50 + ((appDelegate.geneMaskFlag - 30) * 50)),width:100,height:100,back:UIColor.black,_cornerRadius:6,_alpha:0.3,_fontSize:50,view:view)
            }else{
                label.make(x:850 ,y:CGFloat(50 + ((appDelegate.geneMaskFlag - 31) * 50)),width:100,height:100,back:UIColor.black,_cornerRadius:6,_alpha:0.3,_fontSize:50,view:view)
            }
        }
    }
        

    @objc func selection(sender: UIButton){
        let view = ViewSetting()
        let appSetting = AppSetting()
        let guestData = AllData()
        var k:Int = 0
        var l:Int = 0
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
        case 21://Enter
            if inputNum == "" || generation == ""{
                MakePopUp().alert(title: "未入力があります", view:show)
                break
            }
            let value = Int(inputNum.replacingOccurrences(of: ",", with: ""))! - (appDelegate.dishSum * 110)
            if value < 0 {
                MakePopUp().alert(title: "再入力して下さい", view: show)
                inputNum = ""
                show.loadView()
                show.viewDidLoad()
                audioPlayerInstance.play()
                break
            }
            change = String(formatterMake().string(from: value as NSNumber)!)
            show.viewDidLoad()
            
            //データの保存
            appSetting.save()
            guestData.save(generation: generation)
            
            //初期化処理
            appDelegate.dishSum = 0
            appDelegate.choise = 0
            appDelegate.tagFlag2 = 0
            appDelegate.geneMaskFlag = 100
            appDelegate.history = []
            
            audioPlayerInstance.play()
            show.loadView()
            show.viewDidLoad()
            //遅延
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                view.set(view: self.show, transition: Ticket())
            }
        case 22:
            //✗
            inputNum = String(inputNum.dropLast())
            warning = ""
            if inputNum == "" {
                show.loadView()
                show.viewDidLoad()
                audioPlayerInstance.play()
                break
            }
            let value = Int(inputNum.replacingOccurrences(of: ",", with: ""))!
            inputNum = String(formatterMake().string(from: value as NSNumber)!)
            show.loadView()
            show.viewDidLoad()
            audioPlayerInstance.play()
        //年齢層
        case l:
            generation = genArray[l - 30]
            appDelegate.geneMaskFlag = sender.tag
            show.loadView()
            show.viewDidLoad()
            audioPlayerInstance.play()
        //年齢層終わり
        default:break
        }
    }
    
    //テンキー用メソッド
    func tenkeyHandle(inputNum:String) -> String{
      
        var input = inputNum
        
        calculation = Int(input.replacingOccurrences(of: ",", with: ""))!
        if input.first == "0"{input = String(input.dropFirst())}
        if input.count >= 8 {
            warning = "これ以上入力できません"
            show.loadView()
            show.viewDidLoad()
            return input
        }else{
            warning = ""
            show.loadView()
            show.viewDidLoad()
            if input.count == 4 {input = inputNum + ","}
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
    
    
    func makeLabel(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,back:UIColor,
                   _borderWidth:CGFloat=0.0,_borderColor:CGColor = UIColor.black.cgColor,_cornerRadius:CGFloat=0.0,_alpha:CGFloat=1.0,
                   _text:String="",_textColer:UIColor=UIColor.black,_fontSize:CGFloat=30,_isAdjusts:Bool=true,_alignment:NSTextAlignment=NSTextAlignment.center,view:AnyObject){
        show = view
        
        //必須
        let label = UILabel(frame: CGRect(x:x, y:y, width:width, height:height))
        label.backgroundColor = back
        
        //ビューオプション
        label.layer.borderWidth = _borderWidth
        label.layer.borderColor = _borderColor
        label.layer.masksToBounds = true//cornerRadiusを使用するために必要
        label.layer.cornerRadius = _cornerRadius
        label.alpha = _alpha
        
        //テキストオプション
        label.text = _text
        label.textColor = _textColer
        label.font = label.font.withSize(_fontSize)
        label.adjustsFontSizeToFitWidth = _isAdjusts
        label.textAlignment = _alignment
        view.view.addSubview(label)
    }
    
    func makeButton(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,back:UIColor,tag:Int,
                    _pic:String="",_borderWidth:CGFloat=0.0,_cornerRadius:CGFloat=0.0,_alpha:CGFloat=1.0,
                    _text:String="",_textColer:UIColor=UIColor.black,_fontSize:CGFloat=30,_isAdjusts:Bool=true,_alignment:NSTextAlignment=NSTextAlignment.center,_font:String = "Bold",
                    _isSelf:Bool = true,view:AnyObject){
        
        show = view
        //必須
        let button: UIButton = UIButton(frame: CGRect(x:x, y:y, width:width, height:height))
        button.backgroundColor = back
        button.tag = tag
        button.addTarget(self, action: #selector(selection(sender:)), for: .touchDown)
        
        //ビューオプション
        if _pic != ""{
            button.setBackgroundImage(UIImage(named: "\(_pic).jpeg"), for: .normal)
            
        }
        button.layer.borderWidth = _borderWidth
        if _borderWidth != 0.0 {
            button.layer.borderColor = UIColor.black.cgColor
            
        }
        button.layer.masksToBounds = true//cornerRadiusを使用するために必要
        button.layer.cornerRadius = _cornerRadius
        button.alpha = _alpha
        
        //テキストオプション
        button.setTitleColor(_textColer, for: .normal)
        button.setTitle(_text, for: .normal)
        button.titleLabel?.font =  UIFont(name:_font,size:_fontSize)
        button.titleLabel?.font =  UIFont.systemFont(ofSize:_fontSize)
        button.titleLabel?.adjustsFontSizeToFitWidth = _isAdjusts
        view.view.addSubview(button)
    }
}
