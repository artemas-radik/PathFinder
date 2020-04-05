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
    let TEXT_SIZE = (1.2/71) * UIScreen.main.bounds.height
    let CONTROL_BUTTON_CORNER_RADIUS = 10
    let BIG_STACK_SPACING = 10
    let SMALL_STACK_SPACING = 2
    let OPTION_STACK_SPACING = 10
    let STANDARD_CONSTRAINT_CONSTANT: CGFloat = 20
    let FONT_NAME = "LexendDeca-Regular"
    let CONTROL_BUTTON_ALPHA_MAX: CGFloat = 1.0
    let CONTROL_BUTTON_ALPHA_MIN: CGFloat = 0.4
    let CONTROL_BUTTON_ANIMATION_DURATION = 0.2
    let SPEED_SLIDER_MIN: Float = 5000
    let SPEED_SLIDER_MAX: Float = 50000
    
    var nodes: [[Node]] = []
    var startNode: Node? = nil
    var endNode: Node? = nil
    var verticalGridStack: UIStackView? = nil
    var drawtype: Node.NodeType = .wall
    var speed: Float = 0
    var thread: Thread? = nil
    var threadIsCancelled = false
    
    enum SolveAlgorithm {
        case DFS
        case BFS
    }
    
    var solveAlgorithm: SolveAlgorithm = .DFS
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        initializeGrid()
        initializeControls()
        
//        let thread = Thread.init(target: self, selector: #selector(someAsyncFunction), object: nil)
//        thread.start()
    }
    
    @objc func someAsyncFunction() {
      // Something that takes some time to complete.
        for node in nodes[0] {
            DispatchQueue.main.async {
                node.view.backgroundColor = UIColor.systemYellow
            }
            usleep(useconds_t((speed)))
            print(Thread.current)
        }
    }
    
    @objc func asyncBFS() {
        
        if startNode == nil {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "No Start Node Found!", message: "Please add a start node with the draw start node tool.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            return
        }
        
        else if endNode == nil {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "No End Node Found!", message: "Please add an end node with the draw end node tool.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            return
        }
        
        
        var startNodeCoordinates: (Int?, Int?) = (nil, nil)
        
        for row in 0...nodes.count-1 {
            for column in 0...nodes[row].count-1 {
                if nodes[row][column] === startNode! {
                    startNodeCoordinates = (row, column)
                }
            }
        }
        
        let queue = Queue<(Int?, Int?)>()
        queue.enQueue(item: startNodeCoordinates)
        
        while queue.size > 0 {
            
            let currentCoordinates = queue.deQueue()
            let currentNode = nodes[currentCoordinates.0!][currentCoordinates.1!]
            
            if currentNode === endNode {
                break
            }
            
            if currentNode.isVisited || currentNode.type == .wall {
                continue
            }
            
            currentNode.isVisited = true
            
            DispatchQueue.main.async {
                
                if currentNode.type != .end && currentNode.type != .start {
                    currentNode.view.backgroundColor = UIColor.systemYellow
                }
                
            }
            
            //go right
            let rightCoordinates = (currentCoordinates.0!, currentCoordinates.1!+1)
            if rightCoordinates.1 <= nodes[rightCoordinates.0].count-1 && !nodes[rightCoordinates.0][rightCoordinates.1].isVisited && nodes[rightCoordinates.0][rightCoordinates.1].type != .wall {
                queue.enQueue(item: rightCoordinates)
                
                let rightNode = nodes[rightCoordinates.0][rightCoordinates.1]
                rightNode.parent = currentNode
                
                DispatchQueue.main.async {
                    
                    if rightNode.type != .end && rightNode.type != .start {
                        rightNode.view.backgroundColor = UIColor.systemGreen
                    }
                    
                }
                
                usleep(useconds_t(speed))
                
            }
            
            //go up
            let upCoordinates = (currentCoordinates.0!-1, currentCoordinates.1!)
            if upCoordinates.0 >= 0 && !nodes[upCoordinates.0][upCoordinates.1].isVisited && nodes[upCoordinates.0][upCoordinates.1].type != .wall {
                queue.enQueue(item: upCoordinates)
                
                let upNode = nodes[upCoordinates.0][upCoordinates.1]
                upNode.parent = currentNode
                
                DispatchQueue.main.async {
                    
                    if upNode.type != .end && upNode.type != .start {
                        upNode.view.backgroundColor = UIColor.systemGreen
                    }
                    
                }
                
                usleep(useconds_t(speed))
                
            }
            
            // go left
            let leftCoordinates = (currentCoordinates.0!, currentCoordinates.1!-1)
            if leftCoordinates.1 >= 0 && !nodes[leftCoordinates.0][leftCoordinates.1].isVisited && nodes[leftCoordinates.0][leftCoordinates.1].type != .wall {
                queue.enQueue(item: leftCoordinates)
                
                let leftNode = nodes[leftCoordinates.0][leftCoordinates.1]
                leftNode.parent = currentNode
                
                DispatchQueue.main.async {
                    
                    if leftNode.type != .end && leftNode.type != .start {
                        leftNode.view.backgroundColor = UIColor.systemGreen
                    }
                    
                }
                
                usleep(useconds_t(speed))
                
            }
            
            //go down
            let downCoordinates = (currentCoordinates.0!+1, currentCoordinates.1!)
            if downCoordinates.0 <= nodes.count-1 && !nodes[downCoordinates.0][downCoordinates.1].isVisited && nodes[downCoordinates.0][downCoordinates.1].type != .wall {
                queue.enQueue(item: downCoordinates)
                
                let downNode = nodes[downCoordinates.0][downCoordinates.1]
                downNode.parent = currentNode
                
                DispatchQueue.main.async {
                    
                    if downNode.type != .end && downNode.type != .start {
                        downNode.view.backgroundColor = UIColor.systemGreen
                    }
                    
                }
                
                usleep(useconds_t(speed))
                
            }
            
        }
        
        var currentNode = endNode!.parent
        
        if currentNode == nil {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "No Path Found.", message: "There is no path present from the start node to the end node.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
            return
        }
        
        
        while(currentNode !== startNode) {
            
            DispatchQueue.main.async {
                
                if currentNode!.type != .end && currentNode!.type != .start {
                    currentNode!.view.backgroundColor = UIColor.systemTeal
                }
                
            }
            
            usleep(useconds_t(speed*6))
            
            currentNode = currentNode?.parent
            
        }
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "The Shortest Path Was Found!", message: "It is displayed in teal on the grid.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //MARK: Drag and Touch Detection
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = event?.allTouches?.first else {return}
        respondToTouch(touch: touch)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = event?.allTouches?.first else {return}
        respondToTouch(touch: touch)
    }
    
    func respondToTouch(touch: UITouch) {
        for nodeRow in nodes {
            for node in nodeRow {
                if node.view.frame.contains(touch.location(in: node.view.superview)) {
                    
                    switch drawtype {
                        case .wall:
                            node.view.backgroundColor = UIColor.systemPink
                            node.type = .wall
                        case .space:
                            node.view.backgroundColor = UIColor.systemFill
                            node.type = .space
                        case .start:
                            startNode?.view.backgroundColor = UIColor.systemFill
                            startNode?.type = .space
                            startNode = node
                            startNode?.view.backgroundColor = UIColor.systemIndigo
                            startNode?.type = .start
                        case .end:
                            endNode?.view.backgroundColor = UIColor.systemFill
                            endNode?.type = .space
                            endNode = node
                            endNode?.view.backgroundColor = UIColor.systemBlue
                            endNode?.type = .end
                    }
                    
                }
            }
        }
    }
    
    //MARK: Custom UI Initializers
    func initializeCustomButton(title: String, color: UIColor) -> UIButton {
        let toReturn = UIButton()
        toReturn.setTitle(title, for: .normal)
        toReturn.titleLabel!.font = UIFont(name: FONT_NAME, size: TEXT_SIZE)
        toReturn.setTitleColor(UIColor.label, for: .normal)
        toReturn.backgroundColor = color
        toReturn.cornerRadius = CGFloat(CONTROL_BUTTON_CORNER_RADIUS)
        toReturn.addTarget(self, action: #selector(controlButtonTouchUpInside(sender:)), for: .touchUpInside)
        toReturn.addTarget(self, action: #selector(controlButtonTouchDown(sender:)), for: .touchDown)
        toReturn.addTarget(self, action: #selector(controlButtonTouchDragExit(sender:)), for: .touchDragExit)
        toReturn.alpha = CONTROL_BUTTON_ALPHA_MIN
        return toReturn
    }
    
    func initializeCustomButton(title: String, color: UIColor, alpha: CGFloat) -> UIButton {
        let toReturn = initializeCustomButton(title: title, color: color)
        toReturn.alpha = alpha
        return toReturn
    }
    
    func initializeCustomLabel(title: String) -> UILabel {
        let toReturn = UILabel()
        toReturn.text = title
        toReturn.font = UIFont.init(name: FONT_NAME, size: TEXT_SIZE)
        return toReturn
    }
    
    func initializeCustomStack(axis: NSLayoutConstraint.Axis, spacing: Int) -> UIStackView {
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
        verticalGridStack = initializeCustomStack(axis: .vertical, spacing: GRID_GAP_SIZE)
        
        let gridStackConstraints: [NSLayoutConstraint] = [
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: verticalGridStack!.trailingAnchor, constant: STANDARD_CONSTRAINT_CONSTANT),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: verticalGridStack!.leadingAnchor, constant: -1 * STANDARD_CONSTRAINT_CONSTANT),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: verticalGridStack!.topAnchor, constant: -1 * STANDARD_CONSTRAINT_CONSTANT),
            verticalGridStack!.heightAnchor.constraint(equalTo: verticalGridStack!.widthAnchor)
        ]
        
        verticalGridStack!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalGridStack!)
        NSLayoutConstraint.activate(gridStackConstraints)
        
        
        for _ in 1...GRID_SIZE {
            let horizontalStackView = initializeCustomStack(axis: .horizontal, spacing: GRID_GAP_SIZE)
            verticalGridStack!.addArrangedSubview(horizontalStackView)
        }
        
    }
        
    //MARK: Initialize Grid Nodes
    func initializeGridNodes() {
        for horizontalStack in verticalGridStack!.arrangedSubviews {
            nodes.append([])
            for _ in 0...GRID_SIZE-1 {
                let nodeView = UIView()
                nodeView.backgroundColor = UIColor.systemFill
                nodeView.cornerRadius = CGFloat(GRID_NODE_CORNER_RADIUS)
                nodeView.isUserInteractionEnabled = true
                (horizontalStack as! UIStackView).addArrangedSubview(nodeView)
                nodes[nodes.count-1].append(Node(view: nodeView))
            }
        }
    }
    
    //MARK: Initialize Controls
    func initializeControls() {
        
        //Big Stack
        let bigStack = initializeCustomStack(axis: .vertical, spacing: BIG_STACK_SPACING)
        let bigStackConstraints: [NSLayoutConstraint] = [
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: bigStack.trailingAnchor, constant: STANDARD_CONSTRAINT_CONSTANT),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: bigStack.leadingAnchor, constant: -1 * STANDARD_CONSTRAINT_CONSTANT),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bigStack.bottomAnchor, constant: STANDARD_CONSTRAINT_CONSTANT),
            NSLayoutConstraint(item: bigStack, attribute: .top, relatedBy: .equal, toItem: verticalGridStack, attribute: .bottom, multiplier: 1, constant: STANDARD_CONSTRAINT_CONSTANT)
        ]
        bigStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bigStack)
        NSLayoutConstraint.activate(bigStackConstraints)
        
        //Draw Tool Stack
        let drawStack = initializeCustomStack(axis: .vertical, spacing: SMALL_STACK_SPACING)
        bigStack.addArrangedSubview(drawStack)
        
        drawStack.addArrangedSubview(initializeCustomLabel(title: "CHOOSE DRAW TOOL"))
        
        let drawButtonStack = initializeCustomStack(axis: .horizontal, spacing: OPTION_STACK_SPACING)
        drawStack.addArrangedSubview(drawButtonStack)
        
        drawButtonStack.addArrangedSubview(initializeCustomButton(title: "Wall", color: UIColor.systemPink, alpha: CONTROL_BUTTON_ALPHA_MAX))
        drawButtonStack.addArrangedSubview(initializeCustomButton(title: "Space", color: UIColor.systemFill))
        drawButtonStack.addArrangedSubview(initializeCustomButton(title: "Start", color: UIColor.systemIndigo))
        drawButtonStack.addArrangedSubview(initializeCustomButton(title: "End", color: UIColor.systemBlue))
            
        //Algorithm Stack
        let algorithmStack = initializeCustomStack(axis: .vertical, spacing: SMALL_STACK_SPACING)
        bigStack.addArrangedSubview(algorithmStack)
        
        algorithmStack.addArrangedSubview(initializeCustomLabel(title: "CHOOSE SOLVE ALGORITHM"))
        
        let algorithmButtonStack = initializeCustomStack(axis: .horizontal, spacing: OPTION_STACK_SPACING)
        algorithmStack.addArrangedSubview(algorithmButtonStack)
        
        algorithmButtonStack.addArrangedSubview(initializeCustomButton(title: "Depth-First-Search", color: UIColor.systemGreen, alpha: CONTROL_BUTTON_ALPHA_MAX))
        algorithmButtonStack.addArrangedSubview(initializeCustomButton(title: "Breadth-First-Search", color: UIColor.systemGreen))
        
        //Speed Stack
        let speedStack = initializeCustomStack(axis: .vertical, spacing: SMALL_STACK_SPACING)
        bigStack.addArrangedSubview(speedStack)
        
        speedStack.addArrangedSubview(initializeCustomLabel(title: "SET SOLVE SPEED"))
        let speedSlider = UISlider()
        speedSlider.minimumValue = SPEED_SLIDER_MIN
        speedSlider.maximumValue = SPEED_SLIDER_MAX
        speedSlider.value = (SPEED_SLIDER_MAX + SPEED_SLIDER_MIN) / 2
        speedSlider.addTarget(self, action: #selector(speedSliderDidChange(sender:)), for: .valueChanged)
        speed = speedSlider.maximumValue - speedSlider.value + speedSlider.minimumValue
        speedStack.addArrangedSubview(speedSlider)
        
        //Controls, Controls.
        let controlStack = initializeCustomStack(axis: .vertical, spacing: SMALL_STACK_SPACING)
        bigStack.addArrangedSubview(controlStack)
        
        controlStack.addArrangedSubview(initializeCustomLabel(title: "FIND PATH, STOP, AND RESET"))
        
        let controlButtonStack = initializeCustomStack(axis: .horizontal, spacing: OPTION_STACK_SPACING)
        controlStack.addArrangedSubview(controlButtonStack)
        
        controlButtonStack.addArrangedSubview(initializeCustomButton(title: "Find Path", color: UIColor.systemGreen, alpha: CONTROL_BUTTON_ALPHA_MAX))
        controlButtonStack.addArrangedSubview(initializeCustomButton(title: "Reset", color: UIColor.systemPink, alpha: CONTROL_BUTTON_ALPHA_MAX))
        
    }
    
    //MARK: Control Button Handlers
    @objc func controlButtonTouchUpInside(sender: UIButton!) {
       print("Button touched up inside")
        
        for button in (sender.superview as! UIStackView).arrangedSubviews {
            if button == sender {
                UIView.animate(withDuration: CONTROL_BUTTON_ANIMATION_DURATION) {
                    sender.alpha = self.CONTROL_BUTTON_ALPHA_MAX
                }
            }
            
            else if sender.titleLabel!.text != "Find Path" && sender.titleLabel?.text != "Stop" && sender.titleLabel?.text != "Reset"  {
                
                UIView.animate(withDuration: CONTROL_BUTTON_ANIMATION_DURATION) {
                    button.alpha = self.CONTROL_BUTTON_ALPHA_MIN
                }
            }
        }
        
        switch sender.titleLabel?.text {
            case "Wall":
                drawtype = .wall
            case "Space":
                drawtype = .space
            case "Start":
                drawtype = .start
            case "End":
                drawtype = .end
            case "Depth-First-Search":
                solveAlgorithm = .DFS
            case "Breadth-First-Search":
                solveAlgorithm = .BFS
            case "Reset":
                reset()
            case "Find Path":
                threadIsCancelled = false
                thread = Thread.init(target: self, selector: #selector(asyncBFS), object: nil)
                thread!.start()
            default:
                break
        }
        
    }
    
    var mostRecentAlpha = 1.0
    
    @objc func controlButtonTouchDown(sender: UIButton!) {
       print("Button touched down")
        
        self.mostRecentAlpha = Double(sender.alpha)
        
        UIView.animate(withDuration: CONTROL_BUTTON_ANIMATION_DURATION) {
            sender.alpha = self.CONTROL_BUTTON_ALPHA_MIN
        }
    }
    
    @objc func controlButtonTouchDragExit(sender: UIButton!) {
       print("Button touch dragged exited")
        
        UIView.animate(withDuration: CONTROL_BUTTON_ANIMATION_DURATION) {
            sender.alpha = CGFloat(self.mostRecentAlpha)
        }
    }
    
    @objc func speedSliderDidChange(sender: UISlider!) {
        speed = sender.maximumValue - sender.value + sender.minimumValue
    }

    func reset() {
        threadIsCancelled = true
        for nodeRow in nodes {
            for node in nodeRow {
                node.isVisited = false
                node.type = .space
                node.parent = nil
                node.view.backgroundColor = UIColor.systemFill
                startNode = nil
                endNode = nil
            }
        }
    }
    
}

//MARK: Node Class

class Node {
    
    enum NodeType {
        case wall
        case space
        case start
        case end
    }
    
    var view: UIView
    var type: NodeType = .space
    var isVisited: Bool = false
    var parent: Node? = nil
    
    init(view: UIView) {
        self.view = view
    }
    
}

//MARK: Queue Class

class Queue<T> {
    
    class Node<T> {
        let data: T?
        var left: Node<T>?
        var right: Node<T>?
        
        init(data: T?, left: Node<T>?, right: Node<T>?) {
            self.data = data
            self.left = left
            self.right = right
        }
    }
    
    var size: Int
    let head: Node<T>
    let tail: Node<T>
    
    init() {
        size = 0
        head = Node<T>(data: nil, left: nil, right: nil)
        tail = Node<T>(data: nil, left: head, right: nil)
        head.right = tail
    }
    
    func enQueue(item: T) {
        let previous = tail.left
        let newNode = Node(data: item, left: previous, right: tail)
        tail.left = newNode
        previous!.right = newNode
        size+=1
    }
    
    func deQueue() -> T{
        let toExtractDataFrom = head.right
        head.right = head.right!.right!
        head.right!.left! = head
        size-=1
        return toExtractDataFrom!.data!
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
