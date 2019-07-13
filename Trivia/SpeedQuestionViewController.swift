//
//  SpeedQuestionViewController.swift
//  Trivia
//
//  Created by Allan Zhang on 7/13/19.
//  Copyright © 2019 UNO Boys. All rights reserved.
//

import UIKit

class SpeedQuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var firstAnswerLabel: UILabel!
    @IBOutlet weak var secondAnswerLabel: UILabel!
    @IBOutlet weak var thirdAnswerLabel: UILabel!
    @IBOutlet weak var fourthAnswerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var questions = [String: String]()
    var score = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: getRandomQuestion()) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                    parse(json: json)
                    return
                
            }
        }
//        loadError()
    }
    func getRandomQuestion () -> String {
        
        var categories = [String]()
        categories.append("https://opentdb.com/api.php?amount=25&category=21&difficulty=medium&type=multiple")
        categories.append( "https://opentdb.com/api.php?amount=30&category=23&difficulty=medium&type=multiple")
        return categories.randomElement()!
//        let category = categories.randomElement()!
//        let result = json ["results"]["question"]
//        print(result)
//        let question = result! ["question"]
        
    }
//    
//    func parse(json: JSON) {
//        for result in json["results"].arrayValue {
//            let question = result["question"].stringValue
//            let answer = result["correct_answer"].stringValue
//            let wrongAnswer = result["wrong_answer"]
//            //print(question)
//            print(answer)
//        }
////        let random = Int.random(in: 1...5)
////        let question = json["results"].randomElement()
////        questionLabel.text = question!["question"] as! String
////        let result = question["question"]!
//
//    }
}
