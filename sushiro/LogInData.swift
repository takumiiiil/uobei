import UIKit
import RealmSwift


class LogInData:Object{
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var phone = ""
    @objc dynamic var mailAddress = ""
    @objc dynamic var password = ""
    

    func doInit(){
        let realm = try! Realm()
        let obj = realm.objects(LogInData.self).last
        if obj != nil{
            try! realm.write {
                obj?.name = ""
                obj?.address = ""
                obj?.phone = ""
                obj?.mailAddress = ""
                obj?.password = ""
            }
        }else{
            try! realm.write {
                realm.add(LogInData())
            }
        }
    }
}


