//
//  IdentifyViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/27/21.
//

import UIKit
import AVFoundation

class IdentifyViewController: UIViewController {
    
    var audioSession: AVAudioSession! = nil
    var recordSession: AVAudioRecorder! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioSession = AVAudioSession.sharedInstance()

        do{
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true, options: [])
            audioSession.requestRecordPermission { (answer) in
                if answer{
                    print("Permission true")
                }else{
                    print("Permission false")
                }
            }
        }catch{
            print("caught")
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func handleVinylTap(_ sender: UITapGestureRecognizer) {
        print("vinyl tapped")
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        
        var sequence = 1
        let fileToRecord = tempDir.appendingPathComponent("recording-\(sequence).m4a")
        print(fileToRecord.absoluteString)
        
        let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
        //recordSession: AVAudioRecorder! = nil
        
        do{
            recordSession = try AVAudioRecorder(url: fileToRecord, settings: settings)
            recordSession.delegate = self
            print(recordSession.prepareToRecord())
            //ecordSession.record(forDuration: 3.0)
            recordSession.record()
        }catch{
            print("couldn't")
        }
            
        //print(recordSession.isRecording)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.recordSession.stop()
        }
        //print("\n")
        //print(NSTemporaryDirectory())
        
    
//        let urls = fileManager.urls(for: .applicationSupportDirectory, in: .allDomainsMask)
        
//        for url in urls{
//            print("\(url)\n" )
//            let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//            print(contents)
//        }
        
        //ACRCloud.identify(fileToRecord)
        
        
    }
    

}

extension IdentifyViewController: AVAudioRecorderDelegate{
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        let theLink = recorder.url
        
        AudD.recognize(file: theLink) { success, result in
            if success{
                
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
                    songController.song = result
                    self.present(songController, animated: true, completion: nil)
                }
                
            }
        }
        //ACRCloud.identify(theLink)
        
//        if flag{
//            audioPlayer = try? AVAudioPlayer(contentsOf: theLink)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                print("audioPlaying")
//                self.audioPlayer.prepareToPlay()
//                self.audioPlayer.play()
//            }
//        }
        
        do{
            try FileManager.default.removeItem(at: theLink)
            print("deleted file successfully")
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
