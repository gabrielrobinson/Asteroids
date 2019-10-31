//
//  Ship.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/22/19.
//  Copyright © 2019 CS4530. All rights reserved.
//
import UIKit

class Ship: Codable {
    var angle: CGFloat
    var velocity: CGFloat
    var position: CGPoint
    
    init() {
        angle = 0
        velocity = 0
        position = CGPoint(x: 0, y: 0)
    }
}
