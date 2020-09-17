import Foundation
import UIKit

class makeQrcode:UIImageView{
    func make(xv:Int,yv:Int,wv:Int,hv:Int,sum:String)->UIImageView{
        let qrImageView = UIImageView(frame: CGRect(x:CGFloat(xv), y: CGFloat(yv), width: CGFloat(wv), height: CGFloat(hv)))
        let str = sum
        let data = str.data(using: String.Encoding.utf8)!
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])!
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let qrImage = qr.outputImage!.transformed(by: sizeTransform)
        let context = CIContext()
        let cgImage = context.createCGImage(qrImage, from: qrImage.extent)
        let uiImage = UIImage(cgImage: cgImage!)
        // 作成したQRコードを表示
        qrImageView.contentMode = .scaleAspectFit
        qrImageView.image = uiImage
        return(qrImageView)
    }
}
