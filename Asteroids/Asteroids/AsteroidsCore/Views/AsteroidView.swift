//
//  AsteroidView.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/22/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

enum AsteroidNumber: Int {
    case ASTONE = 0
    case ASTTWO = 1
    case ASTTHREE = 2
    case ASTFOUR = 3
}

class AsteroidView : UIView {
    var rotationAngle: CGFloat
    var rotationTransformAngle: CGFloat
    
    var rotationTransformation: CGAffineTransform?
    var translationTransformation: CGAffineTransform?
    var asteroidNumber: AsteroidNumber?
    private var position: CGPoint = CGPoint(x: 0, y: 0)
    
    override init(frame: CGRect) {
        rotationAngle = 0
        rotationTransformAngle = CGFloat.random(in: -(CGFloat.pi / 64)...CGFloat.pi / 64)
        asteroidNumber = AsteroidNumber(rawValue: Int.random(in: 0...3))
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    convenience init(frame: CGRect, angle: CGFloat, position: CGPoint) {
        self.init(frame: frame)
        
        rotationTransformation = CGAffineTransform(rotationAngle: angle)
        translationTransformation = CGAffineTransform(translationX: position.x, y: position.y)
        setTransform()
    }
    
    func update(position: CGPoint) {
        self.position = position
        rotationAngle += rotationTransformAngle
        rotationTransformation = CGAffineTransform(rotationAngle: rotationAngle)
        translationTransformation = CGAffineTransform(translationX: position.x, y: position.y)
        setTransform()
    }
    
    private func setTransform() {
        guard let rotation = rotationTransformation, let translation = translationTransformation else {
            print("transformations should never not be set")
            exit(0)
        }
        transform = rotation.concatenating(translation)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if let asteroidNumber = asteroidNumber {
            switch asteroidNumber {
            case .ASTONE:
                drawAsteroidOne()
                break
            case .ASTTWO:
                drawAsteroidTwo()
                break
            case .ASTTHREE:
                drawAsteroidThree()
                break
            case .ASTFOUR:
                drawAsteroidFour()
                break
            }
            return
        }
        drawAsteroidOne()
    }
    
    func getPosition() -> CGPoint {
        return position
    }
    
    func drawAsteroidOne() {
            //// General Declarations
            let context = UIGraphicsGetCurrentContext()!
            
            //// Resize to Target Frame
            context.saveGState()
            context.scaleBy(x: frame.width / 240, y: frame.height / 120)
            
            
            //// Color Declarations
            let color = UIColor(red: 0.545, green: 0.271, blue: 0.075, alpha: 1.000)
            
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 7.8, y: 41.12))
            bezierPath.addCurve(to: CGPoint(x: 7.8, y: 15.32), controlPoint1: CGPoint(x: 4.02, y: 16.4), controlPoint2: CGPoint(x: 7.8, y: 15.32))
            bezierPath.addLine(to: CGPoint(x: 59.49, y: 9.95))
            bezierPath.addLine(to: CGPoint(x: 97.31, y: 19.62))
            bezierPath.addLine(to: CGPoint(x: 140.17, y: 15.32))
            bezierPath.addLine(to: CGPoint(x: 170.43, y: 3.5))
            bezierPath.addLine(to: CGPoint(x: 213.29, y: 27.14))
            bezierPath.addLine(to: CGPoint(x: 213.29, y: 55.09))
            bezierPath.addLine(to: CGPoint(x: 233.46, y: 59.39))
            bezierPath.addLine(to: CGPoint(x: 238.5, y: 92.71))
            bezierPath.addLine(to: CGPoint(x: 194.38, y: 98.08))
            bezierPath.addLine(to: CGPoint(x: 131.35, y: 107.75))
            bezierPath.addLine(to: CGPoint(x: 91.01, y: 118.5))
            bezierPath.addLine(to: CGPoint(x: 63.27, y: 98.08))
            bezierPath.addLine(to: CGPoint(x: 29.23, y: 112.05))
            bezierPath.addLine(to: CGPoint(x: 1.5, y: 59.39))
            bezierPath.addLine(to: CGPoint(x: 7.8, y: 41.12))
            bezierPath.addLine(to: CGPoint(x: 33.02, y: 33.59))
            color.setFill()
            bezierPath.fill()
            UIColor.black.setStroke()
            bezierPath.lineWidth = 5
            bezierPath.stroke()
            
            
            //// Bezier 2 Drawing
            let bezier2Path = UIBezierPath()
            bezier2Path.move(to: CGPoint(x: 31.5, y: 32.5))
            bezier2Path.addLine(to: CGPoint(x: 56.5, y: 60.5))
            color.setFill()
            bezier2Path.fill()
            UIColor.black.setStroke()
            bezier2Path.lineWidth = 5
            bezier2Path.stroke()
            
            context.restoreGState()
    }
    
    func drawAsteroidTwo() {
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        context.scaleBy(x: frame.width / 240, y: frame.height / 120)
        
        
        //// Color Declarations
        let color = UIColor(red: 0.545, green: 0.271, blue: 0.075, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 3.5, y: 14.87))
        bezierPath.addLine(to: CGPoint(x: 31.29, y: 4.5))
        bezierPath.addLine(to: CGPoint(x: 70.83, y: 14.87))
        bezierPath.addLine(to: CGPoint(x: 99.69, y: 9.69))
        bezierPath.addLine(to: CGPoint(x: 127.48, y: 17.99))
        bezierPath.addLine(to: CGPoint(x: 141.38, y: 30.43))
        bezierPath.addLine(to: CGPoint(x: 155.27, y: 9.69))
        bezierPath.addLine(to: CGPoint(x: 192.68, y: 9.69))
        bezierPath.addLine(to: CGPoint(x: 236.5, y: 17.99))
        bezierPath.addLine(to: CGPoint(x: 236.5, y: 46))
        bezierPath.addLine(to: CGPoint(x: 220.47, y: 65.71))
        bezierPath.addLine(to: CGPoint(x: 233.29, y: 94.75))
        bezierPath.addLine(to: CGPoint(x: 207.64, y: 115.5))
        bezierPath.addLine(to: CGPoint(x: 155.27, y: 87.49))
        bezierPath.addLine(to: CGPoint(x: 141.38, y: 115.5))
        bezierPath.addLine(to: CGPoint(x: 81.52, y: 108.24))
        bezierPath.addLine(to: CGPoint(x: 44.11, y: 72.97))
        bezierPath.addLine(to: CGPoint(x: 23.81, y: 94.75))
        bezierPath.addLine(to: CGPoint(x: 3.5, y: 30.43))
        bezierPath.addLine(to: CGPoint(x: 3.5, y: 14.87))
        bezierPath.close()
        color.setFill()
        bezierPath.fill()
        UIColor.black.setStroke()
        bezierPath.lineWidth = 5
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 141.5, y: 29.5))
        bezier2Path.addLine(to: CGPoint(x: 134.5, y: 46.5))
        color.setFill()
        bezier2Path.fill()
        UIColor.black.setStroke()
        bezier2Path.lineWidth = 5
        bezier2Path.stroke()
        
        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 43.5, y: 73.5))
        bezier3Path.addLine(to: CGPoint(x: 62.5, y: 64.5))
        color.setFill()
        bezier3Path.fill()
        UIColor.black.setStroke()
        bezier3Path.lineWidth = 5
        bezier3Path.stroke()
        
        context.restoreGState()
    }
    
    func drawAsteroidThree() {
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        context.scaleBy(x: frame.width / 240, y: frame.height / 120)
        
        
        //// Color Declarations
        let color = UIColor(red: 0.545, green: 0.271, blue: 0.075, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 25.5, y: 45.5))
        bezierPath.addCurve(to: CGPoint(x: 25.5, y: 11.5), controlPoint1: CGPoint(x: 14.5, y: 30.5), controlPoint2: CGPoint(x: 25.5, y: 11.5))
        bezierPath.addLine(to: CGPoint(x: 55.5, y: 4.5))
        bezierPath.addLine(to: CGPoint(x: 87.5, y: 19.5))
        bezierPath.addLine(to: CGPoint(x: 136.5, y: 7.5))
        bezierPath.addLine(to: CGPoint(x: 184.5, y: 27.5))
        bezierPath.addLine(to: CGPoint(x: 207.5, y: 7.5))
        bezierPath.addLine(to: CGPoint(x: 232.5, y: 89.5))
        bezierPath.addLine(to: CGPoint(x: 207.5, y: 104.5))
        bezierPath.addLine(to: CGPoint(x: 136.5, y: 104.5))
        bezierPath.addLine(to: CGPoint(x: 74.5, y: 98.5))
        bezierPath.addLine(to: CGPoint(x: 67.5, y: 69.5))
        bezierPath.addLine(to: CGPoint(x: 33.5, y: 89.5))
        bezierPath.addLine(to: CGPoint(x: 30.5, y: 62.5))
        bezierPath.addLine(to: CGPoint(x: 25.5, y: 45.5))
        bezierPath.addLine(to: CGPoint(x: 52.5, y: 45.5))
        bezierPath.addLine(to: CGPoint(x: 55.5, y: 50.5))
        color.setFill()
        bezierPath.fill()
        UIColor.black.setStroke()
        bezierPath.lineWidth = 5
        bezierPath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 55.5, y: 50.5))
        bezier2Path.addLine(to: CGPoint(x: 138.5, y: 50.5))
        UIColor.black.setStroke()
        bezier2Path.lineWidth = 5
        bezier2Path.stroke()
        
        context.restoreGState()
    }
    
    func drawAsteroidFour() {
        let context = UIGraphicsGetCurrentContext()!

        //// Resize to Target Frame
        context.saveGState()
        context.scaleBy(x: frame.width / 240, y: frame.height / 120)
        
        
        //// Color Declarations
        let color = UIColor(red: 0.545, green: 0.271, blue: 0.075, alpha: 1.000)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 10.5, y: 19.5))
        bezierPath.addCurve(to: CGPoint(x: 30.5, y: 9.5), controlPoint1: CGPoint(x: 30.5, y: 9.5), controlPoint2: CGPoint(x: 8.5, y: 12.5))
        bezierPath.addCurve(to: CGPoint(x: 85.5, y: 5.5), controlPoint1: CGPoint(x: 52.5, y: 6.5), controlPoint2: CGPoint(x: 85.5, y: 5.5))
        bezierPath.addLine(to: CGPoint(x: 129.5, y: 9.5))
        bezierPath.addCurve(to: CGPoint(x: 129.5, y: 9.5), controlPoint1: CGPoint(x: 129.5, y: 9.5), controlPoint2: CGPoint(x: 112.5, y: 13.5))
        bezierPath.addCurve(to: CGPoint(x: 146.5, y: 5.5), controlPoint1: CGPoint(x: 146.5, y: 5.5), controlPoint2: CGPoint(x: 139.5, y: 1.5))
        bezierPath.addCurve(to: CGPoint(x: 154.5, y: 9.5), controlPoint1: CGPoint(x: 153.5, y: 9.5), controlPoint2: CGPoint(x: 141.5, y: 9.5))
        bezierPath.addCurve(to: CGPoint(x: 172.5, y: 19.5), controlPoint1: CGPoint(x: 167.5, y: 9.5), controlPoint2: CGPoint(x: 172.5, y: 19.5))
        bezierPath.addLine(to: CGPoint(x: 183.5, y: 48.5))
        bezierPath.addLine(to: CGPoint(x: 198.5, y: 62.5))
        bezierPath.addLine(to: CGPoint(x: 187.5, y: 104.5))
        bezierPath.addLine(to: CGPoint(x: 146.5, y: 113.5))
        bezierPath.addLine(to: CGPoint(x: 95.5, y: 110.5))
        bezierPath.addLine(to: CGPoint(x: 89.5, y: 96.5))
        bezierPath.addLine(to: CGPoint(x: 73.5, y: 110.5))
        bezierPath.addLine(to: CGPoint(x: 22.5, y: 110.5))
        bezierPath.addLine(to: CGPoint(x: 10.5, y: 100.5))
        bezierPath.addLine(to: CGPoint(x: 10.5, y: 76.5))
        bezierPath.addLine(to: CGPoint(x: 22.5, y: 44.5))
        bezierPath.addLine(to: CGPoint(x: 10.5, y: 19.5))
        bezierPath.addLine(to: CGPoint(x: 65.5, y: 31.5))
        color.setFill()
        bezierPath.fill()
        UIColor.black.setStroke()
        bezierPath.lineWidth = 5
        bezierPath.stroke()
        
        context.restoreGState()
    }
}
