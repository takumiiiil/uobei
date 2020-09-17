import UIKit
import AVFoundation

class makeSound:AVAudioPlayer{
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    func make()->AVAudioPlayer{
        var audioPlayerInstance : AVAudioPlayer! = nil
        let soundFilePath = Bundle.main.path(forResource: "button01a", ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
        // 再生準備
        audioPlayerInstance.prepareToPlay()
        audioPlayerInstance.volume = appDelegate.volumeM
        return(audioPlayerInstance)
    }
}
