import UIKit
import RealmSwift


class AppSetting:Object{
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
   
    
    func doInit(){
        let realm = try! Realm()
        let saveObj = realm.objects(AppSetting.self).last
        if saveObj != nil {
            try! realm.write {
                appDelegate.touchVolume = saveObj!.touchVolume
                appDelegate.movieVolume = saveObj!.movieVolume
                appDelegate.volumeM = saveObj!.volumeM
                appDelegate.volumeMstatus = saveObj!.volumeMstatus
                appDelegate.volumeVstatus = saveObj!.volumeVstatus
                appDelegate.soundNum = saveObj!.soundNum
                appDelegate.movieNum = saveObj!.movieNum
                appDelegate.pickerView1Ini = saveObj!.pickerView1Ini
                appDelegate.pickerView2Ini = saveObj!.pickerView2Ini
            }
        }else{
            try! realm.write {
                realm.add(AppSetting())
            }
        }
    }
    
    func save(){
        let realm = try! Realm()
        let saveObj = realm.objects(AppSetting.self).last
        try! realm.write {
            saveObj?.touchVolume = appDelegate.touchVolume
            saveObj?.movieVolume = appDelegate.movieVolume
            saveObj?.volumeM = appDelegate.volumeM
            saveObj?.volumeMstatus = appDelegate.volumeMstatus
            saveObj?.volumeVstatus = appDelegate.volumeVstatus
            saveObj?.soundNum = appDelegate.soundNum
            saveObj?.movieNum = appDelegate.movieNum
            saveObj?.pickerView1Ini = appDelegate.pickerView1Ini
            saveObj?.pickerView2Ini = appDelegate.pickerView2Ini
        }
    }
}


