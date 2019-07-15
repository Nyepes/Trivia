//
//  Scores.swift
//  Trivia
//
//  Created by Nicolas Yepes on 7/15/19.
//  Copyright © 2019 UNO Boys. All rights reserved.
//

import Foundation

class Scores: Codable {
    
    var highScore = 0
    var currentScore = 0
    
    init(highScore: Int, score: Int) {
        self.highScore = highScore
        self.currentScore = score
    }
    
}
