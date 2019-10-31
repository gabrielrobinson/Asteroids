//
//  Projectile.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/22/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class Projectile: Codable {
    var angle: CGFloat
    var velocity: CGFloat
    var position: CGPoint
    
    init(angle: CGFloat, velocity: CGFloat, position: CGPoint) {
        self.angle = angle
        self.velocity = velocity
        self.position = position
    }
}
