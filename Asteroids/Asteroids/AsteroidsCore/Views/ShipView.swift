//
//  ShipView.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/13/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class ShipView : UIView {
    private var _shipsTranslationTransformation: CGAffineTransform?
    private var _shipsRotationTransformation: CGAffineTransform?
    var _position: CGPoint?
    var _path: UIBezierPath?
    
    // overloaded init
    // sets background color to black
    // should change background to some image
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
    }
    
    // convenience init sets the translation, and rotation transformations
    // based upon the angle (CGFloat), and position (CGPoint) passed as arguments
    convenience init(frame: CGRect, position: CGPoint, angle: CGFloat) {
        self.init(frame: frame)
        
        _position = position
        _shipsTranslationTransformation = CGAffineTransform(translationX: position.x, y: position.y)
        _shipsRotationTransformation = CGAffineTransform(rotationAngle: angle)
        setTransform()
    }
    
    // still dont know what this done
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // updates the angle transformation of the ship
    func update(angle: CGFloat) {
        _shipsRotationTransformation = CGAffineTransform(rotationAngle: angle)
        setTransform()
    }
    
    // updates position transformation of the ship
    func update(position: CGPoint) {
        self._position = position
        _shipsTranslationTransformation = CGAffineTransform(translationX: position.x, y: position.y)
        setTransform()
    }
    
    // changes the transformation of the view
    private func setTransform() {
        guard let translation = _shipsTranslationTransformation,
            let rotation = _shipsRotationTransformation else {
            print("This should never happen. Ships transformations are non existant.")
            exit(0)
        }
        
        transform = rotation.concatenating(translation)
    }
    
    // Draws ship
    override func draw(_ rect: CGRect) {
        self.createTriangle()
    }

    // Draws triangle, which is the ship
    func createTriangle() {
        _path = UIBezierPath()
        if let path = _path {
            path.move(to: CGPoint(x: self.frame.width/2, y: 0.0))
            path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            path.close()
            
            UIColor.red.setStroke()
            path.stroke()
            
            UIColor.lightGray.setFill()
            path.fill()
        }
    }
    
    func getPosition() -> CGPoint {
        if let position = _position {
            return position
        }
        return CGPoint(x: 0, y: 0)
    }
}
