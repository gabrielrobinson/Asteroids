//
//  HighScoresListController.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/12/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import UIKit

class HighScoresListController: UIViewController {
    private var highScoresTableView: UITableView = UITableView()
    private var highScores: HighScores

    init() {
        self.highScores = HighScores()
        super.init(nibName: nil, bundle: nil)
        print("Entering hgih scores controller.")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        print("Loading view in HighScoresListController")
        super.loadView()
        
        self.title = "High Scores"
        self.view.backgroundColor = .purple
        self.navigationItem.rightBarButtonItem?.title = "High Scores"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        self.highScoresTableView = UITableView(frame: self.view.frame, style: .grouped)
        self.highScoresTableView.allowsSelectionDuringEditing = true
        self.highScoresTableView.dataSource = self
        self.highScoresTableView.delegate = self
        self.highScoresTableView.register(HighScoresListCell.self, forCellReuseIdentifier: String(describing: HighScoresListCell.self))
        highScoresTableView.backgroundColor = .black
        self.view = self.highScoresTableView
        self.highScoresTableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.highScoresTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.highScoresTableView.reloadData()
        
    }
    
    
    func setHighScoresList(_ highScores: HighScores) {
        self.highScores = highScores
    }
    
    
}

extension HighScoresListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HighScoresListCell.self)) as? HighScoresListCell else {
            fatalError("Could not dequeue reusable cell of type \(String(describing: HighScoresListCell.self))")
        }
        _ = cell.increment
        let colorView = UIView()
        colorView.backgroundColor = .purple
        cell.selectedBackgroundView = colorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.size()
    }
}

extension HighScoresListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let highScore = highScores.getScoreFor(idx: indexPath.row)
        if let cell = cell as? HighScoresListCell {
            cell.setPlayerName(highScore.name)
            cell.setScore(highScore.score)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return view.frame.height / 12.0
    }
}
