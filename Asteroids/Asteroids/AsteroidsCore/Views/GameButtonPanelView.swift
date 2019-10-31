//
//  GameButtonPanelView.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/12/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit


class GameButtonPanelView: UIView {
    // Game control buttons
    var turnLeftButton = UIButton(type: UIButton.ButtonType.roundedRect)
    var turnRightButton = UIButton(type: UIButton.ButtonType.roundedRect)
    var accelerateButton = UIButton(type: UIButton.ButtonType.roundedRect)
    var fireButton = UIButton(type: UIButton.ButtonType.roundedRect)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        turnLeftButton.setTitle("Left", for: UIControl.State.normal)
        turnLeftButton.backgroundColor = UIColor.white
        turnLeftButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        turnLeftButton.layer.cornerRadius = 5
        turnLeftButton.layer.borderWidth = 1
        turnLeftButton.layer.borderColor = UIColor.white.cgColor
        
        turnRightButton.setTitle("Right", for: UIControl.State.normal)
        turnRightButton.backgroundColor = UIColor.white
        turnRightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        turnRightButton.layer.cornerRadius = 5
        turnRightButton.layer.borderWidth = 1
        turnRightButton.layer.borderColor = UIColor.white.cgColor
        
        accelerateButton.setTitle("Accelerate", for: UIControl.State.normal)
        accelerateButton.backgroundColor = UIColor.white
        accelerateButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        accelerateButton.layer.cornerRadius = 5
        accelerateButton.layer.borderWidth = 1
        accelerateButton.layer.borderColor = UIColor.white.cgColor
        
        fireButton.setTitle("Fire", for: UIControl.State.normal)
        fireButton.backgroundColor = UIColor.white
        fireButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        fireButton.layer.cornerRadius = 5
        fireButton.layer.borderWidth = 1
        fireButton.layer.borderColor = UIColor.white.cgColor
        
        // left button | acclerateion button | fire button | right button
        fireButton.frame = CGRect(x: 0, y: 0, width: self.frame.width * 0.25 - 2.5, height: 0.6 * self.frame.height)
        accelerateButton.frame = CGRect(x: fireButton.frame.maxX + 2.5, y: 0, width: self.frame.width * 0.25 - 2.5, height: 0.6 * self.frame.height)
        turnLeftButton.frame = CGRect(x: accelerateButton.frame.maxX + 2.5, y: 0, width: self.frame.width * 0.25 - 2.5, height: 0.6 * self.frame.height)
        turnRightButton.frame = CGRect(x: turnLeftButton.frame.maxX + 2.5, y: 0, width: self.frame.width * 0.25, height: 0.6 * self.frame.height)
        
        self.addSubview(turnLeftButton)
        self.addSubview(accelerateButton)
        self.addSubview(fireButton)
        self.addSubview(turnRightButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

