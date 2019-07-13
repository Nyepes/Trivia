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
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if highScore == 0 {
            highScoreLabel.text = ""
            
        }
        else {
            highScoreLabel.text = "High Score: \(highScore)"
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
