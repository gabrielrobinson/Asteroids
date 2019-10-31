//
//  GameModel.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/19/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

enum Boundary: Int {
    case top = 0
    case bottom = 1
    case left = 2
    case right = 3
}

class Game: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case leftBoundary
        case rightBoundary
        case topBoundary
        case bottomBoundary
        case asteroidsGenerated
        case projectileCount
        case waveNumber
        case numberOfLives
        case ship
        case projectiles
        case asteroids
        case playersScore
        case asteroidSpeedIncrease
    }
    
    var viewProtocols: UpdateViewProtocols?
    var leftBoundary: CGFloat?
    var rightBoundary: CGFloat?
    var topBoundary: CGFloat?
    var bottomBoundary: CGFloat?
    
    let twoPi: CGFloat
    let piHalves: CGFloat
    var asteroidsGenerated: Bool

    var asteroidsCount = 0
    var projectileCount = 0
    var playersScore = 0
    var waveNumber = 1
    var numberOfLives = 3
    var asteroidSpeedIncrease: CGFloat
    
    var ship: Ship
    var shipsPreviousAngle: CGFloat?
    var projectiles: [Int: Projectile]
    var asteroids: [Int: Asteroid]
    var updateLock = NSLock()
    
    init(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat, protocols: UpdateViewProtocols) {
        leftBoundary = left
        rightBoundary = right
        topBoundary = top
        bottomBoundary = bottom
        ship = Ship()
        projectiles = [Int: Projectile]()
        asteroids = [Int: Asteroid]()
        viewProtocols = protocols
        
        twoPi = 2 * CGFloat.pi
        piHalves = CGFloat.pi / 2
        asteroidsGenerated = false
        
        projectileCount = 0
        waveNumber = 1
        numberOfLives = 3
        asteroidSpeedIncrease = 0.0
        
        generateAsteroids()
    }
    
    // Decodes game model from json
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        leftBoundary = try values.decode(CGFloat.self, forKey: .leftBoundary)
        rightBoundary = try values.decode(CGFloat.self, forKey: .rightBoundary)
        topBoundary = try values.decode(CGFloat.self, forKey: .topBoundary)
        bottomBoundary = try values.decode(CGFloat.self, forKey: .bottomBoundary)
        ship = try values.decode(Ship.self, forKey: .ship)
        projectiles = try values.decode([Int: Projectile].self, forKey: .projectiles)
        asteroids = try values.decode([Int: Asteroid].self, forKey: .asteroids)
        asteroidsGenerated = try values.decode(Bool.self, forKey: .asteroidsGenerated)
        playersScore = try values.decode(Int.self, forKey: .playersScore)
        
        twoPi = 2 * CGFloat.pi
        piHalves = CGFloat.pi / 2
        
        projectileCount  = try values.decode(Int.self, forKey: .projectileCount)
        waveNumber = try values.decode(Int.self, forKey: .waveNumber)
        numberOfLives = try values.decode(Int.self, forKey:  .numberOfLives)
        asteroidSpeedIncrease = try values.decode(CGFloat.self, forKey: .asteroidSpeedIncrease)
    }
    
    // Encodes object into json
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(leftBoundary, forKey: .leftBoundary)
        try container.encode(rightBoundary, forKey: .rightBoundary)
        try container.encode(topBoundary, forKey: .topBoundary)
        try container.encode(bottomBoundary, forKey: .bottomBoundary)
        try container.encode(ship, forKey: .ship)
        try container.encode(projectiles, forKey: .projectiles)
        try container.encode(asteroids, forKey: .asteroids)
        try container.encode(waveNumber, forKey: .waveNumber)
        try container.encode(numberOfLives, forKey: .numberOfLives)
        try container.encode(projectileCount, forKey: .projectileCount)
        try container.encode(asteroidsGenerated, forKey: .asteroidsGenerated)
        try container.encode(playersScore, forKey: .playersScore)
        try container.encode(asteroidSpeedIncrease, forKey: .asteroidSpeedIncrease)
    }
    
    // sets the view protocol in the case that the game state is decoded from json
    func set(viewProtocols: UpdateViewProtocols) {
        self.viewProtocols = viewProtocols
        guard let viewProtocols = self.viewProtocols else {
            exit(0)
        }
        
        for el in asteroids {
            viewProtocols.addAsteroid(id: el.key, position: el.value.position, angle: el.value.angle
                , size: el.value.size)
        }
        
        for el in projectiles {
            viewProtocols.addProjectile(id: el.key, angle: el.value.angle, position: el.value.position)
        }
        
        viewProtocols.updateLivesNumber(num: numberOfLives)
        viewProtocols.updateScore(count: playersScore)
        viewProtocols.updateShip(angle: ship.angle)
        viewProtocols.updateShipPosition(position: ship.position, isThrusting: false, false)
    }
    
    // turns the ship by the specified angle. The angle passed should be in degrees
    // and is then transformed into radians.
    func turnShip(angle: CGFloat) {
        ship.angle += degreesToRadians(angle)
        if ship.angle > twoPi {
            ship.angle -= twoPi
        } else if ship.angle < 0 {
            ship.angle += twoPi
        }
        if let viewProtocols = viewProtocols {
            viewProtocols.updateShip(angle: ship.angle)
        }
    }
    
    // increases the ve
    func accelerateShip(_ accelerationRate: CGFloat) {
        var shipsTransformationAngle: CGFloat
        if accelerationRate < 0 {
            if let shipsPreviousAngle = shipsPreviousAngle{
                shipsTransformationAngle = shipsPreviousAngle
            } else {
                shipsPreviousAngle = ship.angle
                shipsTransformationAngle = ship.angle
            }
        } else {
            shipsTransformationAngle = ship.angle
            shipsPreviousAngle = ship.angle
        }
        // if the acceleration is less than zero or the velocity
        // is less than zero we can return early
        if accelerationRate < 0 && ship.velocity <= 0 { return }
        // increment the ships velocity by the acceleration rate
        if (ship.velocity <= 10.3 && accelerationRate > 0) || accelerationRate < 0 {
            ship.velocity += accelerationRate
        }
        // calculate ships delta vector based on its velocity and angle
        let delta = calculateDelta(velocity: ship.velocity, angle: shipsTransformationAngle - piHalves)
        // enforce a wrap around effect if the ship goes out of the boundaries
        let changeVector = checkWrapAround(delta: delta, position: ship.position)
        // change the position of the ship based upon the delta vector
        ship.position.x += changeVector.dx
        ship.position.y += changeVector.dy
        // let the view protocol know to update the view
        if let viewProtocols = viewProtocols {
            viewProtocols.updateShipPosition(position: ship.position, isThrusting: accelerationRate > 0, false)
        }
    }
    
    // adds a projectile to the model with the current velocity of the ship plus seven, traveling in the direction
    // that the ship is travelling.
    func fireProjectile() {
        projectiles[projectileCount] = Projectile(angle: ship.angle, velocity: ship.velocity + 7, position: ship.position)
        if let viewProtocols = viewProtocols, let projectile = projectiles[projectileCount] {
            print("ships angle: \(ship.angle), projectiles angle: \(projectile.angle)")
            viewProtocols.addProjectile(id: projectileCount, angle: projectile.angle, position: projectile.position)
        }
        
        // only allow 500 projectiles at a time
        if projectileCount == 500 {
            projectileCount = 0
        } else {
            projectileCount += 1
        }
    }
    
    func updateProjectileStates() {
        let copy = projectiles
        for el in copy {
            if let projectile = projectiles[el.key] {
                let change = calculateDelta(velocity: el.value.velocity, angle: el.value.angle - piHalves)
                projectile.position.x += change.dx
                projectile.position.y += change.dy
                
                print("projectile <x, y> : < \(projectile.position.x), \(projectile.position.y)>")
                print("left boundary : \(leftBoundary!)")
                let outOfBounds = projectileOutOfBounds(projectile: projectile)
                if outOfBounds {
                    if let idx = projectiles.index(forKey: el.key), let viewProtocols = viewProtocols {
                        viewProtocols.removeProjectile(id: el.key)
                        projectiles.remove(at: idx)
                    }
                } else if let viewProtocols = viewProtocols {
                    viewProtocols.updateProjectile(id: el.key, position: projectile.position)
                }
            }
        }
    }
    
    // iterates over each asteroid and updates their position based upon their velocity, and
    // their direction of travel. This function also changes the position if the asteroid is outside
    // the game boundaries so that a wrap around can occur if need be.
    //
    // Finally, this function checks for collisions with other objects in the game, including projectiles
    // and the ship.
    func updateAsteroidStates() {
        if !asteroidsGenerated { return }
        updateLock.lock()
        let copyAsteroids = asteroids
        for asteroidEl in copyAsteroids {
            if let asteroid = asteroids[asteroidEl.key] {
                
                // check for collisions with projectiles
                var collidedWithProjectile = false
                let copyProjectiles = projectiles
                for projectileEl in copyProjectiles {
                    if asteroid.checkCollision(otherPosition: projectileEl.value.position, radius: Constants.boltWidth / 2) {
                        playersScore += 1
                        // remove asteroid
                        if let viewProtocols = viewProtocols {
                            
                            viewProtocols.removeAsteroid(id: asteroidEl.key)
                            viewProtocols.removeProjectile(id: projectileEl.key)
                            if let idx = asteroids.index(forKey: asteroidEl.key) {
                                asteroids.remove(at: idx)
                            }
                            if let idx = projectiles.index(forKey: projectileEl.key) {
                                projectiles.remove(at: idx)
                            }
                            
                            viewProtocols.updateScore(count: playersScore)
                            // todo if there is time:
                            // spawning more asteroids causes issues where asteroids wil freeze in the view
                            if !asteroid.isShard() {

                                let velocity = (CGFloat.pi  * asteroid.size / 2 * asteroid.size / 2 * asteroid.velocity + Constants.boltWidth * Constants.boltHeight * projectileEl.value.velocity) / 2500
                                
                                createAsteroid(id: asteroidsCount, asteroid.position, velocity, projectileEl.value.angle + CGFloat.pi / 4, asteroid.size / 4 + 15, isShard: true)
                                asteroidsCount += 1
                                
                                createAsteroid(id: asteroidsCount, asteroid.position, velocity, projectileEl.value.angle + 3 * CGFloat.pi / 4, asteroid.size / 4 + 15, isShard: true)
                                asteroidsCount += 1
                                
                                createAsteroid(id: asteroidsCount, asteroid.position, velocity, projectileEl.value.angle +  5 * CGFloat.pi / 4, asteroid.size / 4 + 15, isShard: true)
                                asteroidsCount += 1
                                
                                createAsteroid(id: asteroidsCount, asteroid.position, velocity, projectileEl.value.angle + 7 * CGFloat.pi / 4, asteroid.size / 4 + 15, isShard: true)
                                asteroidsCount += 1
                            }
                        }
                        
                        // add 4 smaller ones going in different directions
                        collidedWithProjectile = true
                        break
                    }
                }
                
                if collidedWithProjectile { continue }
                
                // check for collisions with the ship
                if asteroid.checkCollision(otherPosition: ship.position, radius: Constants.shipSize / 2) {
                    // stop game wait a few seconds respaw the ship
                    // set ships position, and velocity to 0
                    numberOfLives -= 1
                    ship.position = CGPoint(x: 0.0, y: 0.0)
                    ship.angle = 0.0
                    ship.velocity = 0.0
                    
                    if let viewProtocols = viewProtocols {
                        viewProtocols.updateLivesNumber(num: numberOfLives)
                        viewProtocols.updateShipPosition(position: ship.position, isThrusting: false, true)
                        viewProtocols.updateShip(angle: ship.angle)
                    
                    }
                    reloadAsteroidPositions()
                    
                    if numberOfLives == 0 {
                        if let viewProtocols = viewProtocols {
                            viewProtocols.gameOver()
                        }
                    }
                }
                
                let change = checkWrapAround(delta: calculateDelta(velocity: asteroidEl.value.velocity, angle: asteroidEl.value.angle - piHalves), position: asteroid.position)
                asteroid.position.x += change.dx
                asteroid.position.y += change.dy
                
                print("asteroid <x, y> : < \(asteroid.position.x), \(asteroid.position.y)>")
                print("left boundary : \(leftBoundary!)")
                if let viewProtocols = viewProtocols {
                    viewProtocols.updateAsteroid(id: asteroidEl.key, position: asteroid.position)
                }
            }
        }

        
        updateLock.unlock()
        
        if asteroids.count == 0 {
            newWave()
        }
        
    }
    
    // Iterates over all asteroids and returns them to their original positions. Used when
    // when the players ship dies, and a respawn is to occur
    func reloadAsteroidPositions() {
        for asteroid in asteroids {
            asteroid.value.reloadPosition()
            if let viewProtocols = viewProtocols {
                viewProtocols.updateAsteroid(id: asteroid.key, position: asteroid.value.position)
            }
        }
    }
    
    
    // creates asteroids  when a wave begins. the number of asteroids is the save as the wave number
    // asteroids are placed in random positions on the game boundary, with a random velocity, and a random
    // direction of travel
    func generateAsteroids() {
        updateLock.lock()
        if let left = leftBoundary, let right = rightBoundary, let top = topBoundary, let bottom = bottomBoundary {
            let numAsteroids = waveNumber
            for i in 0...numAsteroids-1 {
                let boundary = Boundary(rawValue: Int.random(in: 0...3))!
                var xCoordinate: CGFloat = 0.0
                var yCoordinate: CGFloat = 0.0
                switch boundary {
                case .top:
                    // generate the x coordinate and use the top boundary as the y coordinate
                    xCoordinate = CGFloat.random(in: left...right)
                    yCoordinate = top
                    // generate random velocity in the positive y direction
                    break
                case .bottom:
                    // generate the x coordinate and use the bottom boundary as the y coordinate
                    xCoordinate = CGFloat.random(in: left...right)
                    yCoordinate = bottom
                    // generate random velocity in the negative y direction
                    break
                case .left:
                    // generate the y coordinate and use the left boundary as the x coordinate
                    yCoordinate = CGFloat.random(in: top...bottom)
                    xCoordinate = left
                    break
                case .right:
                    // generate the y coordinate and use the right boundary as the x coordinate
                    yCoordinate = CGFloat.random(in: top...bottom)
                    xCoordinate = right
                    // generate random velocity in the negative x direction
                    break
                }
                
                let velocity = CGFloat.random(in: (0.1+asteroidSpeedIncrease)...(1+asteroidSpeedIncrease))
                let angle = CGFloat.random(in: 0.0...twoPi)
                let size = CGFloat.random(in: 50.0...100.0)
                createAsteroid(id: asteroidsCount, CGPoint(x: xCoordinate, y: yCoordinate), velocity, angle, size, isShard: false)
                asteroidsCount += 1
            }
            asteroidsGenerated = true
        }
        updateLock.unlock()
    }
    
    // creates an asteroid with the specified id, position, velcoicty, angle, and size. Invokes the view protocol to add a asteroid
    func createAsteroid(id: Int, _ position: CGPoint, _ velocity: CGFloat, _ angle: CGFloat, _ size: CGFloat, isShard: Bool) {
        asteroids[id] = Asteroid(angle: angle, velocity: velocity, position: position, size: size, isShard: isShard)
        guard let asteroid = asteroids[id] else {
            print("asteroid should never be nil")
            exit(0)
        }
        if let viewProtocols = viewProtocols {
            viewProtocols.addAsteroid(id: id, position: asteroid.position, angle: asteroid.angle, size: asteroid.size)
        }
    }
    
    // calculates a change of position vector based upon the angle and velocity of the object.
    func calculateDelta(velocity: CGFloat, angle: CGFloat) -> CGVector {
        let deltaX = velocity * cos(angle)
        let deltaY = velocity * sin(angle)
        return CGVector(dx: deltaX, dy: deltaY)
    }
    
    func hasAsteroids() -> Bool {
        return asteroidsGenerated
    }
    
    // changes the position of the object based upon the position and the direction of travel
    private func checkWrapAround(delta: CGVector, position: CGPoint)->CGVector {
        // Don't let a ship go any further than the screen boundaries.
        if let leftBoundary = leftBoundary,
            let rightBoundary = rightBoundary,
            let topBoundary = topBoundary,
            let bottomBoundary = bottomBoundary {
            
            var dx: CGFloat
            if position.x < leftBoundary - 15 && delta.dx < 0 {
                dx = abs(position.x) + rightBoundary - 10
            } else if position.x > rightBoundary + 15 && delta.dx > 0 {
                dx = -position.x + leftBoundary + 10
            } else {
                dx = delta.dx
            }
            
            var dy: CGFloat
            if position.y < topBoundary - 15 && delta.dy < 0 {
                dy = abs(position.y) + bottomBoundary - 10
            } else if position.y > bottomBoundary + 15 && delta.dy > 0 {
                dy = -position.y + topBoundary + 10
            } else {
                dy = delta.dy
            }
            
            return CGVector(dx: dx, dy: dy)
        }
        
        return delta
    }
    
    // checks to see if a projectile is out of bounds so that it can be removed
    // if it is
    private func projectileOutOfBounds(projectile: Projectile) -> Bool {
        if let left = leftBoundary,
            let right = rightBoundary,
            let top = topBoundary,
            let bottom = bottomBoundary {
            
            if projectile.position.x < left - 10 {
                return true
            } else if projectile.position.x > right + 10 {
                return true
            }
            
            if projectile.position.y < top - 10 {
                return true
            } else if projectile.position.y > bottom + 10 {
                return true
            }
        }
        return false
    }
    
    // creates  a new wave by incrementing the wave number, the number of lives,
    // temporarily setting the asteroidsGenerate flag to halt updates, updates the view,
    // adn finally invokes generateAsteroids()
    private func newWave() {
        asteroidsCount = 0
        waveNumber += 1
        numberOfLives += 1
        
        if waveNumber % 5 == 0 {
            asteroidSpeedIncrease += 0.025
        }
        
        self.asteroidsGenerated = false
        if let viewProtocols = viewProtocols {
            viewProtocols.updateLivesNumber(num: numberOfLives)
        }
        generateAsteroids()
    }
    
    // takes an angle in degrees and returns the angle in radians
    private func degreesToRadians(_ angle: CGFloat)->CGFloat {
        return angle * CGFloat.pi / 180
    }
}

