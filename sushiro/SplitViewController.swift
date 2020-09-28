import UIKit
import AVFoundation//オーディオがらみ
import AVKit
import RealmSwift

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

class SplitViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    let realm = try! Realm()
    
    
    //pickerView関連
    var soundPicker = UIPickerView()
    var moviePicker = UIPickerView()
    var label = UILabel()
    private var tableView = UITableView()
    private var sections = Section2.make()
    let dataList = [["button01a","button01b","button01c"],["movie01","movie02","movie03"]]
    let genArray : [String] = ["12歳以下男性","12歳以下女性","13-19歳男性","13-19歳女性","20-29歳男性","20-29歳女性","30-49歳男性","30-49歳女性","50歳以上男性","50歳以上女性"]
    let colorArray : [UIColor] = [.darkGray,.green,.yellow,.red,.blue,.cyan,.brown,.lightGray,.magenta,.purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let label = MakeLabel()
        let soundFilePath = Bundle.main.path(forResource: "\(appDelegate.soundNum)", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        let screenWidth: CGFloat = UIScreen.main.bounds.width //画面の幅
        let screenHeight: CGFloat = UIScreen.main.bounds.height//画面の高さ
        
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        audioPlayerInstance.prepareToPlay()
        audioPlayerInstance.volume = appDelegate.touchVolume
        
        // ViewContorller 背景色
        self.view.backgroundColor = UIColor.white
        // PickerView のサイズと位置
        soundPicker = MakePicker().make(x: 0, y: 0, width: 200, height: 600, back:UIColor.white,tag:0,_setNum:dataList[0].firstIndex(of: appDelegate.soundNum)! ,view:self)
        moviePicker = MakePicker().make(x: 0, y: 0, width: 200, height: 600, back:UIColor.white,tag:1,_setNum:dataList[1].firstIndex(of: appDelegate.movieNum)! ,view:self)

        //Delegate設定
        soundPicker.delegate = self
        soundPicker.dataSource = self
        soundPicker.selectRow(appDelegate.pickerView1Ini, inComponent: 0, animated: true)
        moviePicker.delegate = self
        moviePicker.dataSource = self
        moviePicker.selectRow(appDelegate.pickerView2Ini, inComponent: 0, animated: true)
       
        // フォントサイズ
        label.font = UIFont.systemFont(ofSize: 60)
        view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
        if appDelegate.viewType == "年代別来店割合" || appDelegate.viewType == "年代別平均皿数"{
            // テキストを右寄せにする
            label.textAlignment = NSTextAlignment.right
            tableView = UITableView(frame: CGRect(x:380, y: 0, width: screenWidth/5, height: screenHeight), style: .grouped)
        }else{
            // テキストを中央寄せにする
            label.textAlignment = NSTextAlignment.center
            view.backgroundColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
            tableView = UITableView(frame: CGRect(x:65, y: 0, width: screenWidth/2, height: screenHeight), style: .grouped)
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            
        view.addSubview(tableView)
        var doneBarButtonItem: UIBarButtonItem!
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTapped(_:)))

        self.navigationItem.rightBarButtonItems = [doneBarButtonItem]
    }
}

//UITableViewDataSource関連
extension SplitViewController: UITableViewDataSource {
    
    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let results = realm.objects(AllData.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cornerRadius:CGFloat = 20
        let sectionCount = tableView.numberOfRows(inSection: indexPath.section)
        let shapeLayer = CAShapeLayer()
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row]
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
                testSwitch.tag = 0;
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
                testSwitch.tag = 1;
                cell.accessoryView = testSwitch
            }
        }
        if appDelegate.viewType == "サウンド" {
            if indexPath.section == 0 && indexPath.row == 0{
                cell.accessoryView = soundPicker
            }
            if indexPath.section == 0 && indexPath.row == 1{
                cell.accessoryView = moviePicker
            }
            if indexPath.section == 1 && indexPath.row == 0{
                let testSwitch:UISwitch = UISwitch()
                testSwitch.addTarget(self, action: #selector(changeSwitch), for: UIControl.Event.valueChanged)
                // UISwitchの状態をオンに設定
                if appDelegate.touchVolume != 0{
                    testSwitch.isOn = true
                }else{
                    testSwitch.isOn = false
                }
                testSwitch.tag = 2;
                cell.accessoryView = testSwitch
            }
            if indexPath.section == 1 && indexPath.row == 1{
                let testSwitch:UISwitch = UISwitch()
                testSwitch.addTarget(self, action: #selector(changeSwitch), for: UIControl.Event.valueChanged)
                // UISwitchの状態をオンに設定
                if appDelegate.movieVolume != 0{
                    testSwitch.isOn = true
                }else{
                    testSwitch.isOn = false
                }
                testSwitch.tag = 3;
                cell.accessoryView = testSwitch
            }
            if indexPath.section == 2 && indexPath.row == 0{
                let slider = UISlider(frame: CGRect(x:200, y: 20, width: 300, height:20))
                slider.minimumValue = 0.0
                slider.maximumValue = 1.0
                slider.value = appDelegate.touchVolume
                slider.addTarget(self, action: #selector(sliderDidEndSliding_t(_:)), for: [.touchUpInside, .touchUpOutside])
                cell.accessoryView = slider
            }
            if indexPath.section == 2 && indexPath.row == 1{
                let slider = UISlider(frame: CGRect(x:200, y: 20, width: 300, height:20))
                slider.minimumValue = 0.0
                slider.maximumValue = 1.0
                slider.value = appDelegate.movieVolume
                slider.addTarget(self, action: #selector(sliderDidEndSliding_m(_:)), for: [.touchUpInside, .touchUpOutside])
                cell.accessoryView = slider
            }
            
        }

        if appDelegate.viewType == "年代別来店割合"{

            var dictionary : [String:Int] = [:]

            for i in 0..<10{
                dictionary.updateValue(0, forKey: genArray[i])
            }
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
                    let cellItem = MakeCell()
                    cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:30,height:35,back:UIColor.clear,_alpha:0.3, _text:"\(String(describing: dictionary[genArray[i]]!))■",_textColer:colorArray[i],_fontSize:30)
                }
            }

            super.viewWillAppear(true)
            
            let pieChartView = MakePieChartView()
            //グラフ作成
            pieChartView.frame = CGRect(x: -110, y: 200, width: view.frame.size.width, height: 350)
            for i in 0..<colorArray.count{
                pieChartView.segments.append(Segment(color: colorArray[i], value: CGFloat(dictionary[genArray[i]]!)))
            }
            view.addSubview(pieChartView)
        }

        if appDelegate.viewType == "年代別平均皿数"{

            var countDic : [String:Int] = [:]
            for i in 0..<10{
                countDic.updateValue(0, forKey: genArray[i])
            }
            var dishDic : [String:Int] = [:]
            for i in 0..<10{
                dishDic.updateValue(0, forKey: genArray[i])
            }

            for i in 0...results.count - 1 {
                if results[i].generation == "" || results[i].adultCount == "" || results[i].childCount == "" || results[i].dish == 0{
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
                    let cellItem = MakeCell()
                    cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:40,height:35,back:UIColor.clear,_alpha:0.3, _text:"\(String(describing: ans))■",_textColer:colorArray[i],_fontSize:30)
                }
            }

            super.viewWillAppear(true)
            
            let pieChartView = MakePieChartView()
            var averageArray = Array<String>(repeating: "0", count:10)
            pieChartView.frame = CGRect(x: -110, y: 200, width: view.frame.size.width, height: 350)
            for i in 0...9{
                averageArray[i] = String(round((Double(dishDic[genArray[i]]!) / Double(countDic[genArray[i]]!)) * 10) / 10)
                if averageArray[i] == "nan" {averageArray[i] = "0.0"}
            }
            for i in 0..<colorArray.count{
                pieChartView.segments.append(Segment(color: colorArray[i], value: CGFloat(Float(averageArray[i])!)))
            }
                view.addSubview(pieChartView)
        }

               
        if appDelegate.viewType == "realm" {
            let cellItem = MakeCell()
            let obj = realm.objects(GuestData.self).last
            if indexPath.section==0 && indexPath.row == 0{
                cell.accessoryView =  cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(obj!.inTime)", _fontSize:30)
            }
            if indexPath.section==0 && indexPath.row == 1{
                cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(obj!.outTime)", _fontSize:30)
            }
            if indexPath.section==0 && indexPath.row == 2{
                cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(obj!.adultCount)", _fontSize:30)
            }
            if indexPath.section==0 && indexPath.row == 3{
                cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(obj!.childCount)", _fontSize:30)
            }
            if indexPath.section==0 && indexPath.row == 4{
                cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(obj!.seatType)", _fontSize:30)
            }
            if indexPath.section==0 && indexPath.row == 5{
                cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(obj!.dish)", _fontSize:30)
            }
            if indexPath.section==1 && indexPath.row == 0{
                cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(appDelegate.qrStatus)", _fontSize:30)
            }
            if indexPath.section==1 && indexPath.row == 1{
                cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(appDelegate.soundNum)", _fontSize:30)
            }
            if indexPath.section==1 && indexPath.row == 2{
                cell.accessoryView = cellItem.makeLabel(x:200,y:20,width:300,height:30,back:UIColor.clear,_text:"\(appDelegate.movieNum)", _fontSize:30)
            }
        }
        return cell
        
    }
    
}

//UITableViewDelegate関係
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
        let view = ViewSetting()
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
        view.set(view: self, transition: ViewController())
        audioPlayerInstance.play()
        
    }
    
    @objc func sliderDidEndSliding_t(_ sender: UISlider) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.touchVolume = sender.value
        windowSetting()
    }
    
    @objc func sliderDidEndSliding_m(_ sender: UISlider) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.movieVolume = sender.value
        windowSetting()
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
            windowSetting()
        case 1://QRコードの値が変わった時
            if appDelegate.qrStatus == "qr"{
                appDelegate.qrStatus = "bc"
            }else{
                appDelegate.qrStatus = "qr"
            }
            windowSetting()
        case 2://サウンドON-OFFのタッチ音値が変わった時
            if appDelegate.touchVolume == 0{
                appDelegate.touchVolume = 0.5
            }else{
                appDelegate.touchVolume = 0.0
            }
            windowSetting()
        case 3://サウンドON-OFFのスクリーン音値が変わった時
            if appDelegate.movieVolume == 0{
                appDelegate.movieVolume = 0.5
            }else{
                appDelegate.movieVolume = 0.0
            }
            windowSetting()
        default:break
        }
    }
    
    func windowSetting() {
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        // rootViewControllerに入れる
        appDelegate.window?.rootViewController = Test()
        // 表示
        appDelegate.window?.makeKeyAndVisible()
    }
}

//pickerView関連
extension SplitViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int ) -> Int {
        if pickerView.tag == 0{
            return dataList[pickerView.tag].count
        }else{
            return dataList[pickerView.tag].count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return dataList[pickerView.tag][row]
        }else{
            return dataList[pickerView.tag][row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            appDelegate.soundNum = dataList[pickerView.tag][row]
            appDelegate.pickerView1Ini = row
        }else{
            appDelegate.movieNum = dataList[pickerView.tag][row]
            appDelegate.pickerView2Ini = row
        }
    }

}
