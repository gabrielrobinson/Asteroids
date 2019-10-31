//
//  HighScores.swift
//  Asteroids
//
//  Created by Gabriel Robinson on 4/24/19.
//  Copyright © 2019 CS4530. All rights reserved.
//

import Foundation

class HighScores {
    var highScores = [HighScore]()
    
    init() {
        highScores = readHighScores()
        highScores.sort(by: { $0.score > $1.score })
    }
    
    func addHighScore(name: String, score: Int) {
        while highScores.count >= 10 {
            highScores.removeLast()
        }
        highScores.append(HighScore(name: name, score: score))
        writeHighScores()
    }
    
    func getScoreFor(idx: Int) -> HighScore {
        return highScores[idx]
    }
    
    func shouldAdd(score: Int) -> Bool {
        if highScores.count >= 10 {
            if score > highScores[highScores.count - 1].score {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    private func readHighScores()->[HighScore] {
        let docDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        if let docDirectory = docDirectory {
            let jsonData = try? Data(contentsOf: docDirectory.appendingPathComponent("high_scores"))
            if let jsonData = jsonData {
                let highScores = try? JSONDecoder().decode([HighScore].self, from: jsonData)
                if let highScores = highScores {
                    return highScores
                }
            }
        }
        
        let emptyStructure = [HighScore].init()
        return emptyStructure
    }
    
    func size() -> Int {
        return highScores.count
    }
    
    private func writeHighScores() {
        let encoder = JSONEncoder()
        let jsonData  = try? encoder.encode(highScores)
        writeData(jsonData, "high_scores")
    }
    
    private func writeData(_ jsonData: Data?, _ fileName: String) {
        let docDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        try! jsonData?.write(to: docDirectory.appendingPathComponent(fileName))
    }
}
