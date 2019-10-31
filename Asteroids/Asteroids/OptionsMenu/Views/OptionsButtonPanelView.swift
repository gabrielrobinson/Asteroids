//
//  OptionsButtonPanelView.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/12/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit


class OptionsButtonPanelView: UIView {
    var asteroidsLabel = UILabel()
    var newGameButton = UIButton(type: UIButton.ButtonType.roundedRect)
    var loadGameButton = UIButton(type: UIButton.ButtonType.roundedRect)
    var highScoresButton = UIButton(type: UIButton.ButtonType.roundedRect)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        asteroidsLabel.text = "ASTEROIDS"
        asteroidsLabel.font = UIFont(name: "Futura-Bold", size: 48)!
        asteroidsLabel.textAlignment = .center
        asteroidsLabel.textColor = .green
        
        newGameButton.setTitle("New Game", for: UIControl.State.normal)
        newGameButton.backgroundColor = .clear
        newGameButton.layer.cornerRadius = 5
        newGameButton.layer.borderWidth = 1
        newGameButton.layer.borderColor = UIColor.white.cgColor
        newGameButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 24)!
        newGameButton.setTitleColor(.green, for: .normal)
        
        loadGameButton.setTitle("Resume Game", for: UIControl.State.normal)
        loadGameButton.backgroundColor = .clear
        loadGameButton.layer.cornerRadius = 5
        loadGameButton.layer.borderWidth = 1
        loadGameButton.layer.borderColor = UIColor.white.cgColor
        loadGameButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 24)!
        loadGameButton.setTitleColor(.green, for: .normal)

        highScoresButton.setTitle("View High Scores", for: UIControl.State.normal)
        highScoresButton.backgroundColor = .clear
        highScoresButton.layer.cornerRadius = 5
        highScoresButton.layer.borderWidth = 1
        highScoresButton.layer.borderColor = UIColor.white.cgColor
        highScoresButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 24)!
        highScoresButton.setTitleColor(.green, for: .normal)

        asteroidsLabel.frame = CGRect(x: 0, y: self.frame.maxY * 0.1, width: self.frame.maxX * 0.6, height: self.frame.maxY * 0.1)
        newGameButton.frame = CGRect(x: 0, y: asteroidsLabel.frame.maxY + 5, width: self.frame.maxX * 0.6, height: self.frame.maxY * 0.1)
        loadGameButton.frame = CGRect(x: 0, y: newGameButton.frame.maxY + 5, width: self.frame.maxX * 0.6, height: self.frame.maxY * 0.1)
        highScoresButton.frame = CGRect(x: 0, y: loadGameButton.frame.maxY + 5, width: self.frame.maxX * 0.6, height: self.frame.maxY * 0.1)
        
        self.addSubview(asteroidsLabel)
        self.addSubview(newGameButton)
        self.addSubview(loadGameButton)
        self.addSubview(highScoresButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
