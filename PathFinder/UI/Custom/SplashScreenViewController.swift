//
//  SplashScreenViewController.swift
//  PathFinder
//
//  Created by AJ Radik on 4/12/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet var labels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for label in labels {
            
            if label.tag == 1 {
                label.text = "PathFinder is an algorithm visualizer for the Breadth First Search and Depth First Search pathfinding algorithms.\n\nTo begin, draw walls on the grid using the wall draw tool. Make sure you add a start node and end node as well. Select a solve algorithm, hit the find path button, and watch magic happen!\n\nFeel free to drop a review, and enjoy :)"
            }
            
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
        }
        
    }
    
    
    @IBAction func continueButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
