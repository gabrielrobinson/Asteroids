//
//  Asteroid.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/22/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class Asteroid: Codable {
    var angle: CGFloat
    var velocity: CGFloat
    var size: CGFloat
    var sharded: Bool
    var position: CGPoint
    var originalPosition: CGPoint
    
    init(angle: CGFloat, velocity: CGFloat, position: CGPoint, size: CGFloat, isShard: Bool) {
        self.angle = angle
        self.velocity = velocity
        self.size = size
        self.sharded = isShard
        self.position = position
        self.originalPosition = position
    }
    
    func checkCollision(otherPosition: CGPoint, radius: CGFloat) -> Bool {
        return distanceBetweenCenters(otherPosition) <= (radius + size / 2)
    }
    
    func isShard() -> Bool {
        return sharded
    }
    
    func reloadPosition() {
        self.position = originalPosition
    }
    
    private func distanceBetweenCenters(_ otherPosition: CGPoint) -> CGFloat {
        let dx = otherPosition.x - position.x
        let dy = otherPosition.y - position.y
        return sqrt(dx * dx + dy * dy)
    }
}
