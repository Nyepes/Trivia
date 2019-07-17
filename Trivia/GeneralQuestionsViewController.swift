//
//  QuestionViewController.swift
//  Trivia
//
//  Created by Allan Zhang on 7/9/19.
//  Copyright © 2019 Allan Zhang. All rights reserved.
//

import UIKit

var answeredArray = [[Int]]()

class GeneralQuestionsViewController: UITableViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Trivia Questions"
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
            
        let query = "https://opentdb.com/api.php?amount=15&category=\(urlNum)&type=multiple"
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
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
            self.tableView.reloadData()
        }
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Question \(indexPath.row + 1)"
        if(answeredArray[genreNum][indexPath.row] == 1) {
            cell.textLabel?.textColor = .green
        } else if(answeredArray[genreNum][indexPath.row] == 2) {
            cell.textLabel?.textColor = .red
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! ActualQuestionViewController
        let index = tableView.indexPathForSelectedRow?.row
        dvc.question = questionArray[index!]
        dvc.questionNum = index!
    }
}
