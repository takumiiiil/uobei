import UIKit
import RealmSwift

//realm作成 guest
class guestData:Object{
    @objc dynamic var seatNum = ""
    @objc dynamic var inTime = ""
    @objc dynamic var outTime = ""
    @objc dynamic var adultCount = ""
    @objc dynamic var childCount = ""
    @objc dynamic var seatType = ""
    @objc dynamic var dish = 0
}
