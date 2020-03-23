//
//  ViewController.swift
//  PathFinder
//
//  Created by AJ Radik on 3/23/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = event?.allTouches?.first else {return}
        let touchLocation = touch.location(in: self.view)
        buttons.forEach { (button) in
            if button.frame.contains(touchLocation) {
                button.backgroundColor = UIColor.systemRed
            }
        }
    }
    
}

