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
    let GRID_GAP_SIZE = 2
    let GRID_NODE_CORNER_RADIUS = 4
    let TEXT_SIZE = (1.3/71) * UIScreen.main.bounds.height
    let BUTTON_CORNER_RADIUS = 15
    let BIG_STACK_SPACING = 10
    let SMALL_STACK_SPACING = 2
    let OPTION_STACK_SPACING = 10
    
    var nodes: [UIView]! = []
    var horizontalStacks: [UIStackView] = []
    var gridStack: UIStackView? = nil
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        initializeGrid()
        initializeControls()
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
        let bigStack = initializeControlStack(axis: .vertical, spacing: BIG_STACK_SPACING)
        let bigStackConstraints: [NSLayoutConstraint] = [
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: bigStack.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: bigStack.leadingAnchor, constant: -20),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bigStack.bottomAnchor, constant: 20),
            NSLayoutConstraint(item: bigStack, attribute: .top, relatedBy: .equal, toItem: gridStack, attribute: .bottom, multiplier: 1, constant: 20)
        ]
        bigStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bigStack)
        NSLayoutConstraint.activate(bigStackConstraints)
        
        //Draw Tool Stack
        let drawStack = initializeControlStack(axis: .vertical, spacing: SMALL_STACK_SPACING)
        bigStack.addArrangedSubview(drawStack)
        
        drawStack.addArrangedSubview(initializeControlLabel(title: "CHOOSE DRAW TOOL"))
            
        let drawButtonStack = initializeControlStack(axis: .horizontal, spacing: OPTION_STACK_SPACING)
        drawStack.addArrangedSubview(drawButtonStack)
        
        drawButtonStack.addArrangedSubview(initializeControlButton(title: "Wall", color: UIColor.systemPink))
        drawButtonStack.addArrangedSubview(initializeControlButton(title: "Space", color: UIColor.systemFill))
        drawButtonStack.addArrangedSubview(initializeControlButton(title: "Start", color: UIColor.systemIndigo))
        drawButtonStack.addArrangedSubview(initializeControlButton(title: "End", color: UIColor.systemBlue))
            
        //Algorithm Stack
        let algorithmStack = initializeControlStack(axis: .vertical, spacing: SMALL_STACK_SPACING)
        bigStack.addArrangedSubview(algorithmStack)
        
        algorithmStack.addArrangedSubview(initializeControlLabel(title: "CHOOSE SOLVE ALGORITHM"))
        
        let algorithmButtonStack = initializeControlStack(axis: .horizontal, spacing: OPTION_STACK_SPACING)
        algorithmStack.addArrangedSubview(algorithmButtonStack)
        
        algorithmButtonStack.addArrangedSubview(initializeControlButton(title: "Depth-First-Search", color: UIColor.systemGreen))
        algorithmButtonStack.addArrangedSubview(initializeControlButton(title: "Breadth-First-Search", color: UIColor.systemGreen))
        
        //Speed Stack
        let speedStack = initializeControlStack(axis: .vertical, spacing: SMALL_STACK_SPACING)
        bigStack.addArrangedSubview(speedStack)
        
        speedStack.addArrangedSubview(initializeControlLabel(title: "SET SOLVE SPEED"))
        speedStack.addArrangedSubview(UISlider())
        
        //Controls, Controls.
        let controlStack = initializeControlStack(axis: .vertical, spacing: SMALL_STACK_SPACING)
        bigStack.addArrangedSubview(controlStack)
        
        controlStack.addArrangedSubview(initializeControlLabel(title: "START, STOP, AND RESET"))
        
        let controlButtonStack = initializeControlStack(axis: .horizontal, spacing: OPTION_STACK_SPACING)
        controlStack.addArrangedSubview(controlButtonStack)
        
        controlButtonStack.addArrangedSubview(initializeControlButton(title: "Start", color: UIColor.systemGreen))
        controlButtonStack.addArrangedSubview(initializeControlButton(title: "Reset", color: UIColor.systemPink))
        
    }
    
    func initializeControlButton(title: String, color: UIColor) -> UIButton {
        let toReturn = UIButton()
        toReturn.setTitle(title, for: .normal)
        toReturn.titleLabel!.font = UIFont(name: "LexendDeca-Regular", size: TEXT_SIZE)
        toReturn.setTitleColor(UIColor.label, for: .normal)
        toReturn.backgroundColor = color
        toReturn.cornerRadius = CGFloat(BUTTON_CORNER_RADIUS)
        return toReturn
    }
    
    func initializeControlLabel(title: String) -> UILabel {
        let toReturn = UILabel()
        toReturn.text = title
        toReturn.font = UIFont.init(name: "LexendDeca-Regular", size: TEXT_SIZE)
        return toReturn
    }
    
    func initializeControlStack(axis: NSLayoutConstraint.Axis, spacing: Int) -> UIStackView {
        let toReturn = UIStackView()
        toReturn.axis = axis
        toReturn.alignment = .fill
        toReturn.distribution = .fillEqually
        toReturn.spacing = CGFloat(spacing)
        toReturn.isUserInteractionEnabled = true
        return toReturn
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
        verticalStack.spacing = CGFloat(GRID_GAP_SIZE)
        verticalStack.isUserInteractionEnabled = true
        
        let verticalStackConstraints: [NSLayoutConstraint] = [
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: -20),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: verticalStack.topAnchor, constant: -20),
            verticalStack.heightAnchor.constraint(equalTo: verticalStack.widthAnchor)
        ]
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStack)
        NSLayoutConstraint.activate(verticalStackConstraints)
        gridStack = verticalStack
        
        
        for _ in 1...GRID_SIZE {
            let horizontalStackView = UIStackView()
            horizontalStackView.isUserInteractionEnabled = true
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = CGFloat(GRID_GAP_SIZE)
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
                node.cornerRadius = CGFloat(GRID_NODE_CORNER_RADIUS)
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
