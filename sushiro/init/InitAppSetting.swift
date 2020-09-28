//import UIKit
//import RealmSwift
//
////ラベル作成class
//class InitAppSetting{
//    
//    
//    
//    func doInit(){
//        let saveObj = realm.objects(appSetting.self).last
//        if saveObj != nil {
//            try! realm.write {
//                appDelegate.touchVolume = saveObj!.touchVolume
//                appDelegate.movieVolume = saveObj!.movieVolume
//                appDelegate.volumeM = saveObj!.volumeM
//                appDelegate.volumeMstatus = saveObj!.volumeMstatus
//                appDelegate.volumeVstatus = saveObj!.volumeVstatus
//                appDelegate.soundNum = saveObj!.soundNum
//                appDelegate.movieNum = saveObj!.movieNum
//                appDelegate.pickerView1Ini = saveObj!.pickerView1Ini
//                appDelegate.pickerView2Ini = saveObj!.pickerView2Ini
//            }
//        }else{
//            try! realm.write {
//                realm.add(appSetting())
//            }
//        }
//    }
//    
//    func save(){
//        let saveObj = realm.objects(appSetting.self).last
//        try! realm.write {
//            saveObj?.touchVolume = appDelegate.touchVolume
//            saveObj?.movieVolume = appDelegate.movieVolume
//            saveObj?.volumeM = appDelegate.volumeM
//            saveObj?.volumeMstatus = appDelegate.volumeMstatus
//            saveObj?.volumeVstatus = appDelegate.volumeVstatus
//            saveObj?.soundNum = appDelegate.soundNum
//            saveObj?.movieNum = appDelegate.movieNum
//            saveObj?.pickerView1Ini = appDelegate.pickerView1Ini
//            saveObj?.pickerView2Ini = appDelegate.pickerView2Ini
//        }
//    }
//}
