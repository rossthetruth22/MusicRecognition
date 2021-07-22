//
//  ViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 6/9/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioSession: AVAudioSession! = nil
    var recordSession: AVAudioRecorder! = nil
    var audioPlayer: AVAudioPlayer! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioSession = AVAudioSession.sharedInstance()

        do{
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true, options: [])
            //print(audioSession.)
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

    @IBAction func test(_ sender: Any) {
        
        //AudD.recognize()
        //ACRCloud.identify()
        
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
        
        ACRCloud.identify(fileToRecord)
        
    }
    
}

extension ViewController: AVAudioRecorderDelegate{
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("delegate")
        let theLink = recorder.url
        if flag{
            audioPlayer = try? AVAudioPlayer(contentsOf: theLink)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                print("audioPlaying")
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            }
        }
    }
}
