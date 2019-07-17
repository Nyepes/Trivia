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
    
    let defaults = UserDefaults.standard
    var scores = Scores(highScore: 0, score: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedData = defaults.object(forKey: "data") as? Data {
            if let decoded = try? JSONDecoder().decode(Scores.self, from: savedData) {
                self.scores = decoded
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        checkHighScore()
        self.saveData()
        if let savedData = defaults.object(forKey: "data") as? Data {
            if let decoded = try? JSONDecoder().decode(Scores.self, from: savedData) {
                self.scores = decoded
            }
        }
    }
    
    @IBAction func unwindToIinitialViewController(Segue: UIStoryboardSegue) {
        self.saveData()
    }
    
    func checkHighScore() {
        if scores.highScore < scores.currentScore {
            scores.highScore = scores.currentScore
        }
        if scores.highScore != 0 {
            highScoreLabel.text = "High Score: \(scores.highScore)"
        } else {
            highScoreLabel.text = "Click Start to Play!"
        }
            saveData()
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(scores) {
            defaults.set(encoded, forKey: "data")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! SpeedQuestionViewController
        dvc.scores = scores
    }
}
