//
//  AsteroidFieldView.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/13/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class AsteroidFieldView : UIView {
    var ship: ShipView?
    var projectileViews = [Int: ProjectileView]()
    var asteroidViews = [Int: AsteroidView]()
    var asteroidLock = NSLock()
    var projectileLock = NSLock()
    
    var scoreLabel = UILabel()
    var numLivesLabel = UILabel()
    
    let emitterLayer = CAEmitterLayer()
    var emitterTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, shipPosition: CGPoint = CGPoint(x: 0, y: 0), shipAngle: CGFloat = 0.0, score: Int = 0, numLives: Int = 3) {
        self.init(frame: frame)
        
        backgroundColor = UIColor.black
        ship = ShipView(frame: CGRect(x: frame.width / 2 - Constants.shipSize / 2 , y: frame.height / 2 - Constants.shipSize / 2, width: Constants.shipSize, height: Constants.shipSize), position: shipPosition, angle: shipAngle)
        if let ship = ship {
            // add ship as a subview
            addSubview(ship)
        }
        
        scoreLabel.frame = CGRect(x: 10, y: 10, width: 0.5 * self.frame.width, height: 100)
        scoreLabel.backgroundColor = UIColor.clear
        scoreLabel.textColor = UIColor.white
        scoreLabel.layer.zPosition = .greatestFiniteMagnitude
        scoreLabel.text = "Player's score: \(score)"
        addSubview(scoreLabel)
        
        numLivesLabel.frame = CGRect(x: frame.maxX - 150, y: 10, width: 0.5 * self.frame.width, height: 100)
        numLivesLabel.backgroundColor = UIColor.clear
        numLivesLabel.textColor = UIColor.white
        numLivesLabel.layer.zPosition = .greatestFiniteMagnitude
        numLivesLabel.text = "Number of lives: \(numLives)"
        addSubview(numLivesLabel)
        
        setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setShipsAngleTransformation(_ angle: CGFloat) {
        if let ship = ship {
            ship.update(angle: angle)
            setNeedsDisplay()
        }
    }
    
    func setShipsTranslationTransformation(position: CGPoint, isThrusting: Bool, _ respawn: Bool = false) {
        if let ship = ship {
            if respawn {
                createExplosion(position: ship.getPosition(), size: Constants.shipSize)
            }
            if isThrusting {
                
            }
            ship.update(position: position)
        }
    }
    
    func addProjectile(_ id: Int, _ angle: CGFloat, _ position: CGPoint) {
        projectileLock.lock()
        projectileViews[id]  = ProjectileView(frame: CGRect(x: frame.width / 2 - Constants.boltWidth / 2, y: frame.height / 2 - Constants.boltHeight / 2,
                                                            width: Constants.boltWidth, height: Constants.boltHeight), angle: angle, position: position)
        guard let projectileView = projectileViews[id] else {
            print("projectile view does not exist")
            exit(0)
        }
        addSubview(projectileView)
        projectileLock.unlock()
        setNeedsDisplay()
    }
    
    func addAsteroid(_ id: Int, _ angle: CGFloat, _ position: CGPoint, _ size: CGFloat) {
        asteroidViews[id]  = AsteroidView(frame: CGRect(x: frame.width / 2 - size / 2, y: frame.height / 2 - size / 2,
                                                        width: size, height: size),
                                          angle: angle,
                                          position: position)
        guard let asteroidView = asteroidViews[id] else {
            print("projectile view does not exist")
            exit(0)
        }
        DispatchQueue.main.async {
            self.addSubview(asteroidView)
        }
        setNeedsDisplay()
    }
    
    func updateProjectile(_ id: Int, _ position: CGPoint) {
        if let projectile =  projectileViews[id] {
            projectile.update(position: position)
        }
        setNeedsDisplay()
    }

    func updateAsteroid(_ id: Int, _ position: CGPoint) {
        if let asteroid =  asteroidViews[id] {
            asteroid.update(position: position)
        }
        setNeedsDisplay()
    }
    
    func removeAsteroid(id: Int) {
        if let asteroid = asteroidViews[id] {
            willRemoveSubview(asteroid)
            if let asteroidView = asteroidViews[id] {
                createExplosion(position: asteroidView.getPosition(), size: asteroidView.frame.width)
            }
            asteroid.update(position: CGPoint(x: self.frame.width + 200, y: 0))
            if let idx = asteroidViews.index(forKey: id) {
                asteroidViews.remove(at: idx)
            }
        }
        setNeedsDisplay()
    }
    
    func removeProjectile(id: Int) {
        if let projectile = projectileViews[id] {
            projectile.update(position: CGPoint(x: self.frame.width + 100, y: 0))
            willRemoveSubview(projectile)
            if let idx = projectileViews.index(forKey: id) {
                projectileViews.remove(at: idx)
                setNeedsDisplay()
            }
        }
    }
    
    func updateScore(_ count: Int) {
        scoreLabel.text = "Player's score: \(count)"
        setNeedsDisplay()
    }
    
    func updateNumberOfLives(_ num: Int) {
        numLivesLabel.text = "Number of lives: \(num)"
        setNeedsDisplay()
    }

    
    func createExplosion(position: CGPoint, size: CGFloat) {
        emitterLayer.emitterPosition = CGPoint(x: frame.maxX / 2 + position.x, y: frame.maxY / 2 + position.y)
        emitterLayer.emitterSize = CGSize(width: size / 2, height: size / 2)
        emitterLayer.birthRate = 1
        
        let cell = CAEmitterCell()
        cell.birthRate = 50
        cell.lifetime = 1.5
        cell.velocity = 100
        cell.scale = 0.005
        
        
        cell.emissionRange = CGFloat.pi * 2.0
        cell.contents = UIImage(named: "yellowDot.png")!.cgImage
        
        emitterLayer.emitterCells = [cell]
        
        layer.addSublayer(emitterLayer)
        startEmitterTimer()
    }
    
    func startEmitterTimer() {
        emitterTimer = Timer.scheduledTimer(timeInterval: 0.125, target: self, selector: #selector(killEmitter), userInfo: nil, repeats: false)
    }
    
    @objc func killEmitter() {
        DispatchQueue.main.async {
            self.emitterLayer.birthRate = 0
        }
    }
}
