//import RealmSwift
//class InitLogInData{
//    let realm = try! Realm()
//    func doInit(){
//        let obj = realm.objects(LogInData.self).last
//        if obj != nil{
//            try! realm.write {
//                obj?.name = ""
//                obj?.address = ""
//                obj?.phone = ""
//                obj?.mailAddress = ""
//                obj?.password = ""
//            }
//        }else{
//            try! realm.write {
//                realm.add(LogInData())}
//        }
//    }
//}
