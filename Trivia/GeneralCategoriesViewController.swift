//
//  ViewController.swift
//  Trivia
//
//  Created by Allan Zhang on 7/9/19.
//  Copyright © 2019 Allan Zhang. All rights reserved.
//

import UIKit

var count = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var totalCount = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var genreNum = -1
var numGenre = 14

class GeneralCategoriesViewController: UITableViewController {
    
    var genre = ["Sports", "History", "Science", "Music", "Politics", "Books", "Film", "Video Games", "Math", "Geography", "Art", "Celebrities", "Animals", "Japanese Anime and Manga"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trivia!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genre.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = genre[indexPath.row]
        if(totalCount[indexPath.row] != 0) {
            cell.detailTextLabel?.text = String(count[indexPath.row]) + "/" + String(totalCount[indexPath.row])
        }
        return cell
    }
    
    @IBAction func unwindToGeneralIinitialViewController(Segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = tableView.indexPathForSelectedRow?.row
        genreNum = index!
    }
}

