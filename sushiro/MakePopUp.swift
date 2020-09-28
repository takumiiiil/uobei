import UIKit

class MakePopUp:UIAlertController{
   
    func alert(title:String,view:AnyObject,_message:String = "",_time:Double = 0.5){
        
        let alertController: UIAlertController!
        alertController = UIAlertController(title: title,message:_message,preferredStyle: .alert)
        view.present(alertController, animated: true, completion:{
            DispatchQueue.main.asyncAfter(deadline: .now() + _time, execute: {
                view.dismiss(animated: true, completion: nil)
            })
        })
    }
}
