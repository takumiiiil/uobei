

import Foundation
import UIKit
import AVFoundation//オーディオがらみ
import AVKit

class Test: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let aaa = MasterViewController()
        let bbb = SplitViewController()
        
        let master = UINavigationController(rootViewController: aaa)
        let detail = UINavigationController(rootViewController: bbb)
        
        self.viewControllers = [master, detail]
        //画面を分割する
        self.preferredDisplayMode = .allVisible
    }
}
