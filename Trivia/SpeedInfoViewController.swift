//
//  SpeedInfoViewController.swift
//  Trivia
//
//  Created by Allan Zhang on 7/13/19.
//  Copyright © 2019 UNO Boys. All rights reserved.
//

import UIKit

class SpeedInfoViewController: UIViewController {

    @IBOutlet weak var highScoreLabel: UILabel!
    var highScore = "0"
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedData = defaults.object(forKey: "data") as? Data {
            if let decoded = try? JSONDecoder().decode(<#T##type: Decodable.Protocol##Decodable.Protocol#>, from: savedData) {
                highScore = decoded
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        checkHighScore()
        
    }
    
    @IBAction func unwindToIinitialViewController(Segue: UIStoryboardSegue) {
    }
    
    func checkHighScore() {
        if Int (highScore)! < score {
            highScore = "\(score)"
        }
        if Int(highScore)! != 0 {
            highScoreLabel.text = "High Score: \(highScore)"
        } else {
            highScoreLabel.text = "Click Start to Play!"
        }
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(highScore) {
            defaults.set(encoded, forKey: "data")
        }
    }
}
