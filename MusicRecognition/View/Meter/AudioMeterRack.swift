//
//  AudioMeterRack.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 9/1/21.
//

import UIKit

class AudioMeterRack: UIView {

    var meters = [MeterColumn]()
    var gradient:CAGradientLayer!
    var numberOfMeters:Int!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var color:[CGColor]!{
        didSet{
            setGradientColor(color)
        }
    }
    var rainbow:[CGColor]{
        let green = UIColor(red: 181.0/255.0, green: 239.0/255.0, blue: 206.0/255.0, alpha: 1.0).cgColor
        let yellow = UIColor(red: 251.0/255.0, green: 235.0/255.0, blue: 165.0/255.0, alpha: 1.0).cgColor
        let red = UIColor(red: 248.0/255.0, green: 195.0/255.0, blue: 185.0/255.0, alpha: 1.0).cgColor
        let colors = [green,yellow,red]
        return colors
    }
    
    var gray:[CGColor]{
        let lightGray = UIColor.lightGray.cgColor
        let gray = UIColor.gray.cgColor
        let white = UIColor.white.cgColor
        
        let colors = [gray,lightGray,white]
        return colors
    }
    
    func setGradientColor(_ color:[CGColor]){
        for meter in meters{
            meter.color = color
        }
    }
    
    func createMeters(_ number:Int){
    
        let space = CGFloat(4.0)
        let numberOfBars = CGFloat(number)
        let width = (self.bounds.width - (space * numberOfBars)) / numberOfBars
        
        var spaceSoFar = CGFloat(2.0)
        for num in 1...number{
            
            let x = self.bounds.minX + spaceSoFar
            let meterFrame = CGRect(x: x, y: self.bounds.maxY, width: width, height: -self.bounds.height)
          
            let meter = MeterColumn(20, meterFrame, gray)
            meter.name = "\(num)"
            self.layer.addSublayer(meter)
            meters.append(meter)
            
            spaceSoFar += (width + space)
              
        }
    }
    
    func addAnimations(_ index:Int, _ start:Int, _ end:Int, _ duration:Double){

        let currentMeter = meters[index]
        
        if currentMeter.animationParameters != nil{
            currentMeter.animationParameters.shouldRepeat = true
        }else{
            currentMeter.animationParameters = AnimationParameters(index: index, start: start, end: end, duration: duration)
        }
        
        guard let meterTicks = currentMeter.meterTicks else {return}
        for num in 0..<start{
            meterTicks[num].isHidden = false
        }
        for num in start..<meterTicks.count{
            meterTicks[num].isHidden = true
        }
        
        startAnimation(currentMeter.animationParameters, false)
        
    }
    
    private func startAnimation(_ parameters:AnimationParameters, _ reverse:Bool){
        
        let currentMeter = meters[parameters.index]
        guard let meterTicks = currentMeter.meterTicks else {return}
        
        //start..<end
        //0..1,2,3,4,5
       
        // Put your code which should be executed with a delay here

        let total = parameters.duration
        let ticksToAnimate = Double(parameters.end-parameters.start)
        let individualTime = Double(total)/ticksToAnimate
        
        //reverse is end-1...start
        //6-1, 6-2, 6-3, 6-4, 6-5
        
        var counter = 0
        for number in parameters.start..<parameters.end{
            var realIndex = number
            if reverse{
                realIndex = parameters.end-1-counter
            }
            let currentTick = meterTicks[realIndex]
            let currentAnimation = CABasicAnimation(keyPath: "hidden")
            let delay = individualTime * Double(counter)
            currentAnimation.beginTime = CACurrentMediaTime() + delay
            currentAnimation.duration = total/ticksToAnimate
            //currentAnimation.duration = 0.4
            currentAnimation.fromValue = currentTick.isHidden
            currentAnimation.toValue = !currentTick.isHidden
            currentAnimation.fillMode = .forwards
            //currentAnimation.rev = true
            currentAnimation.isRemovedOnCompletion = false
            currentAnimation.delegate = self
            currentAnimation.setValue(currentTick, forKey: "hide")
            if number == parameters.end-1{
                currentAnimation.setValue(parameters, forKey: "last")
            }
            currentTick.add(currentAnimation, forKey: nil)
            counter += 1
        }
        
    }
    
    func removeAnimations(){
        for meterColumn in 0..<meters.count{
            let meter = meters[meterColumn]
            let parameters = meter.animationParameters
            parameters?.shouldRepeat = false
//            let meterTicks = meters[meterColumn].meterTicks!
//            for tickIndex in 0..<meterTicks.count{
//                let layer = meterTicks[tickIndex] as
//                //layer.removeAllAnimations()
//            }
        }
    }

}

extension AudioMeterRack:CAAnimationDelegate{
    
    func animationDidStart(_ anim: CAAnimation) {
        guard let layer = anim.value(forKey: "hide") as? CALayer else{
            print("unable to find tick start in delegate")
            return
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let layer = anim.value(forKey: "hide") as? CALayer else{
            print("unable to find tick in delegate")
            return
        }
        layer.isHidden = !layer.isHidden
        //layer.removeAllAnimations()
        
        if let parameters = anim.value(forKey: "last") as? AnimationParameters{
            if parameters.shouldRepeat{
                startAnimation(parameters, !layer.isHidden)
            }
            
        }
    }
    
}
