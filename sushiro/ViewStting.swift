import UIKit

class viewSetting{
    func viewSet(view:UIViewController,anime:UIModalTransitionStyle) -> UIViewController{
        let SViewController: UIViewController = view
        //アニメーションを設定する.
        SViewController.modalTransitionStyle = anime
        //Viewの移動する.
        SViewController.modalPresentationStyle = .fullScreen
        return SViewController
    }
}
