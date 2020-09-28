import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?
    var choise: Int = 0//メニュー選択
    var viewType: String = "アカウント"
    var history: [(name:String,num:Int)] = []//からの配列
    var touchVolume: Float = 0.5
    var movieVolume: Float = 0.5
    var scImage: UIImage?
    var qrStatus: String = "qr"
    var qrString: String = ""
    var volumeM: Float = 0.5
    var volumeV: Float = 0.5
    var volumeMstatus: String = "on"
    var volumeVstatus: String = "on"
    var soundNum: String = "button01a"
    var movieNum: String = "movie01"
    var pickerView1Ini: Int = 0
    var pickerView2Ini: Int = 0
    var maskFlag: Int = 100
    var maskFlag2: Int = 100
    var maskFlag3: Int = 100
    var geneMaskFlag: Int = 100
    var dishSum = 0
    var tagFlag2 = 0
    var passFlag = 0
    var counter = 0 //カウント用変数
    //メニュー関係
    var countType: [(k:Int,now:String)] = [
        (0,""),
        (0,""),
        (0,"")]
    var box: [(name: String, qty: Int ,view: String)] = [
        ("",0,"kara.png"),
        ("",0,"kara.png"),
        ("",0,"kara.png")]
    
    //商品選択後
    func st(sn:String,pn:String){
        if counter < 3{
            if box[0].name == ""{
                counter = 0
                box[counter].name = sn
                box[counter].qty = 1
                box[counter].view = pn
            }else if box[1].name == ""{
                counter = 1
                box[counter].name = sn
                box[counter].qty = 1
                box[counter].view = pn
            }else if box[2].name == ""{
                counter = 2
                box[counter].name = sn
                box[counter].qty = 1
                box[counter].view = pn
            }
            countType[0].now = "off"
            countType[1].now = "off"
            countType[2].now = "off"
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 起動直後に遷移する画面をRootViewControllerに指定する
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = Ticket()
    self.window?.makeKeyAndVisible()
    return true
    }
    func applicationWillResignActive(_ application: UIApplication) {
 
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

