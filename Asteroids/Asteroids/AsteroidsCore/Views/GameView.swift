//
//  GameView.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/12/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class GameView: UIView {
    var asteroidFieldView : AsteroidFieldView?
    var gameButtonPanelView : GameButtonPanelView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // set background color
        backgroundColor = .black
        
        //add asteroid field view
        asteroidFieldView = AsteroidFieldView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.maxY * 0.85), shipPosition: CGPoint(x: 0, y: 0))
        if let asteroidFieldView = asteroidFieldView {
            self.addSubview(asteroidFieldView)
        }
        
        // Add button panel to the bottom fifth of the view
        gameButtonPanelView = GameButtonPanelView(frame: CGRect(x: frame.minX + 0.05 * frame.width, y: frame.maxY * 0.85, width: 0.9 * frame.width, height: frame.maxY * 0.15))
        if let gameButtonPanelView = gameButtonPanelView {
            self.addSubview(gameButtonPanelView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
