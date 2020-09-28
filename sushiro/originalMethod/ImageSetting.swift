import UIKit


class ImageSetting{
    func set(picture:String,view:AnyObject){
        // 画像を設定する.
        let myInputImage = CIImage(image: UIImage(named: picture)!)
        // ImageViewを.定義する.
        var myImageView: UIImageView!
        // UIImageViewを作成する.
        myImageView = UIImageView(frame: UIScreen.main.bounds)
        myImageView.image = UIImage(ciImage: myInputImage!)
        view.view.addSubview(myImageView)
    }
}
