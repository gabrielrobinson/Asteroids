//
//  ProjectileView.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/20/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class ProjectileView : UIView {
    var rotationTransformation: CGAffineTransform?
    var translationTransformation: CGAffineTransform?
    
    override init(frame: CGRect) {
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
        let path = UIBezierPath(ovalIn: self.bounds)
        UIColor.orange.setFill()
        path.fill()
        UIColor.yellow.setStroke()
        path.stroke()
    }
}
