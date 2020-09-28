import UIKit


class makeBarcord:UIImageView{
    func make(string: String) -> UIImageView? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        guard let output = filter.outputImage else {
            return nil
        }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        let uiImage = UIImage(cgImage: cgImage, scale: 2.0, orientation: UIImage.Orientation.up)
        // 作成したバーコードを表示
        let barImageView = UIImageView(frame: CGRect(x:CGFloat(100), y: CGFloat(250), width: CGFloat(150), height: CGFloat(150)))
        barImageView.contentMode = .scaleAspectFit
        barImageView.image = uiImage
        return(barImageView)
    }
}
