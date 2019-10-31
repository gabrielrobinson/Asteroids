//
//  GameController.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/12/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

protocol GameProtocols {
    func turnLeft()
    func turnRight()
    func fire()
    func accelerate()
}

protocol UpdateViewProtocols {
    func updateShip(angle: CGFloat)
    func updateShipPosition(position: CGPoint, isThrusting: Bool, _ respawn: Bool)
    
    // functions to add to view
    func addProjectile(id: Int, angle: CGFloat, position: CGPoint)
    func addAsteroid(id: Int, position: CGPoint, angle: CGFloat, size: CGFloat)
    
    // functions to update view
    func updateProjectile(id: Int, position: CGPoint)
    func updateAsteroid(id: Int, position: CGPoint)
    
    // functions to remove from the view
    func removeProjectile(id: Int)
    func removeAsteroid(id: Int)
    
    func updateScore(count: Int)
    func  updateLivesNumber(num: Int)
    
    func gameOver()
}

class GameController: UIViewController {
    var gameModel: Game?
    var gameView: GameView!
    var isTurningLeft = false
    var isTurningRight = false
    var isFiring = false
    var isAccelerating = false
    var isGameOver = false
    var gameTimer: Timer?
    var velocity: CGFloat = 0
    var fireCount = 0
    var updatingEnabled = true
    var regenTimer: Timer?
    
    convenience init(_ game: Game) {
        self.init()
        self.gameModel = game
    }
    
    override func loadView() {
        super.loadView()
        
        let gameView: GameView = GameView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)!, width: self.view.frame.width, height: self.view.frame.height - (navigationController?.navigationBar.frame.height)!))
        self.view.addSubview(gameView)
        self.gameView = gameView
        if let gameModel = gameModel {
            gameModel.set(viewProtocols: self)
        } else {
            gameModel = Game(left: -(gameView.asteroidFieldView?.frame.width)! / 2, right: (gameView.asteroidFieldView?.frame.width)! / 2,
                             top: -(gameView.asteroidFieldView?.frame.height)! / 2 + (navigationController?.navigationBar.frame.height)!,
                             bottom: (gameView.asteroidFieldView?.frame.height)! / 2, protocols: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameTimer = Timer.scheduledTimer(timeInterval: 0.0167, target: self, selector: #selector(updateGameState), userInfo: nil, repeats: true)
        if let gameButtonPanel = gameView!.gameButtonPanelView {
            gameButtonPanel.accelerateButton.addTarget(self, action: #selector(activateAccelerate), for: [.touchDown, .touchDragEnter])
            gameButtonPanel.fireButton.addTarget(self, action: #selector(activateFire), for: [.touchDown, .touchDragEnter])
            gameButtonPanel.turnLeftButton.addTarget(self, action: #selector(activateTurnLeft), for: [.touchDown, .touchDragEnter])
            gameButtonPanel.turnRightButton.addTarget(self, action: #selector(activateTurnRight), for: [.touchDown, .touchDragEnter])
            gameButtonPanel.accelerateButton.addTarget(self, action: #selector(endAccelerate), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
            gameButtonPanel.fireButton.addTarget(self, action: #selector(endFire), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
            gameButtonPanel.turnLeftButton.addTarget(self, action: #selector(endLeftTurn), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
            gameButtonPanel.turnRightButton.addTarget(self, action: #selector(endRightTurn), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
        }
        
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "<", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popToRoot))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
    }
    
    func writeGame() {
        let encoder = JSONEncoder()
        let jsonData  = try? encoder.encode(gameModel)
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        try! jsonData?.write(to: docDirectory.appendingPathComponent("currentGame"))
    }
    
    @objc func popToRoot() {
        writeGame()
        gameModel = nil
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func updateGameState() {
        
        if isGameOver {
            guard let gameTimer = gameTimer else {
                print("If this executes, there are issues")
                exit(-1)
            }
            gameTimer.invalidate()
            if let gameModel = gameModel {
                let highScores = HighScores()
                if highScores.shouldAdd(score: gameModel.playersScore) {
                    let alert = UIAlertController(title: "New High Score!", message: "Enter your name", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (textField) in
                        textField.placeholder = "Player's Name"
                    })
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Create", comment: "Default action"), style: .default, handler: { _ in
                        if let playersName = alert.textFields?[0].text {
                            highScores.addHighScore(name: playersName, score: gameModel.playersScore)
                        }
                        if let navigationController = self.navigationController {
                            self.gameModel = nil
                            self.removeCurrentGameFile()
                            let viewControllers = [self.navigationController!.viewControllers[0], HighScoresListController()]
                            navigationController.setViewControllers(viewControllers, animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)

                } else {
                    let alert = UIAlertController(title: "GAME OVER", message: "You destroyed \(gameModel.playersScore) asteroids. Have to try harder than that.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                        if let navigationController = self.navigationController {
                            self.gameModel = nil
                            self.removeCurrentGameFile()
                            _ = navigationController.popViewController(animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        fire()
        accelerate()
        turnLeft()
        turnRight()
        
        if let gameModel = gameModel {
            gameModel.updateProjectileStates()
            if let gameView = gameView {
                if let asteroidsView = gameView.asteroidFieldView {
                    if asteroidsView.asteroidViews.count > 0 && gameModel.hasAsteroids() {
                        gameModel.updateAsteroidStates()
                    }
                }
            }
        }
    }
    
    func removeCurrentGameFile() {
        let docDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        if let docDirectory = docDirectory {
            try? FileManager.default.removeItem(at: docDirectory.appendingPathComponent("currentGame"))
        }
    }
    
    @objc func activateAccelerate() {
        print("Accelerating...")
        isAccelerating = true
    }
    
    @objc func activateFire() {
        print("Firing...")
        isFiring = true
    }
    
    @objc func activateTurnLeft() {
        print("Turning left...")
        isTurningLeft = true
    }
    
    @objc func activateTurnRight() {
        print("Turning right...")
        isTurningRight = true
    }
    
    @objc func endLeftTurn() {
        print("End turn...")
        isTurningLeft = false
    }
    
    @objc func endRightTurn() {
        print("End turn...")
        isTurningRight = false
    }
    
    
    @objc func endFire() {
        print("End fire...")
        isFiring = false
    }
    
    @objc func endAccelerate() {
        print("End accelerate...")
        isAccelerating = false
    }
}

extension GameController: GameProtocols {
    func turnRight() {
        if isTurningRight, let gameModel = gameModel {
            gameModel.turnShip(angle: 2.5)
        }
    }
    
    func fire() {
        if isFiring && fireCount % 7 == 0, let gameModel = gameModel {
            gameModel.fireProjectile()
            fireCount = 1
        } else {
            fireCount += 1
        }
    }
    
    func turnLeft() {
        if  isTurningLeft, let gameModel = gameModel {
            gameModel.turnShip(angle: -2.5)
        }
    }
    
    func accelerate() {
        if let gameModel = gameModel {
            if isAccelerating {
                gameModel.accelerateShip(0.2)
            } else {
                gameModel.accelerateShip(-0.1)
            }
        }
    }
}

extension GameController: UpdateViewProtocols {
    func addAsteroid(id: Int, position: CGPoint, angle: CGFloat, size: CGFloat) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.addAsteroid(id, angle, position, size)
            }
        }
    }
    
    func updateAsteroid(id: Int, position: CGPoint) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.updateAsteroid(id, position)
            }
        }
    }
    
    func addProjectile(id: Int, angle: CGFloat, position: CGPoint) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.addProjectile(id, angle, position)
            }
        }
    }
    
    func updateProjectile(id: Int, position: CGPoint) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.updateProjectile(id, position)
            }
        }
    }
    
    func updateShip(angle: CGFloat) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.setShipsAngleTransformation(angle)
            }
        }
    }
    
    func updateShipPosition(position: CGPoint, isThrusting: Bool, _ respawn: Bool) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.setShipsTranslationTransformation(position: position, isThrusting: isThrusting, respawn)
            }
        }
    }
    
    func removeProjectile(id: Int) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.removeProjectile(id: id)
            }
        }
    }
    
    func removeAsteroid(id: Int) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.removeAsteroid(id: id)
            }
        }
    }
    
    func updateScore(count: Int) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.updateScore(count)
            }
        }
    }
    
    func updateLivesNumber(num: Int) {
        if let gameView = gameView {
            if let asteroidView = gameView.asteroidFieldView {
                asteroidView.updateNumberOfLives(num)
            }
        }
    }
    
    func gameOver() {
        isGameOver = true
    }
}

