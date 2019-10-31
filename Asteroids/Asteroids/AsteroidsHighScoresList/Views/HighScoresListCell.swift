//
//  HighScoresListCell.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/12/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class HighScoresListCell: UITableViewCell {
    
    static var count = 0
    static let lock = NSLock()
    private var playerNameLabel: UILabel
    private var waveNumberLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        playerNameLabel = UILabel()
        playerNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        playerNameLabel.textColor = UIColor.white
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        waveNumberLabel = UILabel()
        waveNumberLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        waveNumberLabel.textColor = UIColor.white
        waveNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.black
        addSubview(playerNameLabel)
        addSubview(waveNumberLabel)
        
        let views: [String:Any] = ["playerNameLabel": self.playerNameLabel, "waveNumberLabel": self.waveNumberLabel]
        
        
        // Vertical constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[playerNameLabel]", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[waveNumberLabel]", metrics: nil, views: views))
        
        // Horizontal constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[playerNameLabel]", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[waveNumberLabel]-|", metrics: nil, views: views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let increment: Void = {
        
        HighScoresListCell.lock.lock()
        
        defer{ HighScoresListCell.lock.unlock() }
        HighScoresListCell.count += 1
        
    }()
    
    deinit {
        
        HighScoresListCell.lock.lock()
        
        defer{ HighScoresListCell.lock.unlock() }
        HighScoresListCell.count -= 1
        
    }

    func setPlayerName(_ text: String) {
        
        self.playerNameLabel.text = "\(text)"
        self.setNeedsDisplay()
        
    }
    
    func setScore(_ number: Int) {
        
        self.waveNumberLabel.text = "Asteroids destroyed: \(String(number))"
        self.setNeedsDisplay()
        
    }
}
