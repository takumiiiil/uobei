import UIKit

class MakeBackgroundImage:UIImageView{
    
    func make(image:String="")->UIImageView{
        
        let imageView: UIImageView!
        let inputImage = CIImage(image: UIImage(named: image)!)

        imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(ciImage: inputImage!)
        
        return(imageView)
    }
    
}
