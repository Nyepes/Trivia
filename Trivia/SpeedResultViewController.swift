//
//  SpeedResultViewController.swift
//  Trivia
//
//  Created by Allan Zhang on 7/17/19.
//  Copyright © 2019 UNO Boys. All rights reserved.
//

import UIKit

class SpeedResultViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text! = "Score: " + String(score)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func onShareResultsClicked(_ sender: UIButton) {
        self.displayShareSheet(shareContent: self.scoreLabel.text!)
    }

}
