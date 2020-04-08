//
//  SolveAlgorithms.swift
//  PathFinder
//
//  Created by AJ Radik on 4/6/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

let SOLVE_ANIMATION_DURATION = 0.6
let SOLVE_ANIMATION_DELAY: TimeInterval = 0
let SOLVE_ANIMATION_SPRING_WITH_DAMPING: CGFloat = 0.5
let SOLVE_ANIMATION_INITIAL_SPRING_VELOCITY: CGFloat = 6
let SOLVE_ANIMATION_X_Y_SCALE: CGFloat = 1.6

enum SolveAlgorithm {
    case DFS
    case BFS
}

class SolveAlgorithms {
 
    static let BACKTRACE_DELAY_MULTIPLIER = 3
    
    static var nodes: [[Node]] = []
    static var startNode: Node? = nil
    static var endNode: Node? = nil
    static var speed: Float = 0
    
    //MARK: Utilities
    static func reset() {
        ViewController.threadIsCancelled = true
        for nodeRow in SolveAlgorithms.nodes {
            for node in nodeRow {
                node.isVisited = false
                node.type = .space
                node.parent = nil
                
                DispatchQueue.main.async {
                    node.view.backgroundColor = UIColor.systemFill
                }
                
                SolveAlgorithms.startNode = nil
                SolveAlgorithms.endNode = nil
            }
        }
        ViewController.gridIsLocked = false
    }
    
    static func checkStartConditions() -> Bool {
        if SolveAlgorithms.startNode == nil {
            ViewController.showAlert(title: "No Start Node Found!", message: "Please add a start node with the draw start node tool.")
            ViewController.gridIsLocked = false
            return false
        }
        
        else if SolveAlgorithms.endNode == nil {
            ViewController.showAlert(title: "No End Node Found!", message: "Please add an end node with the draw end node tool.")
            ViewController.gridIsLocked = false
            return false
        }
        
        return true
    }
    
    static func updateNode(node: Node, color: UIColor) {
        DispatchQueue.main.async {
            if node.type != .end && node.type != .start && !ViewController.threadIsCancelled {
                
                UIView.animate(withDuration: SOLVE_ANIMATION_DURATION, delay: SOLVE_ANIMATION_DELAY, usingSpringWithDamping: SOLVE_ANIMATION_SPRING_WITH_DAMPING, initialSpringVelocity: SOLVE_ANIMATION_INITIAL_SPRING_VELOCITY, options: .allowUserInteraction, animations: {
                    node.view.transform = CGAffineTransform(scaleX: SOLVE_ANIMATION_X_Y_SCALE, y: SOLVE_ANIMATION_X_Y_SCALE)
                }, completion: nil)
                
                node.view.backgroundColor = color
                
                UIView.animate(withDuration: SOLVE_ANIMATION_DURATION, delay: SOLVE_ANIMATION_DELAY, usingSpringWithDamping: SOLVE_ANIMATION_SPRING_WITH_DAMPING, initialSpringVelocity: SOLVE_ANIMATION_INITIAL_SPRING_VELOCITY, options: .allowUserInteraction, animations: {
                    node.view.transform = CGAffineTransform.identity
                }, completion: nil)
                
            }
            
            else if ViewController.threadIsCancelled {
                SolveAlgorithms.reset()
            }
        }
    }
    
    static func nodeAt(coordinates: (Int, Int)) -> Node {
        return SolveAlgorithms.nodes[coordinates.0][coordinates.1]
    }
    
    static func nodeIsNotVisitedOrWall(coordinates: (Int, Int)) -> Bool {
        return !nodeAt(coordinates: coordinates).isVisited && nodeAt(coordinates: coordinates).type != .wall
    }
    
    static func getStartNodeCoordinates() -> (Int, Int) {
        var startNodeCoordinates: (Int?, Int?) = (nil, nil)
        
        for row in 0...SolveAlgorithms.nodes.count-1 {
            for column in 0...SolveAlgorithms.nodes[row].count-1 {
                if SolveAlgorithms.nodes[row][column].type == .start {
                    startNodeCoordinates = (row, column)
                }
            }
        }
        
        return (startNodeCoordinates.0!, startNodeCoordinates.1!)
    }
    
    static func findSolutionPath() {
        
        if ViewController.threadIsCancelled {
            return
        }
        
        var currentNode = SolveAlgorithms.endNode!.parent
        
        if currentNode == nil {
            ViewController.showAlert(title: "No Path Found.", message: "There is no path present from the start node to the end node.")
            return
        }
        
        while(!ViewController.threadIsCancelled && currentNode !== SolveAlgorithms.startNode) {
            updateNode(node: currentNode!, color: UIColor.systemTeal)
            updateNode(node: currentNode!.parent!, color: UIColor.systemGreen)
            usleep(useconds_t(SolveAlgorithms.speed * Float(BACKTRACE_DELAY_MULTIPLIER)))
            currentNode = currentNode?.parent
        }
        
        if ViewController.solveAlgorithm == .BFS {
            ViewController.showAlert(title: "The Shortest Path Was Found!", message: "It is displayed in teal on the grid.")
        }
        
        else if ViewController.solveAlgorithm == .DFS {
            ViewController.showAlert(title: "A Path Was Found!", message: "It is displayed in teal on the grid.")
        }
    }
    
    //MARK: asyncBFS
    @objc static func asyncBFS() {
        
        if !checkStartConditions() {
            return 
        }
        
        let queue = Queue<(Int?, Int?)>()
        queue.enQueue(item: getStartNodeCoordinates())
        
        while queue.size > 0 {
            
            if ViewController.threadIsCancelled {
                SolveAlgorithms.reset()
                return
            }
            
            let currentCoordinates = queue.deQueue()
            let currentNode = SolveAlgorithms.nodes[currentCoordinates.0!][currentCoordinates.1!]
            
            if currentNode === SolveAlgorithms.endNode {
                break
            }
            
            if currentNode.isVisited || currentNode.type == .wall {
                continue
            }
            
            currentNode.isVisited = true
            updateNode(node: currentNode, color: UIColor.systemYellow)
            
            //go right
            let rightCoordinates = (currentCoordinates.0!, currentCoordinates.1!+1)
            if rightCoordinates.1 <= SolveAlgorithms.nodes[rightCoordinates.0].count-1 && nodeIsNotVisitedOrWall(coordinates: rightCoordinates) {
                SolveAlgorithms.asyncBFShelper(queue: queue, coordinates: rightCoordinates, currentNode: currentNode)
            }
            
            //go up
            let upCoordinates = (currentCoordinates.0!-1, currentCoordinates.1!)
            if upCoordinates.0 >= 0 && nodeIsNotVisitedOrWall(coordinates: upCoordinates) {
                SolveAlgorithms.asyncBFShelper(queue: queue, coordinates: upCoordinates, currentNode: currentNode)
            }
            
            // go left
            let leftCoordinates = (currentCoordinates.0!, currentCoordinates.1!-1)
            if leftCoordinates.1 >= 0 && nodeIsNotVisitedOrWall(coordinates: leftCoordinates) {
                SolveAlgorithms.asyncBFShelper(queue: queue, coordinates: leftCoordinates, currentNode: currentNode)
            }
            
            //go down
            let downCoordinates = (currentCoordinates.0!+1, currentCoordinates.1!)
            if downCoordinates.0 <= SolveAlgorithms.nodes.count-1 && nodeIsNotVisitedOrWall(coordinates: downCoordinates) {
                SolveAlgorithms.asyncBFShelper(queue: queue, coordinates: downCoordinates, currentNode: currentNode)
            }
        }
        
        findSolutionPath()
    }
    
    static func asyncBFShelper(queue: Queue<(Int?, Int?)>, coordinates: (Int, Int), currentNode: Node) {
        queue.enQueue(item: coordinates)
        let nextNode = nodeAt(coordinates: coordinates)
        nextNode.parent = currentNode
        SolveAlgorithms.updateNode(node: nextNode, color: UIColor.systemGreen)
        usleep(useconds_t(SolveAlgorithms.speed))
    }
    
    //MARK: asyncDFS
    @objc static func asyncDFS() {
        
        if !checkStartConditions() {
            return
        }
        
        _ = asyncDFSrecursive(currentCoordinates: getStartNodeCoordinates())
        findSolutionPath()
    }
    
    static func asyncDFSrecursive(currentCoordinates: (Int, Int)) -> Bool {
        
        let currentNode = nodeAt(coordinates: currentCoordinates)
        
        if currentNode.type == .end  || ViewController.threadIsCancelled {
            return true
        }
        
        currentNode.isVisited = true
        updateNode(node: currentNode, color: UIColor.systemYellow)
        usleep(useconds_t(SolveAlgorithms.speed))
        
        //go right
        let rightCoordinates = (currentCoordinates.0, currentCoordinates.1+1)
        if rightCoordinates.1 <= SolveAlgorithms.nodes[rightCoordinates.0].count-1 && nodeIsNotVisitedOrWall(coordinates: rightCoordinates) {
            if asyncDFSrecursiveHelper(nextCoordinates: rightCoordinates, currentCoordinates: currentCoordinates) {
                return true
            }
        }
        
        //go up
        let upCoordinates = (currentCoordinates.0-1, currentCoordinates.1)
        if upCoordinates.0 >= 0 && nodeIsNotVisitedOrWall(coordinates: upCoordinates) {
            if asyncDFSrecursiveHelper(nextCoordinates: upCoordinates, currentCoordinates: currentCoordinates) {
                return true
            }
        }
        
        // go left
        let leftCoordinates = (currentCoordinates.0, currentCoordinates.1-1)
        if leftCoordinates.1 >= 0 && nodeIsNotVisitedOrWall(coordinates: leftCoordinates) {
            if asyncDFSrecursiveHelper(nextCoordinates: leftCoordinates, currentCoordinates: currentCoordinates) {
                return true
            }
        }
        
        //go down
        let downCoordinates = (currentCoordinates.0+1, currentCoordinates.1)
        if downCoordinates.0 <= SolveAlgorithms.nodes.count-1 && nodeIsNotVisitedOrWall(coordinates: downCoordinates) {
            if asyncDFSrecursiveHelper(nextCoordinates: downCoordinates, currentCoordinates: currentCoordinates) {
                return true
            }
        }
        
        return false
    }
    
    static func asyncDFSrecursiveHelper(nextCoordinates: (Int, Int), currentCoordinates: (Int, Int)) -> Bool {
        var isDone = false
        nodeAt(coordinates: nextCoordinates).parent = nodeAt(coordinates: currentCoordinates)
        SolveAlgorithms.updateNode(node: nodeAt(coordinates: nextCoordinates), color: UIColor.systemGreen)
        usleep(useconds_t(SolveAlgorithms.speed))
        isDone = asyncDFSrecursive(currentCoordinates: nextCoordinates)
        
        if isDone {
            return true
        }
            
        return false
    }
}
