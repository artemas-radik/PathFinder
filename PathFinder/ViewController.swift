//
//  ViewController.swift
//  PathFinder
//
//  Created by AJ Radik on 3/23/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Globals
    let GRID_SIZE = 10
    let GAP_SIZE = 2
    let CORNER_RADIUS = 4
    var nodes: [UIView]! = []
    var horizontalStacks: [UIStackView] = []
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        initializeGrid()
    }
    
    //MARK: Drag Detection
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = event?.allTouches?.first else {return}
        nodes.forEach { (node) in
            if node.frame.contains(touch.location(in: node.superview)) {
                node.backgroundColor = UIColor.systemGreen
            }
        }
    }
    
    //MARK: Initialize Controls
    func initializeControls() {
        
        //Big Stack
        let bigStack = UIStackView()
        bigStack.axis = .vertical
        bigStack.alignment = .fill
        bigStack.distribution = .fillEqually
        bigStack.spacing = 20
        bigStack.isUserInteractionEnabled = true
        
        //Draw Stack
        let drawStack = UIStackView()
        drawStack.axis = .vertical
        drawStack.alignment = .fill
        drawStack.distribution = .fillEqually
        drawStack.spacing = 5
        drawStack.isUserInteractionEnabled = true
        
        let drawToolLabel = UILabel()
        drawToolLabel.text = "CHOOSE DRAW TOOL"
        drawStack.addArrangedSubview(drawToolLabel)
        
        let drawWallButton = UIButton()
        drawWallButton.titleLabel?.text
        
        //Algorithm Stack
        let algorithmStack = UIStackView()
        algorithmStack.axis = .vertical
        algorithmStack.alignment = .fill
        algorithmStack.distribution = .fillEqually
        algorithmStack.spacing = 5
        algorithmStack.isUserInteractionEnabled = true
        
        //Speed Stack
        
        //Go/Stop Button
        
        
    }
    
    
    //MARK: Initialize Grid
    func initializeGrid() {
        initializeGridStacks()
        initializeGridNodes()
    }
    
    //MARK: Initialize Grid Stacks
    func initializeGridStacks() {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = CGFloat(GAP_SIZE)
        verticalStack.isUserInteractionEnabled = true
        
        let verticalStackConstraints: [NSLayoutConstraint] = [
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: -20),
            verticalStack.heightAnchor.constraint(equalTo: verticalStack.widthAnchor),
            NSLayoutConstraint(item: verticalStack, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.8, constant: 0)
        ]
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStack)
        NSLayoutConstraint.activate(verticalStackConstraints)
        
        
        for _ in 1...GRID_SIZE {
            let horizontalStackView = UIStackView()
            horizontalStackView.isUserInteractionEnabled = true
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = CGFloat(GAP_SIZE)
            horizontalStacks.append(horizontalStackView)
            verticalStack.addArrangedSubview(horizontalStackView)
        }
        
    }
    
    //MARK: Initialize Grid Nodes
    func initializeGridNodes() {
        for horizontalStack in horizontalStacks {
            for _ in 1...GRID_SIZE {
                let node = UIView()
                node.backgroundColor = UIColor.systemFill
                node.cornerRadius = CGFloat(CORNER_RADIUS)
                node.isUserInteractionEnabled = true
                horizontalStack.addArrangedSubview(node)
                nodes.append(node)
                
            }
        }
    }
    
}



//MARK: UIView Extension
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
