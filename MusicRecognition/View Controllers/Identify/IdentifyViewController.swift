//
//  IdentifyViewController.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 7/27/21.
//

import UIKit
import AVFoundation
import CoreAudioKit

class IdentifyViewController: UIViewController {
    
    var audioSession: AVAudioSession! = nil
    var recordSession: AVAudioRecorder! = nil
    @IBOutlet weak var gradient: UIView!
    @IBOutlet weak var containerView: AudioMeterRack!
    weak var testAnimation:CALayer!
    @IBOutlet weak var vinylRecord: UIImageView!
    var vinylAnimator:UIViewPropertyAnimator!
    weak var tring:MeterColumn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.createMeters(8)
  

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
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        }else{
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startMeterAnimations()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.containerView.removeAnimations()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        containerView.removeAnimations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let test = URL(string: "http://coverartarchive.org/release/ed3997ee-0d66-429d-a7e3-455cea70e41b/22992272247-250.jpg")
//
//        let fileName = test!.lastPathComponent
//        let fileManager = FileManager.default
//
//        let caches = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//        var pictureDirectory = caches!.appendingPathComponent("Music Recognition").appendingPathComponent("Pictures")
//        let currentPath = pictureDirectory.appendingPathComponent("\(fileName)")
//        print(currentPath)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func willResignActive(){
        containerView.removeAnimations()
    }
    
    func startMeterAnimations(){
        containerView.color = containerView.gray
        containerView.addAnimations(0, 5, 15, 0.7)
        containerView.addAnimations(1, 2, 19, 1.0)
        containerView.addAnimations(2, 1, 8, 0.5)
        containerView.addAnimations(3, 0, 20, 0.73)
        containerView.addAnimations(4, 3, 10, 0.8)
        containerView.addAnimations(5, 4, 12, 0.75)
        containerView.addAnimations(6, 7, 16, 0.7)
        containerView.addAnimations(7, 2, 14, 0.65)
    }
    
    @IBAction func handleVinylTap(_ sender: UITapGestureRecognizer) {
        
        //vinylAnimator = UIViewPropertyAnimator(duration: <#T##TimeInterval#>, curve: <#T##UIView.AnimationCurve#>, animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
        containerView.color = containerView.rainbow
        UIView.animate(withDuration: 1.8, delay: 0.0, options: [.curveLinear,.repeat]) {
            let degrees = 180.0
            let radians = CGFloat(degrees * Double.pi / 180)
            sender.view?.transform = CGAffineTransform(rotationAngle: radians)
            //sender.view?.layer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        } completion: { royce in
            //print(royce)
            sender.view?.transform = .identity
        }

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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //akaud
        
//        AudD.recognize(file: theLink) { [weak self] success, result, picURL in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            //MARK: changing temporarily to allow nil musicbrainz. will populate later
//            if success{
//                let musicBrainz = result?.musicbrainz?.first?.releases.first
//
//                var image = UIImage()
//                if let url = picURL{
//                    //let music = Musicbrainz()
//                    let newURLString = url.replacingOccurrences(of: "http:", with: "https:")
//                    let callURL = URL(string: newURLString)!
//                    DispatchQueue.global().async {
//                        var data:Data! = nil
//                        //var image = UIImage()
//                        do{
//                            data = try Data(contentsOf: callURL)
//                            image = UIImage(data: data)!
//                        }catch{
//                            print(error.localizedDescription)
//                        }
//
//                        DispatchQueue.main.async {
//                            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            //storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            self?.vinylRecord.layer.removeAllAnimations()
//                            let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
//                            songController.song = result
//                            songController.image = image
//                            self?.present(songController, animated: true, completion: nil)
//                        }
//                    }
//
//
////                    music.getPictureURL(musicBrainz!.releaseGroup.id) { picUrl, error in
////                        print(picUrl)
////                        let newURLString = picUrl?.replacingOccurrences(of: "http:", with: "https:")
////                        let callURL = URL(string: newURLString!)!
////                        DispatchQueue.global().async {
////                            var data:Data! = nil
////                            //var image = UIImage()
////                            do{
////                                data = try Data(contentsOf: callURL)
////                                image = UIImage(data: data)!
////                            }catch{
////                                print(error.localizedDescription)
////                            }
////
////                            DispatchQueue.main.async {
////                                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
////                                //storyboard = UIStoryboard(name: "Main", bundle: nil)
////                                self?.vinylRecord.layer.removeAllAnimations()
////                                let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
////                                songController.song = result
////                                songController.image = image
////                                self?.present(songController, animated: true, completion: nil)
////                            }
////                        }
////                    }
//
//                }else{
//                    DispatchQueue.main.async {
//                        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        self?.vinylRecord.layer.removeAllAnimations()
//                        let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
//                        songController.song = result
//                        songController.image = image
//                        self?.present(songController, animated: true, completion: nil)
//                    }
//                }
//
//
//
//                print("Got the release group \(musicBrainz?.releaseGroup.id)")
//
//
//
//
//                do{
//                    try FileManager.default.removeItem(at: theLink)
//                    print("deleted file successfully")
//                }catch{
//                    print(error.localizedDescription)
//                }
//
//            }else{
//                DispatchQueue.main.async {
//                    self?.vinylRecord.layer.removeAllAnimations()
//                    let noMatch = storyboard.instantiateViewController(identifier: "NoMatchController")
//                    self?.present(noMatch, animated: true, completion: nil)
//                    print("unable to identify")
//                }
//
//            }
//        }
        //ACRCloud.identify(theLink)
        ACRCloud.identify(theLink) { [weak self] success, result, pictureURL in
            
            let dismissClosure:() -> Void = {
                self?.startMeterAnimations()
            }
            guard success == true else {
                DispatchQueue.main.async {
                    self?.containerView.removeAnimations()
                    self?.vinylRecord.layer.removeAllAnimations()
                    let noMatch = storyboard.instantiateViewController(identifier: "NoMatchController") as! NoMatchViewController
                    noMatch.dismissClosure = dismissClosure
                    self?.present(noMatch, animated: true, completion: nil)
                    print("unable to identify")
                }
                return
            }
            
            let picFetch = PictureFetch(pictureURL)
            let image = picFetch.image
            
            DispatchQueue.main.async {
                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //storyboard = UIStoryboard(name: "Main", bundle: nil)
                self?.containerView.removeAnimations()
                self?.vinylRecord.layer.removeAllAnimations()
                let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
                songController.songComponents = result!
                songController.image = image
                songController.dismissClosure = dismissClosure
                self?.present(songController, animated: true, completion: nil)
            }
            
//            var data:Data! = nil
//            if let url = pictureURL{
//                print(pictureURL)
//                                
//                var image = UIImage()
//                let newURLString = url.replacingOccurrences(of: "http:", with: "https:")
//                let callURL = URL(string: newURLString)!
//                let fileName = callURL.lastPathComponent
//                
//                DispatchQueue.global().async {
//                    var data:Data! = nil
//                    //var image = UIImage()
//                    do{
//                        data = try Data(contentsOf: callURL)
//                        image = UIImage(data: data)!
//                        //store image in Library/Caches/Pictures/
//
//                    }catch{
//                        print(error.localizedDescription)
//                    }
//
//                    DispatchQueue.main.async {
//                        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        //storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        self?.vinylRecord.layer.removeAllAnimations()
//                        let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
//                        songController.songComponents = result!
//                        songController.image = image
//                        self?.present(songController, animated: true, completion: nil)
//                    }
//                }
//            }else{
//                DispatchQueue.main.async {
//                    //let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    //storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    self?.vinylRecord.layer.removeAllAnimations()
//                    let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
//                    songController.songComponents = result!
//                    //songController.image = image
//                    self?.present(songController, animated: true, completion: nil)
//                }
//
//            }
        }
        
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

extension IdentifyViewController: CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //anim.
        
    }
}
