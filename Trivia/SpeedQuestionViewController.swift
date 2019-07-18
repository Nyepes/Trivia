//
//  SpeedQuestionViewController.swift
//  Trivia
//
//  Created by Allan Zhang on 7/13/19.
//  Copyright © 2019 UNO Boys. All rights reserved.
//

import UIKit

class SpeedQuestionViewController: UIViewController {
    
    var labelsArray = [UILabel]()
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    @IBOutlet weak var fourthAnswerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var animationLabel: UILabel!
    var questions = [[String: String]]()
    var numOfQuestions = 0
    var correctAnswer = ""
    let defaults = UserDefaults.standard
    var count = 30.00
    var wait = false
    var ended = false
    var scores = Scores(highScore: 0, score: 0)
    
    override func viewDidLoad() {
        scores.currentScore = 0
        labelsArray = [firstAnswerLabel, secondAnswerLabel, thirdAnswerLabel, fourthAnswerLabel]
        questionLabel.lineBreakMode = .byWordWrapping
        for label in labelsArray {
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
        }
        super.viewDidLoad()
        if let savedData = defaults.object(forKey: "data") as? Data {
            if let decoded = try? JSONDecoder().decode(Scores.self, from: savedData) {
                self.scores = decoded
                scores.currentScore = 0
            }
        }
        if let url = URL(string: "https://opentdb.com/api.php?amount=50&type=multiple") {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                parse(json: json)
                countdown()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animationLabel.text = ""
        scores.currentScore = 0
    }
    
    func countdown() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ t in
            self.count -= 0.01
            self.timeRemainingLabel.text = "Time Remaining: " +  String(format: "%.2f", self.count)  + "sec"
            switch self.count {
            case 27...:
                self.animationLabel.text = "("
            case 24...27:
                self.animationLabel.text = "(╯"
            case 21...24:
                self.animationLabel.text = "(╯°"
            case 18...21:
                self.animationLabel.text = "(╯°□"
            case 15...18:
                self.animationLabel.text = "(╯°□°"
            case 12...15:
                self.animationLabel.text = "(╯°□°）"
            case 9...12:
                self.animationLabel.text = "(╯°□°）╯"
            case 6...9:
                self.animationLabel.text = "(╯°□°）╯︵"
            case 3...6:
                self.animationLabel.text = "(╯°□°）╯︵ ┻"
            default:
                self.animationLabel.text = "(╯°□°）╯︵ ┻━"
            }
            if self.count < 0.00 {
                self.animationLabel.text = "(╯°□°）╯︵ ┻━┻"
                self.ended = true
                t.invalidate()
                self.timeRemainingLabel.text = "You Lose"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.performSegue(withIdentifier: "showResults", sender: nil)
                }
            }
        }
    }
    
    func parse(json: JSON) {
        if numOfQuestions < 48{
            for i in 0...48 {
                let result = json["results"][i]
                let question = result["question"].stringValue.stringByDecodingHTMLEntities
                let correct = result["correct_answer"].stringValue.stringByDecodingHTMLEntities
                let wrong1 = result["incorrect_answers"][0].stringValue.stringByDecodingHTMLEntities
                let wrong2 = result["incorrect_answers"][1].stringValue.stringByDecodingHTMLEntities
                let wrong3 = result["incorrect_answers"][2].stringValue.stringByDecodingHTMLEntities
                let source = ["question": question, "correct": correct, "wrong1": wrong1, "wrong2": wrong2, "wrong3": wrong3]
                questions.append(source)
                updateLabels()
            }
        }
        else {
            updateParse()
        }
    }
    
    func updateLabels() {
        questionLabel.text = questions[0]["question"]
        var answersArray = [questions[0]["correct"], questions[0]["wrong1"], questions[0]["wrong2"], questions[0]["wrong3"]]
        answersArray.shuffle()
        firstAnswerLabel.text = answersArray[0]
        secondAnswerLabel.text = answersArray[1]
        thirdAnswerLabel.text = answersArray[2]
        fourthAnswerLabel.text = answersArray[3]
        streakLabel.text = "Streak: \(scores.streak)"
        scoreLabel.text = "Score: \(scores.currentScore)"
        
    }
    
    @IBAction func touched(_ sender: UITapGestureRecognizer) {
        if(wait || ended) {
            return
        }
        if numOfQuestions < 48 {
            
            let selectedPoint = sender.location(in: view)
            numOfQuestions += 1
            for label in labelsArray {
                if(label.frame.contains(selectedPoint)) {
                    self.wait = true
                    if label.text! == questions[0]["correct"] {
                        label.backgroundColor = .green
                        questions.remove(at: 0)
                        count += 5
                        scores.currentScore += 1
                        scoreLabel.text = "Score: \(scores.currentScore)"
                        scores.streak += 1
                        streakLabel.text = "Streak: \(scores.streak)"
                        self.wait = true
                        saveData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.updateLabels()
                            for label in self.labelsArray {
                                label.backgroundColor = .clear
                            }
                            self.wait = false
                        }
                    }
                    else {
                        count -= 3
                        label.backgroundColor = .red
                        checkAnswer(label: label)
                        questions.remove(at: 0)
                        self.wait = true
                        saveData()
                        scores.streak = 0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            for label in self.labelsArray {
                                label.backgroundColor = .clear
                                self.updateLabels()
                            }
                            self.wait = false
                        }
                    }
                }
            }
        } else {
            updateParse()
        }
    }
    
    func checkAnswer (label: UILabel) {
        if label.text == correctAnswer {
            label.backgroundColor = .green
        }
        else {
            label.backgroundColor = .red
            for clabel in labelsArray {
                if clabel.text! == questions[0]["correct"] {
                    clabel.backgroundColor = .green
                }
            }
        }
    }
    func updateParse () {
        if let url = URL(string: "https://opentdb.com/api.php?amount=50&type=multiple") {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                numOfQuestions = 0
                parse(json: json)
            }
        }
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(scores.highScore) {
            defaults.set(encoded, forKey: "data")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc2 = segue.destination as! SpeedResultViewController
        dvc2.scores = scores
    }
}

