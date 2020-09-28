
import UIKit

class ViewSetting{
    func set(view:AnyObject,transition:AnyObject,_anime:Bool = false,_animation:UIModalTransitionStyle = .flipHorizontal) {
        let SViewController: UIViewController = transition as! UIViewController
        //アニメーションを設定する.
        SViewController.modalTransitionStyle = _animation
        //Viewの移動する.
        SViewController.modalPresentationStyle = .fullScreen
        view.present(SViewController, animated: _anime, completion: nil)
    }
}
