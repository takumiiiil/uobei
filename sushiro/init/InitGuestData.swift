//import RealmSwift
//
//class InitGuestData{
//    
//    let realm = try! Realm()
//    
//    func doInit(){
//        let obj = realm.objects(guestData.self).last
//        if obj != nil{
//            try! realm.write {
//                obj?.seatNum = ""
//                obj?.dish = 0
//                obj?.inTime = ""
//                obj?.outTime = ""
//                obj?.adultCount = ""
//                obj?.childCount = ""
//                obj?.seatType = ""
//            }
//    }else{
//            try! realm.write {
//                realm.add(guestData())}
//    }
//        try! realm.write {realm.add(allData())}
//    }
//    
//    func save(generation:String){
//        let obj = realm.objects(guestData.self).last
//        let allObj = realm.objects(allData.self).last
//        try! realm.write{
//            allObj?.inTime = obj!.inTime
//            allObj?.outTime = obj!.outTime
//            allObj?.adultCount = obj!.adultCount
//            allObj?.childCount = obj!.childCount
//            allObj?.dish = obj!.dish
//            allObj?.generation = generation
//            allObj?.seatNum = obj!.seatNum
//            allObj?.seatType = obj!.seatType
//        }
//    }
//}
