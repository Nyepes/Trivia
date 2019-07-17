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
    
    var questionArray = [[String: String]]()
    var questionNum = 0
    var correctIndex = 0
    var correctLabel = UILabel()
    var labelsArray = [UILabel]()
    
    override func viewDidLoad() {
        loadData()
        questionArray.shuffle()
        labelsArray = [answer1Label, answer2Label, answer3Label, answer4Label]
        super.viewDidLoad()
    }
    
    func loadData() {
        var urlNum = 0
        if genreNum == 0 {
            urlNum = 21
        } else if genreNum == 1 {
            urlNum = 23
        } else if genreNum == 2 {
            urlNum = 17
        } else if genreNum == 3 {
            urlNum = 12
        } else if genreNum == 4 {
            urlNum = 24
        } else if genreNum == 5 {
            urlNum = 10
        } else if genreNum == 6 {
            urlNum = 11
        } else if genreNum == 7 {
            urlNum = 15
        } else if genreNum == 8 {
            urlNum = 19
        } else if genreNum == 9 {
            urlNum = 22
        } else if genreNum == 10 {
            urlNum = 25
        } else if genreNum == 11 {
            urlNum = 26
        } else if genreNum == 12 {
            urlNum = 27
        } else if genreNum == 13 {
            urlNum = 31
        }
        
        let query = "https://opentdb.com/api.php?amount=18&category=\(urlNum)&type=multiple"
        DispatchQueue.global(qos: .userInitiated).async { //work on separate thread
            [unowned self] in
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    if json["response_code"] == 0 {
                        self.parse(json: json)
                        return
                    }
                }
            }
            self.loadError()
        }
    }
    
    func parse(json: JSON) {
        for i in 0...14 {
            let result = json["results"][i]
            let question = result["question"].stringValue.stringByDecodingHTMLEntities
            let correct = result["correct_answer"].stringValue.stringByDecodingHTMLEntities
            let wrong1 = result["incorrect_answers"][0].stringValue.stringByDecodingHTMLEntities
            let wrong2 = result["incorrect_answers"][1].stringValue.stringByDecodingHTMLEntities
            let wrong3 = result["incorrect_answers"][2].stringValue.stringByDecodingHTMLEntities
            let source = ["question": question, "correct": correct, "wrong1": wrong1, "wrong2": wrong2, "wrong3": wrong3]
            questionArray.append(source)
        }
        DispatchQueue.main.async { //comes back to main thread
            [unowned self] in
            self.updateLabels()
        }
    }
    
    func updateLabels() {
        questionLabel.text = questionArray[0]["question"]
        var answersArray = [questionArray[0]["correct"], questionArray[0]["wrong1"], questionArray[0]["wrong2"], questionArray[0]["wrong3"]]
        answersArray.shuffle()
        answer1Label.text = answersArray[0]
        answer2Label.text = answersArray[1]
        answer3Label.text = answersArray[2]
        answer4Label.text = answersArray[3]
    }
    
    func loadError() {
        DispatchQueue.main.async { //work on separate thread
            [unowned self] in
            let alert = UIAlertController(title: "Loading Error",
                                          message: "There was a problem loading trivia",
                                          preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    var numOfQuestions = 0
    var wait = false
    
    @IBAction func touhced(_ sender: UITapGestureRecognizer) {
        if(wait) {
            return
        }
        if numOfQuestions < 18 {//fix?
            let selectedPoint = sender.location(in: view)
            numOfQuestions += 1
            for label in labelsArray {
                if(label.frame.contains(selectedPoint)) {
                    self.wait = true
                    if label.text! == questionArray[0]["correct"] {
                        label.backgroundColor = .green
                        questionArray.remove(at: 0)
                        self.wait = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.updateLabels()
                            for label in self.labelsArray {
                                label.backgroundColor = .clear
                            }
                            self.wait = false
                        }
                        
                    }
                    else {
                        label.backgroundColor = .red
                        checkAnswer(label: label)
                        questionArray.remove(at: 0)
                        self.wait = true
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
            print("shit")
        }
    }
    
    func checkAnswer (label: UILabel) {
        for clabel in labelsArray {
            if clabel.text! == questionArray[0]["correct"] {
                clabel.backgroundColor = .green
            }
        }
    }
}

private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&acute;"   : "\u{0000}",
    "&lt;"      : "<",
    "&gt;"      : ">",
    "&Uuml;"    : "U",
    "&uuml;"    : "u",
    "&rsquo;"   : "'",
    "&idquo"    : "?",
    "&rdquo"    : "'",
    "&nbsp;"    : "\u{00a0}",
    "&diams;"   : "♦",
]

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
}
