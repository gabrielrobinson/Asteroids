//
//  ViewController.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/12/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class OptionsController: UIViewController {
    
    var buttonPanelView: OptionsButtonPanelView!
    
    override func loadView() {
        super.loadView()
        let buttonPanelView: OptionsButtonPanelView = OptionsButtonPanelView(frame: CGRect(x: 20.0, y: 20.0, width: 500, height: 550.0))
        buttonPanelView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String:Any] = ["view": self.view!, "subview": buttonPanelView]
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=1)-[subview(==400)]",
                                                      options: .alignAllCenterX,
                                                      metrics: nil,
                                                      views: views)
        
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=1)-[subview(==300)]",
                                                        options: .alignAllCenterY,
                                                        metrics: nil,
                                                        views: views)
        self.view.addConstraints(vertical)
        self.view.addConstraints(horizontal)
        self.view.addSubview(buttonPanelView)
        self.buttonPanelView = buttonPanelView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonPanelView!.newGameButton.addTarget(self, action: #selector(newGame), for: UIControl.Event.touchDown)
        buttonPanelView!.loadGameButton.addTarget(self, action: #selector(loadGame), for: UIControl.Event.touchDown)
        buttonPanelView!.highScoresButton.addTarget(self, action: #selector(displayScores), for: UIControl.Event.touchDown)
    }
    
    func readGame() -> Game? {
        let docDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        if let docDirectory = docDirectory {
            let jsonData = try? Data(contentsOf: docDirectory.appendingPathComponent("currentGame"))
            if let jsonData = jsonData {
                let game = try? JSONDecoder().decode(Game.self, from: jsonData)
                if let game = game {
                    return game
                }
            }
        }
        
        return nil
    }
    
    @objc func newGame() {
        print("New game requested...")
        self.navigationController?.pushViewController(GameController(), animated: true)
    }
    
    @objc func loadGame() {
        print("Game load requested...")
        let game: Game? = readGame()
        if let game = game {
            self.navigationController?.pushViewController(GameController(game), animated: true)
        } else {
            let alert = UIAlertController(title: "No game to resume", message: "You must start a new game", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Start", comment: "Default action"), style: .default, handler: { _ in
                self.newGame()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func displayScores() {
        print("High score requested...")
        self.navigationController?.pushViewController(HighScoresListController(), animated: true)
    }
}
