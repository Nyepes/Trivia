//
//  ActualQuestionViewController.swift
//  UNO Boys
//
//  Created by Allan Zhang on 7/13/19.
//  Copyright © 2019 UNO Boys. All rights reserved.
//

import UIKit

class ActualQuestionViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Label: UILabel!
    @IBOutlet weak var answer2Label: UILabel!
    @IBOutlet weak var answer3Label: UILabel!
    @IBOutlet weak var answer4Label: UILabel!
    
    var question = [String: String]()
    var questionNum = 0
    var correctIndex = 0
    var correctLabel = UILabel()
    var labelArray = [UILabel]()
    
    override func viewDidLoad() {
        labelArray = [answer1Label, answer2Label, answer3Label, answer4Label]
        super.viewDidLoad()
        questionLabel.text = question["question"]
        correctIndex = Int.random(in: 0...3)
        switch correctIndex {
        case 0:
            answer1Label.text = question["correct"]
            answer1Label.font = UIFont(name:"futura", size: 24.0)
            correctLabel = answer1Label
        case 1:
            answer2Label.text = question["correct"]
            answer2Label.font = UIFont(name:"futura", size: 24.0)
            correctLabel = answer2Label
        case 2:
            answer3Label.text = question["correct"]
            answer3Label.font = UIFont(name:"futura", size: 24.0)
            correctLabel = answer3Label
        default:
            answer4Label.text = question["correct"]
            answer4Label.font = UIFont(name:"futura", size: 24.0)
            correctLabel = answer4Label
        }
        var curr = 1
        if(answer1Label.text!.count == 0) {
            answer1Label.text = question["wrong\(curr)"]
            answer1Label.font = UIFont(name:"futura", size: 24.0)
            curr += 1
        }
        if(answer2Label.text!.count == 0) {
            answer2Label.text = question["wrong\(curr)"]
            answer2Label.font = UIFont(name:"futura", size: 24.0)
            curr += 1
        }
        if(answer3Label.text!.count == 0) {
            answer3Label.text = question["wrong\(curr)"]
            answer3Label.font = UIFont(name:"futura", size: 24.0)
            curr += 1
        }
        if(answer4Label.text!.count == 0) {
            answer4Label.text = question["wrong\(curr)"]
            answer4Label.font = UIFont(name:"futura", size: 24.0)
            curr += 1
        }
    }
    
    
    @IBAction func touhced(_ sender: UITapGestureRecognizer) {
        let selectedPoint = sender.location(in: view)
        var count = 0
        for label in labelArray {
            if(label.frame.contains(selectedPoint)) {
                checkAnswer(labelChosen: label, num: count)
                return
            }
            count += 1
        }
    }
    
    var answered = false
    
    func checkAnswer(labelChosen: UILabel, num: Int) {
        if(answered) {
            return
        }
        if(num == correctIndex) {
            labelChosen.backgroundColor = .green
            answeredArray[genreNum][questionNum] = 1
            count[genreNum] += 1
            totalCount[genreNum] += 1
        } else {
            labelChosen.backgroundColor = .red
            correctLabel.backgroundColor = .green
            answeredArray[genreNum][questionNum] = 2
            totalCount[genreNum] += 1
        }
        answered = true
    }
}
