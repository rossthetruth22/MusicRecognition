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
    @IBOutlet weak var containerView: UIView!
    weak var testAnimation:CALayer!
    @IBOutlet weak var vinylRecord: UIImageView!
    var vinylAnimator:UIViewPropertyAnimator!
    weak var tring:CALayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let gradientLayer = CAGradientLayer()
//        let green = UIColor(red: 181.0/255.0, green: 239.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
//        let yellow = UIColor(red: 251.0/255.0, green: 235.0/255.0, blue: 165.0/255.0, alpha: 1.0).cgColor
//        let red = UIColor(red: 248.0/255.0, green: 195.0/255.0, blue: 185.0/255.0, alpha: 1.0).cgColor
//        let colors = [green,yellow,red]
//        gradientLayer.colors = colors
//        let locations: [NSNumber] = [0.0, 0.55, 1.0]
//        gradientLayer.locations = locations
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        //gradientLayer.frame = gradient.bounds
        
        
        let space = CGFloat(4.0)
        let number = 8
        let numberOfBars = CGFloat(number)
        let width = (containerView.bounds.width - (space * numberOfBars)) / numberOfBars
        let sizeOfBars = CGSize(width: width, height: containerView.frame.height)
        
        //let layer = CALayer()
        var spaceSoFar = CGFloat(2.0)
        for num in 1...number{
            
            let gradientLayer = CAGradientLayer()
            let green = UIColor(red: 181.0/255.0, green: 239.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
            let yellow = UIColor(red: 251.0/255.0, green: 235.0/255.0, blue: 165.0/255.0, alpha: 1.0).cgColor
            let red = UIColor(red: 248.0/255.0, green: 195.0/255.0, blue: 185.0/255.0, alpha: 1.0).cgColor
            let colors = [green,yellow,red]
            gradientLayer.colors = colors
            let locations: [NSNumber] = [0.0, 0.55, 1.0]
            gradientLayer.locations = locations
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            
            let x = containerView.bounds.minX + spaceSoFar
            gradientLayer.frame = CGRect(x: x, y: containerView.bounds.maxY, width: width, height: -containerView.bounds.height)
            let degrees = 180.0
            let radians = CGFloat(degrees * Double.pi / 180)
            gradientLayer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
            let layer = CALayer()
            layer.name = "\(num)"
            let layerMask = CALayer()
            //layer.frame = CGRect(x: x, y: containerView.bounds.minY, width: width, height: containerView.bounds.height)
            layer.frame = gradientLayer.bounds
            layerMask.frame = CGRect(x: x, y: containerView.bounds.minY, width: width, height: containerView.bounds.height)
            let topCenter = CGPoint(x: layerMask.frame.midX, y: layerMask.frame.minY)
            layerMask.anchorPoint = CGPoint(x: 0.5, y: 0)
            layerMask.position = topCenter
            
            //layer.frame = CGRect(x: x, y: gradientLayer.bounds.maxY, width: width, height: -gradientLayer.bounds.height)
            if num == 4{
                //gradientLayer.frame = CGRect(x: x, y: containerView.bounds.minY/2, width: width, height: containerView.bounds.height/2)
//                let degrees = 180.0
//                let radians = CGFloat(degrees * Double.pi / 180)
//                gradientLayer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
                
//                let make = CATransform3DMakeScale(CGFloat(1.0), 0.5, 0)
//                layer.transform = make
                //layer.mask = layerMask
                //testAnimation = layerMask
                //testAnimation.bounds.size.height /= 2
                
                
            }
            
            
            let tickSpace = CGFloat(3.0)
            var tickNumber = 20
            let tickNumberOfBars = CGFloat(tickNumber)
            let tickWidth = layer.bounds.width - 2.0
            let tickHeight = (gradientLayer.bounds.height - (tickSpace * tickNumberOfBars)) / tickNumberOfBars
            
            if num == 4{
                //tickNumber = 14
                tring = layerMask
            }
            var tickSpaceSoFar = CGFloat(0.0)
            for bi in 1...tickNumber{
//                if num == 2{
//                    if bi < tickNumber-5{
//                        tickSpaceSoFar += space + tickHeight
//                        continue
//                    }
//                }else if num == 6{
//                    if bi < tickNumber-3{
//                        tickSpaceSoFar += space + tickHeight
//                        continue
//                    }
//                }
                
                let tickX = layer.bounds.minX
                //print(layer.bounds.minY + tickSpaceSoFar)
                let rect = CGRect(x: tickX, y: layer.bounds.minY + tickSpaceSoFar, width: tickWidth, height: tickHeight)
                let tickLayer = CAShapeLayer()
                tickLayer.path = CGPath(roundedRect: rect, cornerWidth: CGFloat(0.5), cornerHeight: CGFloat(0.5), transform: nil)
                tickLayer.name = "\(bi)"
                //tickLayer.backgroundColor = UIColor.blue.cgColor
                if num == 4{
                    //tickLayer.isHidden = true
                }
                layer.addSublayer(tickLayer)
                tickSpaceSoFar += space + tickHeight
            }
            
            containerView.layer.addSublayer(gradientLayer)
            if num == 4{

                containerView.layer.insertSublayer(layerMask, above: gradientLayer)
                layerMask.backgroundColor = layerMask.superlayer?.superlayer?.backgroundColor
            }
            //containerView.layer.insertSublayer(layerMask, above: gradientLayer)
            
            gradientLayer.mask = layer
            spaceSoFar += (width + space)
            
            
            
            //let layer = CALayer()
            //let x = containerView.bounds.minX + spaceSoFar
            //layer.frame = CGRect(x: x, y: containerView.bounds.minY, width: width, height: containerView.bounds.height)
            
//            let tickSpace = CGFloat(3.0)
//            let tickNumber = 20
//            let tickNumberOfBars = CGFloat(tickNumber)
//            let tickWidth = layer.bounds.width - 2.0
//            let tickHeight = (layer.bounds.height - (tickSpace * tickNumberOfBars)) / tickNumberOfBars
            
//            var tickSpaceSoFar = CGFloat(0.0)
//            for _ in 1...tickNumber{
//                let tickX = layer.bounds.minX
//                let rect = CGRect(x: tickX, y: layer.bounds.minY + tickSpaceSoFar, width: tickWidth, height: tickHeight)
//                let tickLayer = CAShapeLayer()
//                tickLayer.path = CGPath(roundedRect: rect, cornerWidth: CGFloat(0.5), cornerHeight: CGFloat(0.5), transform: nil)
//                //tickLayer.backgroundColor = UIColor.blue.cgColor
//                layer.addSublayer(tickLayer)
//                tickSpaceSoFar += space + tickHeight
//            }
            //gradientLayer.frame = layer.bounds
            //layer.addSublayer(gradientLayer)
            //layer.backgroundColor = UIColor.red.cgColor
            //containerView.layer.addSublayer(gradientLayer)
            //spaceSoFar += (width + space)
        }
        
        //gradient.layer.addSublayer(gradientLayer)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("animation height")
//        let height =  testAnimation.bounds.height
//        let height2 = testAnimation.bounds.size.height
//        UIView.animate(withDuration: 0.5) {
//            self.testAnimation.bounds.size.height -= height/2
//        } completion: { done in
//            print(self.testAnimation.bounds.size.height)
//            print(done)
//
        
        
        
        
//        UIView.animate(withDuration: 3.0, delay: 1.0, options: .curveLinear) {
//            for num in 1...14{
//                var notch = tring.sublayers?.filter($0.name == "\(num)")
//            }
//        } completion: { nice in
//            print("lets see!")
//        }


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
        
        //tring.bounds.size.height /= 4
//        print(self.tring.position)
//        UIView.animate(withDuration: 10.0, delay: 0.5, options: [.curveLinear, .autoreverse]) { [self] in
//                        self.tring.bounds.size.height -= 20
//            //print(self.tring.position)
//        } completion: { ross in
//            print(ross)
//        }


        
        
        //vinylAnimator = UIViewPropertyAnimator(duration: <#T##TimeInterval#>, curve: <#T##UIView.AnimationCurve#>, animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
        UIView.animate(withDuration: 1.8, delay: 0.0, options: [.curveLinear,.repeat]) {
            let degrees = 180.0
            let radians = CGFloat(degrees * Double.pi / 180)
            sender.view?.transform = CGAffineTransform(rotationAngle: radians)
            //sender.view?.layer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        } completion: { royce in
            print(royce)
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
        //akaud
        
        AudD.recognize(file: theLink) { [weak self] success, result, picURL in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //MARK: changing temporarily to allow nil musicbrainz. will populate later
            if success{
                let musicBrainz = result?.musicbrainz?.first?.releases.first
                
                var image = UIImage()
                if let url = picURL{
                    Musicbrainz.getPictureURL(musicBrainz!.releaseGroup.id) { picUrl, error in
                        //print(picUrl)
                        let newURLString = picUrl?.replacingOccurrences(of: "http:", with: "https:")
                        let callURL = URL(string: newURLString!)!
                        DispatchQueue.global().async {
                            var data:Data! = nil
                            //var image = UIImage()
                            do{
                                data = try Data(contentsOf: callURL)
                                image = UIImage(data: data)!
                            }catch{
                                print(error.localizedDescription)
                            }

                            DispatchQueue.main.async {
                                //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                //storyboard = UIStoryboard(name: "Main", bundle: nil)
                                self?.vinylRecord.layer.removeAllAnimations()
                                let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
                                songController.song = result
                                songController.image = image
                                self?.present(songController, animated: true, completion: nil)
                            }
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        self?.vinylRecord.layer.removeAllAnimations()
                        let songController = storyboard.instantiateViewController(identifier: "SongViewController") as! SongViewController
                        songController.song = result
                        songController.image = image
                        self?.present(songController, animated: true, completion: nil)
                    }
                }
            
                
                
                print("Got the release group \(musicBrainz?.releaseGroup.id)")
                
                
                
                
                do{
                    try FileManager.default.removeItem(at: theLink)
                    print("deleted file successfully")
                }catch{
                    print(error.localizedDescription)
                }
                
            }else{
                DispatchQueue.main.async {
                    self?.vinylRecord.layer.removeAllAnimations()
                    let noMatch = storyboard.instantiateViewController(identifier: "NoMatchController")
                    self?.present(noMatch, animated: true, completion: nil)
                    print("unable to identify")
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
        
//        do{
//            try FileManager.default.removeItem(at: theLink)
//            print("deleted file successfully")
//        }catch{
//            print(error.localizedDescription)
//        }
    }
    
}
