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
            correctLabel = answer1Label
        case 1:
            answer2Label.text = question["correct"]
            correctLabel = answer2Label
        case 2:
            answer3Label.text = question["correct"]
            correctLabel = answer3Label
        default:
            answer4Label.text = question["correct"]
            correctLabel = answer4Label
        }
        var curr = 1
        if(answer1Label.text!.count == 0) {
            answer1Label.text = question["wrong\(curr)"]
            curr += 1
        }
        if(answer2Label.text!.count == 0) {
            answer2Label.text = question["wrong\(curr)"]
            curr += 1
        }
        if(answer3Label.text!.count == 0) {
            answer3Label.text = question["wrong\(curr)"]
            curr += 1
        }
        if(answer4Label.text!.count == 0) {
            answer4Label.text = question["wrong\(curr)"]
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
            answeredArray[questionNum] = 1
            count[categoryNum] += 1
            totalCount[categoryNum] += 1
        } else {
            labelChosen.backgroundColor = .red
            correctLabel.backgroundColor = .green
            answeredArray[questionNum] = 2
            totalCount[categoryNum] += 1
        }
        answered = true
    }
}
