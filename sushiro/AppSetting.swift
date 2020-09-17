import UIKit
import RealmSwift

class appSetting:Object{
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
}
