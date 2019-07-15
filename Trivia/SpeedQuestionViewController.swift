//
//  SpeedQuestionViewController.swift
//  Trivia
//
//  Created by Allan Zhang on 7/13/19.
//  Copyright © 2019 UNO Boys. All rights reserved.
//

import UIKit

var score = 0

class SpeedQuestionViewController: UIViewController {
    
    var labelsArray = [UILabel]()
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    @IBOutlet weak var fourthAnswerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var questions = [[String: String]]()
    var numOfQuestions = 0
    var correctAnswer = ""
    var count = 30.00
    var wait = false
    
    override func viewDidLoad() {
        labelsArray = [firstAnswerLabel, secondAnswerLabel, thirdAnswerLabel, fourthAnswerLabel]
        super.viewDidLoad()
        if let url = URL(string: "https://opentdb.com/api.php?amount=50&type=multiple") {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                parse(json: json)
                countdown()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        score = 0
    }
    
    func countdown() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ t in
            self.count -= 0.01
            self.timeRemainingLabel.text = "Time Remaining: " +  String(format: "%.2f", self.count)  + "sec"
            if self.count < 0.00 {
                t.invalidate()
                self.timeRemainingLabel.text = "You Lose"
//                self.view.backgroundColor = .red
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                   self.performSegue(withIdentifier: "backToInfo", sender: self)
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
    
    func startGame() {
        
    }
    
    func updateLabels() {
        questionLabel.text = questions[0]["question"]
        var answersArray = [questions[0]["correct"], questions[0]["wrong1"], questions[0]["wrong2"], questions[0]["wrong3"]]
        answersArray.shuffle()
        print(answersArray)
        firstAnswerLabel.text = answersArray[0]
        secondAnswerLabel.text = answersArray[1]
        thirdAnswerLabel.text = answersArray[2]
        fourthAnswerLabel.text = answersArray[3]
        
    }
    
    @IBAction func touched(_ sender: UITapGestureRecognizer) {
        print(wait)
        if(wait) {
            return
        }
        if numOfQuestions < 48 {
            let selectedPoint = sender.location(in: view)
            numOfQuestions += 1
                for label in labelsArray {
                    if(label.frame.contains(selectedPoint)) {
                        if label.text! == questions[0]["correct"] {
                            label.backgroundColor = .green
                            questions.remove(at: 0)
                            count += 5
                            score += 1
                            scoreLabel.text = "Score :\(score)"
                                                        self.wait = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                self.updateLabels()
                                for label in self.labelsArray {
                                    label.backgroundColor = .white
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                for label in self.labelsArray {
                                    label.backgroundColor = .white
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
            //score += 1
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
}

