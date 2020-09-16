import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import Foundation
import RealmSwift
import CoreImage


//グローバルにする必要ある

struct Section2 {
    var title: String
    var items: [String]
}

extension Section2 {
    static func make() -> [Section] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        switch appDelegate.viewType{
            case "アカウント":
                return[Section(title: "アカウント", items: ["席番号", "到着時間"])]//sections[0].count=1
            case "二次元コード":
                return[Section(title: "二次元コード", items: ["バーコード", "QRコード"])]//sections[0].count=1
            case "サウンド":
                return[Section(title: "サウンド", items: ["タッチ音", "スクリーンセーバ"]),//sections[0].count=3,sections[2][0].items.count=1
                    Section(title: "サウンドON-OFF", items: ["タッチ音", "スクリーンセーバ"]),//sections[2][1].items.count=4
                    Section(title: "音量", items: ["タッチ音", "スクリーンセーバ"])]//sections[2][2].items.count=2
            case "年代別来店割合":
                return[Section(title:"年代別来店割合",items:["12歳以下男性","12歳以下女性","13-19歳男性","13-19歳女性","20-29歳男性","20-29歳女性","30-49歳男性","30-49歳女性","50歳以上男性","50歳以上女性"])]
             case "年代別平均皿数":
                return[Section(title:"年代別平均皿数",items:["12歳以下男性","12歳以下女性","13-19歳男性","13-19歳女性","20-29歳男性","20-29歳女性","30-49歳男性","30-49歳女性","50歳以上男性","50歳以上女性"])]
            case "realm":
            
                return[Section(title: "guestData", items: ["入室時間", "退出時間","大人","子供","席タイプ","皿数"]),
                       Section(title: "appSetting", items: ["二次元コード","タッチ音","スクリーンセーバ",])]//sections[0].count=3,sections[2][0].items.count=1
            default:
                return[Section(title: "アカウント", items: ["席番号", "到着時間"])]//sections[0].count=1
        }
    }
}

class SplitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //pickerView関連
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    var label = UILabel()
    private var tableView = UITableView()
    private var sections = Section2.make()
    let dataList1 = [
        "button01a","button01b","button01c"
    ]
    let dataList2 = [
        "movie01","movie02","movie03"
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int ) -> Int {
        if pickerView == pickerView1{
            return dataList1.count
        }else{
            return dataList2.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView1{
            return dataList1[row]
        }else{
            return dataList2[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView1{
            appDelegate.soundNum=dataList1[row]
            appDelegate.pickerView1Ini = row
        }else{
            appDelegate.movieNum=dataList2[row]
            appDelegate.pickerView2Ini = row
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let soundFilePath = Bundle.main.path(forResource: "\(appDelegate.soundNum)", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        audioPlayerInstance.prepareToPlay()
        audioPlayerInstance.volume = appDelegate.touchVolume//picker関連
        
        // ViewContorller 背景色
        self.view.backgroundColor = UIColor.white
        // PickerView のサイズと位置
        pickerView1.frame = CGRect(x: 0, y: 0, width: 200, height: 600)
        pickerView2.frame = CGRect(x: 0, y: 0, width: 200, height: 600)
        pickerView1.backgroundColor = UIColor.white
        pickerView2.backgroundColor = UIColor.white
        // PickerViewはスクリーンの中央に設定
        pickerView1.center = self.view.center
        pickerView2.center = self.view.center
        // Delegate設定
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView1.selectRow(appDelegate.pickerView1Ini, inComponent: 0, animated: true)
        pickerView2.selectRow(appDelegate.pickerView2Ini, inComponent: 0, animated: true)
        
        // フォントサイズ
        label.font = UIFont.systemFont(ofSize: 60)
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        let screenWidth: CGFloat = UIScreen.main.bounds.width //画面の幅
        let screenHeight: CGFloat = UIScreen.main.bounds.height//画面の高さ
        if appDelegate.viewType == "年代別来店割合" || appDelegate.viewType == "年代別平均皿数"{
            // テキストを右寄せにする
            label.textAlignment = NSTextAlignment.right
            tableView = UITableView(frame: CGRect(x:460, y: 0, width: screenWidth/5, height: screenHeight), style: .grouped)
        }else{
            // テキストを中央寄せにする
            label.textAlignment = NSTextAlignment.center
            view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
            tableView = UITableView(frame: CGRect(x:0, y: 0, width: screenWidth/2 + 200, height: screenHeight), style: .grouped)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
        view.addSubview(tableView)
        var doneBarButtonItem: UIBarButtonItem!
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTapped(_:)))
        // ③バーボタンアイテムの追加
        self.navigationItem.rightBarButtonItems = [doneBarButtonItem]
    }
}


extension SplitViewController: UITableViewDataSource {
    
    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
        //角を丸める処理
        let cornerRadius:CGFloat = 20
        let sectionCount = tableView.numberOfRows(inSection: indexPath.section)
        let shapeLayer = CAShapeLayer()
        cell.layer.mask = nil
        if sectionCount > 1 {
            switch indexPath.row {
            case 0:
                var bounds = cell.bounds
                bounds.origin.y += 1.0
                let bezierPath = UIBezierPath(roundedRect: bounds,
                                              byRoundingCorners: [.topLeft,.topRight],
                                              cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
                shapeLayer.path = bezierPath.cgPath
                cell.layer.mask = shapeLayer
            case sectionCount - 1:
                var bounds = cell.bounds
                bounds.size.height -= 1.0
                let bezierPath = UIBezierPath(roundedRect: bounds,
                                              byRoundingCorners: [.bottomLeft,.bottomRight],
                                              cornerRadii: CGSize(width: cornerRadius,height: cornerRadius))
                shapeLayer.path = bezierPath.cgPath
                cell.layer.mask = shapeLayer
            default:
                break
            }
        }
        else {
            let bezierPath = UIBezierPath(roundedRect:
                cell.bounds.insetBy(dx: 0.0, dy: 2.0),
                                          cornerRadius: cornerRadius)
            shapeLayer.path = bezierPath.cgPath
            cell.layer.mask = shapeLayer
        }
        if cell.accessoryView == nil {
        }
      
        if appDelegate.viewType == "アカウント" {
            if indexPath.row == 0{
                cell.accessoryView = UISwitch()
            }
            if indexPath.row == 1{
                cell.accessoryView = UISwitch()
            }
        }
        if appDelegate.viewType == "二次元コード" {
            if indexPath.row == 0{
                // UISwitch値が変更された時に呼び出すメソッドの設定
                let testSwitch:UISwitch = UISwitch()
                testSwitch.addTarget(self, action: #selector(changeSwitch), for: UIControl.Event.valueChanged)
                // UISwitchの状態をオンに設定
                if appDelegate.qrStatus == "qr"{
                    testSwitch.isOn = false
                }else{
                    testSwitch.isOn = true
                }
                testSwitch.tag=0;
                cell.accessoryView = testSwitch
            }
            if indexPath.row == 1{
                // UISwitch値が変更された時に呼び出すメソッドの設定
                let testSwitch:UISwitch = UISwitch()
                testSwitch.addTarget(self, action: #selector(changeSwitch), for: UIControl.Event.valueChanged)
                // UISwitchの状態をオンに設定
                if appDelegate.qrStatus == "qr"{
                    testSwitch.isOn = true
                }else{
                    testSwitch.isOn = false
                }
                testSwitch.tag=1;
                cell.accessoryView = testSwitch
            }
        }
        if appDelegate.viewType == "サウンド" {
            if indexPath.section==0 && indexPath.row == 0{
                cell.accessoryView = pickerView1
            }
            if indexPath.section==0 && indexPath.row == 1{
                cell.accessoryView = pickerView2
            }
            if indexPath.section==1 && indexPath.row == 0{
                let testSwitch:UISwitch = UISwitch()
                testSwitch.addTarget(self, action: #selector(changeSwitch), for: UIControl.Event.valueChanged)
                // UISwitchの状態をオンに設定
                if appDelegate.touchVolume != 0{
                    testSwitch.isOn = true
                }else{
                    testSwitch.isOn = false
                }
                testSwitch.tag=2;
                cell.accessoryView = testSwitch
            }
            if indexPath.section==1 && indexPath.row == 1{
                let testSwitch:UISwitch = UISwitch()
                testSwitch.addTarget(self, action: #selector(changeSwitch), for: UIControl.Event.valueChanged)
                // UISwitchの状態をオンに設定
                if appDelegate.movieVolume != 0{
                    testSwitch.isOn = true
                }else{
                    testSwitch.isOn = false
                }
                testSwitch.tag=3;
                cell.accessoryView = testSwitch
            }
            if indexPath.section==2 && indexPath.row == 0{
                let slider = UISlider(frame: CGRect(x:200, y: 20, width: 300, height:20))
                slider.minimumValue = 0.0
                slider.maximumValue = 1.0
                slider.value = appDelegate.touchVolume
                slider.addTarget(self, action: #selector(sliderDidEndSliding_t(_:)), for: [.touchUpInside, .touchUpOutside])
                cell.accessoryView = slider
            }
            if indexPath.section==2 && indexPath.row == 1{
                let slider = UISlider(frame: CGRect(x:200, y: 20, width: 300, height:20))
                slider.minimumValue = 0.0
                slider.maximumValue = 1.0
                slider.value = appDelegate.movieVolume
                slider.addTarget(self, action: #selector(sliderDidEndSliding_m(_:)), for: [.touchUpInside, .touchUpOutside])
                cell.accessoryView = slider
            }
            
        }
        
        if appDelegate.viewType == "年代別来店割合"{
            let realm = try! Realm()
            let label = makeLabel()
            let results = realm.objects(allData.self)
            var dictionary : [String:Int] = ["12歳以下男性":0,"12歳以下女性":0,"13-19歳男性":0,"13-19歳女性":0,"20-29歳男性":0,"20-29歳女性":0,"30-49歳男性":0,"30-49歳女性":0,"50歳以上男性":0,"50歳以上女性":0]
            let genArray : [String] = ["12歳以下男性","12歳以下女性","13-19歳男性","13-19歳女性","20-29歳男性","20-29歳女性","30-49歳男性","30-49歳女性","50歳以上男性","50歳以上女性"]
            let colorArray : [UIColor] = [.darkGray,.green,.yellow,.red,.systemPink,.cyan,.brown,.lightGray,.magenta,.purple]
            
            
            for i in 0...results.count - 1 {
                if dictionary[results[i].generation] == nil {
                    continue
                }else{
                    dictionary[results[i].generation]! += 1
                }
                dictionary.updateValue(dictionary[results[i].generation]!, forKey: results[i].generation)
            }

            for i in 0...9{
                if indexPath.section==0 && indexPath.row == i{
                    let generationLabel = label.make(xv:200,yv:20,wv:30,hv:35,f:30,o:0,o1:0,o2:0.3,ic:"\(String(describing: dictionary[genArray[i]]!))■")
                    generationLabel.textColor = colorArray[i]
                    cell.accessoryView = generationLabel
                }
            }
            
            super.viewWillAppear(true)
            let pieChartView = PieChartView()

            pieChartView.frame = CGRect(x: -80, y: 200, width: view.frame.size.width, height: 350)
            pieChartView.segments = [
                Segment(color: UIColor.darkGray, value: CGFloat(dictionary[genArray[0]]!)),
                Segment(color: UIColor.green, value: CGFloat(dictionary[genArray[1]]!)),
                Segment(color: UIColor.yellow, value: CGFloat(dictionary[genArray[2]]!)),
                Segment(color: UIColor.red, value: CGFloat(dictionary[genArray[3]]!)),
                Segment(color: UIColor.systemPink, value: CGFloat(dictionary[genArray[4]]!)),
                Segment(color: UIColor.cyan, value: CGFloat(dictionary[genArray[5]]!)),
                Segment(color: UIColor.brown, value: CGFloat(dictionary[genArray[6]]!)),
                Segment(color: UIColor.lightGray, value: CGFloat(dictionary[genArray[7]]!)),
                Segment(color: UIColor.magenta, value: CGFloat(dictionary[genArray[8]]!)),
                Segment(color: UIColor.purple, value: CGFloat(dictionary[genArray[9]]!))
            ]
            view.addSubview(pieChartView)
        }
        
        if appDelegate.viewType == "年代別平均皿数"{
            let realm = try! Realm()
            let label = makeLabel()
            var nilCou = 0
            let results = realm.objects(allData.self)
            var countDic : [String:Int] = ["12歳以下男性":0,"12歳以下女性":0,"13-19歳男性":0,"13-19歳女性":0,"20-29歳男性":0,"20-29歳女性":0,"30-49歳男性":0,"30-49歳女性":0,"50歳以上男性":0,"50歳以上女性":0]
            var dishDic : [String:Int] = ["12歳以下男性":0,"12歳以下女性":0,"13-19歳男性":0,"13-19歳女性":0,"20-29歳男性":0,"20-29歳女性":0,"30-49歳男性":0,"30-49歳女性":0,"50歳以上男性":0,"50歳以上女性":0]
                   let genArray : [String] = ["12歳以下男性","12歳以下女性","13-19歳男性","13-19歳女性","20-29歳男性","20-29歳女性","30-49歳男性","30-49歳女性","50歳以上男性","50歳以上女性"]
                   let colorArray : [UIColor] = [.darkGray,.green,.yellow,.red,.systemPink,.cyan,.brown,.lightGray,.magenta,.purple]
                   for i in 0...results.count - 1 {
                       if results[i].generation == "" || results[i].adultCount == "" || results[i].childCount == "" || results[i].dish == 0{
                           nilCou += 1
                           continue
                       }else{
                        countDic[results[i].generation]! += (Int(results[i].adultCount)! + Int(results[i].childCount)!)
                        dishDic[results[i].generation]! += results[i].dish
                    
                   }
                   countDic.updateValue(countDic[results[i].generation]!, forKey: results[i].generation)
                   dishDic.updateValue(dishDic[results[i].generation]!, forKey: results[i].generation)
            }
                   for i in 0...9{
                       if indexPath.section==0 && indexPath.row == i{
                        var ans:String = String(round((Double(dishDic[genArray[i]]!) / Double(countDic[genArray[i]]!)) * 10) / 10)
                        if ans == "nan" {ans = "0"}
                           let generationLabel = label.make(xv:200,yv:20,wv:40,hv:35,f:30,o:0,o1:0,o2:0.3,ic:"\(String(describing: ans))■")
                           generationLabel.textColor = colorArray[i]
                           cell.accessoryView = generationLabel
                       }
                   }
                   super.viewWillAppear(true)
                   let pieChartView = PieChartView()

                   pieChartView.frame = CGRect(x: -80, y: 200, width: view.frame.size.width, height: 350)
            var averageArray = Array<String>(repeating: "0", count:10)
            for i in 0...9{
                averageArray[i] = String(round((Double(dishDic[genArray[i]]!) / Double(countDic[genArray[i]]!)) * 10) / 10)
                if averageArray[i] == "nan" {averageArray[i] = "0.0"}
            }
                   pieChartView.segments = [
                       Segment(color: UIColor.darkGray, value: CGFloat(Float(averageArray[0])!)),
                       Segment(color: UIColor.green, value: CGFloat(Float(averageArray[1])!)),
                       Segment(color: UIColor.yellow, value: CGFloat(Float(averageArray[2])!)),
                       Segment(color: UIColor.red, value: CGFloat(Float(averageArray[3])!)),
                       Segment(color: UIColor.systemPink, value: CGFloat(Float(averageArray[4])!)),
                       Segment(color: UIColor.cyan, value: CGFloat(Float(averageArray[5])!)),
                       Segment(color: UIColor.brown, value: CGFloat(Float(averageArray[6])!)),
                       Segment(color: UIColor.lightGray, value: CGFloat(Float(averageArray[7])!)),
                       Segment(color: UIColor.magenta, value: CGFloat(Float(averageArray[8])!)),
                       Segment(color: UIColor.purple, value: CGFloat(Float(averageArray[9])!))
                   ]
                   view.addSubview(pieChartView)
               }
        let label = makeLabel()//o:border,o1:backgrand,o2:0でalpha無効,ic:300でむテキスト無効
        if appDelegate.viewType == "realm" {
            let realm = try! Realm()
            let obj = realm.objects(guestData.self).last
            if indexPath.section==0 && indexPath.row == 0{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(obj!.inTime)")
                cell.accessoryView = label3
            }
            if indexPath.section==0 && indexPath.row == 1{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(obj!.outTime)")
                cell.accessoryView = label3
            }
            if indexPath.section==0 && indexPath.row == 2{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(obj!.adultCount)")
                cell.accessoryView = label3
            }
            if indexPath.section==0 && indexPath.row == 3{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(obj!.childCount)")
                cell.accessoryView = label3
            }
            if indexPath.section==0 && indexPath.row == 4{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(obj!.seatType)")
                cell.accessoryView = label3
            }
            if indexPath.section==0 && indexPath.row == 5{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(obj!.dish)")
                cell.accessoryView = label3
            }
            if indexPath.section==1 && indexPath.row == 0{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(appDelegate.qrStatus)")
                cell.accessoryView = label3
            }
            if indexPath.section==1 && indexPath.row == 1{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(appDelegate.soundNum)")
                cell.accessoryView = label3
            }
            if indexPath.section==1 && indexPath.row == 2{
                let label3 = label.make(xv:200,yv:20,wv:300,hv:30,f:30,o:0,o1:0,o2:0.3,ic:"\(appDelegate.movieNum)")
                cell.accessoryView = label3
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
extension SplitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(sections[indexPath.section].items[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.isScrollEnabled = true
        super.viewWillAppear(animated)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
    }
    //doneタップ時
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let view = viewSetting()
        let soundFilePath = Bundle.main.path(forResource: "\(appDelegate.soundNum)", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        audioPlayerInstance.volume = appDelegate.touchVolume
        self.present(view.viewSet(view: ViewController(), anime: .flipHorizontal), animated: false, completion: nil)
        audioPlayerInstance.play()
    }
    @objc func sliderDidEndSliding_t(_ sender: UISlider) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.touchVolume = sender.value
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        // rootViewControllerに入れる
        appDelegate.window?.rootViewController = Test()
        // 表示
        appDelegate.window?.makeKeyAndVisible()
    }
    @objc func sliderDidEndSliding_m(_ sender: UISlider) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.movieVolume = sender.value
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        //　Storyboardを指定
        // rootViewControllerに入れる
        appDelegate.window?.rootViewController = Test()
        // 表示
        appDelegate.window?.makeKeyAndVisible()
    }
    @objc func changeSwitch(sender: UISwitch) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // UISwitch値を取得
        switch sender.tag{
        case 0://バーコードの値が変わった時
            if appDelegate.qrStatus == "qr"{
                appDelegate.qrStatus = "bc"
            }else{
                appDelegate.qrStatus = "qr"
            }
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            //　Storyboardを指定
            // rootViewControllerに入れる
            appDelegate.window?.rootViewController = Test()
            // 表示
            appDelegate.window?.makeKeyAndVisible()
        case 1://QRコードの値が変わった時
            if appDelegate.qrStatus == "qr"{
                appDelegate.qrStatus = "bc"
            }else{
                appDelegate.qrStatus = "qr"
            }
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
           
            // rootViewControllerに入れる
            appDelegate.window?.rootViewController = Test()
            // 表示
            appDelegate.window?.makeKeyAndVisible()
        case 2://サウンドON-OFFのタッチ音値が変わった時
            if appDelegate.touchVolume == 0{
                appDelegate.touchVolume = 0.5
            }else{
                appDelegate.touchVolume = 0.0
            }
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            //　Storyboardを指定
            // rootViewControllerに入れる
            appDelegate.window?.rootViewController = Test()
            // 表示
            appDelegate.window?.makeKeyAndVisible()
        case 3://サウンドON-OFFのスクリーン音値が変わった時
            if appDelegate.movieVolume == 0{
                appDelegate.movieVolume = 0.5
            }else{
                appDelegate.movieVolume = 0.0
            }
            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
            appDelegate.window?.rootViewController = Test()
            appDelegate.window?.makeKeyAndVisible()
        default:break
        }
    }
    struct Segment {
      // MARK: セグメントの背景色
      var color : UIColor
      // MARK: セグメントの割合を設定する変数（比率）
      var value : CGFloat
    }
    class PieChartView: UIView {
      var segments = [Segment]() {
        didSet {
          setNeedsDisplay()
        }
      }
      override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
      }
      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }
      override func draw(_ rect: CGRect) {
        // MARK: CGContextの初期化
        let ctx = UIGraphicsGetCurrentContext()
        // MARK: 円型にするためにradiusを設定
        let radius = min(frame.size.width, frame.size.height)/2
        // MARK: Viewの中心点を取得
        let viewCenter = CGPoint(x: bounds.size.width/2-50, y: bounds.size.height/2)
        // MARK: セグメントごとの比率に応じてグラフを変形するための定数
        let valueCount = segments.reduce(0) {$0 + $1.value}
        // MARK: 円グラフの起点を設定 [the starting angle is -90 degrees (top of the circle, as the context is flipped). By default, 0 is the right hand side of the circle, with the positive angle being in an anti-clockwise direction (same as a unit circle in maths).]
        var startAngle = -CGFloat(M_PI*0.5)
        // MARK: 初期化されたすべてのセグメントを描画するための処理
        for segment in segments { // loop through the values array
          ctx?.setFillColor(segment.color.cgColor)
          let endAngle = startAngle+CGFloat(M_PI*2)*(segment.value/valueCount)
          ctx?.move(to: CGPoint(x:viewCenter.x, y: viewCenter.y))
          ctx?.addArc(center: CGPoint(x:viewCenter.x, y: viewCenter.y), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
          ctx?.fillPath()
          startAngle = endAngle
        }
      }
    }
}
