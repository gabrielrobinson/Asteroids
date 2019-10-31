//
//  HighScore.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/24/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import Foundation



class HighScore: Codable {
    var name: String
    var score: Int
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}
