//
//  ViewController.swift
//  PathFinder
//
//  Created by AJ Radik on 3/23/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let GRID_SIZE = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeStacks()
    }
    
    var buttons: [UIButton]!
    var horizontalStacks: [UIStackView] = []
    
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
    
    func initializeStacks() {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.distribution = .fillEqually
        
        let verticalStackConstraints: [NSLayoutConstraint] = [
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: -20),
            verticalStack.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
//            verticalStack.centerYAnchor.constraint(equalToSystemSpacingBelow: self.view.centerYAnchor, multiplier: 0.8),
            NSLayoutConstraint(item: verticalStack, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.8, constant: 0)
        ]
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStack)
        NSLayoutConstraint.activate(verticalStackConstraints)
        
        
        for _ in 1...GRID_SIZE {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillEqually

            horizontalStacks.append(horizontalStackView)
            verticalStack.addArrangedSubview(horizontalStackView)
        }
        
    }
    
    
    
}

