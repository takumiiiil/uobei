import UIKit

class Test: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let left = MasterViewController()
        let right = SplitViewController()
        
        let master = UINavigationController(rootViewController: left)
        let detail = UINavigationController(rootViewController: right)
        
        self.viewControllers = [master, detail]
        //画面を分割する
        self.preferredDisplayMode = .allVisible
    }
}
