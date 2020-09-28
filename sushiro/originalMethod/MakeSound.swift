import UIKit
import AVFoundation


class MakeSound:AVAudioPlayer{
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func make(soundNum:String)->AVAudioPlayer{
        var audioPlayerInstance : AVAudioPlayer! = nil
        let soundFilePath = Bundle.main.path(forResource: soundNum, ofType: "mp3")!
        let sound:URL = URL(fileURLWithPath: soundFilePath)
        do {
            audioPlayerInstance = try AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
        } catch {
            print("AVAudioPlayerインスタンス作成でエラー")
        }
         //再生準備
        audioPlayerInstance.prepareToPlay()
        audioPlayerInstance.volume = appDelegate.touchVolume
        return(audioPlayerInstance)
    }
}

