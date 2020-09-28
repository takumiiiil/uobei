import UIKit
import RealmSwift

class AllData:Object{
    @objc dynamic var seatNum = ""
    @objc dynamic var inTime = ""
    @objc dynamic var outTime = ""
    @objc dynamic var adultCount = ""
    @objc dynamic var childCount = ""
    @objc dynamic var seatType = ""
    @objc dynamic var dish = 0
    @objc dynamic var generation = ""
    
    
    func doInit(){
        let realm = try! Realm()
        let obj = realm.objects(GuestData.self).last
        if obj != nil{
            try! realm.write {
                obj?.seatNum = ""
                obj?.dish = 0
                obj?.inTime = ""
                obj?.outTime = ""
                obj?.adultCount = ""
                obj?.childCount = ""
                obj?.seatType = ""
            }
        }else{
            try! realm.write {
                realm.add(GuestData())
            }
        }
        try! realm.write {
            realm.add(AllData())
        }
    }
    
    func save(generation:String){
        let realm = try! Realm()
        let obj = realm.objects(GuestData.self).last
        let allObj = realm.objects(AllData.self).last
        try! realm.write{
            allObj?.inTime = obj!.inTime
            allObj?.outTime = obj!.outTime
            allObj?.adultCount = obj!.adultCount
            allObj?.childCount = obj!.childCount
            allObj?.dish = obj!.dish
            allObj?.generation = generation
            allObj?.seatNum = obj!.seatNum
            allObj?.seatType = obj!.seatType
        }
    }
}


