//
//  MeterColumn.swift
//  MusicRecognition
//
//  Created by Royce Reynolds on 8/22/21.
//

import UIKit

class MeterColumn: CAGradientLayer {
    
    private var numberOfTicks:Int!
    var meterTicks:[CALayer]!
    private var tickMask:CALayer!
    
    var animationParameters:AnimationParameters!
    
    var color:[CGColor]!{
        didSet{
            if self.colors != nil{
                let animation = CABasicAnimation(keyPath: "colors")
                animation.fromValue = self.colors
                animation.toValue = color
                animation.duration = 0.5
                animation.fillMode = .forwards
                animation.beginTime = CACurrentMediaTime()
                animation.isRemovedOnCompletion = true
                animation.delegate = self
                animation.setValue(self, forKey: "remove")
                self.add(animation, forKey: nil)
            }
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
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    init(_ ticks:Int, _ frame:CGRect, _ color:[CGColor]){
        super.init()
        self.frame = frame
        self.numberOfTicks = ticks
        self.color = color
        createGradientLayer()
        rotateGradient()
        meterTicks = [CALayer]()
        self.tickMask = createTickLayerMask()
        self.mask = tickMask
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
//    let space = CGFloat(4.0)
//    let number = 8
//    let numberOfBars = CGFloat(number)
//    let width = (containerView.bounds.width - (space * numberOfBars)) / numberOfBars
//    let sizeOfBars = CGSize(width: width, height: containerView.frame.height)
    
    private func createGradientLayer(){

        self.colors = color
        let locations: [NSNumber] = [0.0, 0.55, 1.0]
        self.locations = locations
        self.startPoint = CGPoint(x: 0.5, y: 0)
        self.endPoint = CGPoint(x: 0.5, y: 1)
    }
    
    private func rotateGradient(){
  
        let degrees = 180.0
        let radians = CGFloat(degrees * Double.pi / 180)
        self.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        
    }
    
    func createTickLayerMask() -> CALayer{
        let layer = CALayer()
        layer.frame = self.bounds
        
        let tickSpace = CGFloat(3.0)
        let tickNumberOfBars = CGFloat(numberOfTicks)
        let tickWidth = layer.bounds.width - 2.0
        let tickHeight = (self.bounds.height - (tickSpace * tickNumberOfBars)) / tickNumberOfBars
        let space = CGFloat(3.0)
        
        var tickSpaceSoFar = CGFloat(0.0)
        
        for current in 1...numberOfTicks{

            let tickX = layer.bounds.minX

            let rect = CGRect(x: tickX, y: layer.bounds.minY + tickSpaceSoFar, width: tickWidth, height: tickHeight)
            let tickLayer = CAShapeLayer()
            tickLayer.path = CGPath(roundedRect: rect, cornerWidth: CGFloat(0.5), cornerHeight: CGFloat(0.5), transform: nil)
            tickLayer.name = "\(current)"
          
            
            layer.addSublayer(tickLayer)
            meterTicks.append(tickLayer)
            tickSpaceSoFar += space + tickHeight
        }
        
        return layer
        
    }
    

}

extension MeterColumn:CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        self.removeAllAnimations()
        self.colors = color 
    }
}
