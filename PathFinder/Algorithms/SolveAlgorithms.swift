//
//  SolveAlgorithms.swift
//  PathFinder
//
//  Created by AJ Radik on 4/6/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

enum SolveAlgorithm {
    case DFS
    case BFS
}

class SolveAlgorithms {
 
    static var nodes: [[Node]] = []
    static var startNode: Node? = nil
    static var endNode: Node? = nil
    static var speed: Float = 0
    
    static var viewController: UIViewController? = nil
    
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
    }
    
    static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            
            if !ViewController.threadIsCancelled {
                SolveAlgorithms.viewController!.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    static func checkStartConditions() -> Bool {
        if SolveAlgorithms.startNode == nil {
            showAlert(title: "No Start Node Found!", message: "Please add a start node with the draw start node tool.")
            return false
        }
        
        else if SolveAlgorithms.endNode == nil {
            showAlert(title: "No End Node Found!", message: "Please add an end node with the draw end node tool.")
            return false
        }
        
        return true
    }
    
    static func updateNode(node: Node, color: UIColor) {
        DispatchQueue.main.async {
            if node.type != .end && node.type != .start && !ViewController.threadIsCancelled {
                node.view.backgroundColor = color
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
    
    //MARK: asyncBFS
    @objc static func asyncBFS() {
        
        if !checkStartConditions() {
            return 
        }
        
        var startNodeCoordinates: (Int?, Int?) = (nil, nil)
        
        for row in 0...SolveAlgorithms.nodes.count-1 {
            for column in 0...SolveAlgorithms.nodes[row].count-1 {
                if SolveAlgorithms.nodes[row][column] === SolveAlgorithms.startNode! {
                    startNodeCoordinates = (row, column)
                }
            }
        }
        
        let queue = Queue<(Int?, Int?)>()
        queue.enQueue(item: startNodeCoordinates)
        
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
            if rightCoordinates.1 <= SolveAlgorithms.nodes[rightCoordinates.0].count-1 && !SolveAlgorithms.nodes[rightCoordinates.0][rightCoordinates.1].isVisited && SolveAlgorithms.nodes[rightCoordinates.0][rightCoordinates.1].type != .wall {
                SolveAlgorithms.asyncBFShelper(queue: queue, coordinates: rightCoordinates, currentNode: currentNode)
            }
            
            //go up
            let upCoordinates = (currentCoordinates.0!-1, currentCoordinates.1!)
            if upCoordinates.0 >= 0 && !SolveAlgorithms.nodes[upCoordinates.0][upCoordinates.1].isVisited && SolveAlgorithms.nodes[upCoordinates.0][upCoordinates.1].type != .wall {
                SolveAlgorithms.asyncBFShelper(queue: queue, coordinates: upCoordinates, currentNode: currentNode)
            }
            
            // go left
            let leftCoordinates = (currentCoordinates.0!, currentCoordinates.1!-1)
            if leftCoordinates.1 >= 0 && !SolveAlgorithms.nodes[leftCoordinates.0][leftCoordinates.1].isVisited && SolveAlgorithms.nodes[leftCoordinates.0][leftCoordinates.1].type != .wall {
                SolveAlgorithms.asyncBFShelper(queue: queue, coordinates: leftCoordinates, currentNode: currentNode)
            }
            
            //go down
            let downCoordinates = (currentCoordinates.0!+1, currentCoordinates.1!)
            if downCoordinates.0 <= SolveAlgorithms.nodes.count-1 && !SolveAlgorithms.nodes[downCoordinates.0][downCoordinates.1].isVisited && SolveAlgorithms.nodes[downCoordinates.0][downCoordinates.1].type != .wall {
                SolveAlgorithms.asyncBFShelper(queue: queue, coordinates: downCoordinates, currentNode: currentNode)
            }
        }
        
        var currentNode = SolveAlgorithms.endNode!.parent
        
        if currentNode == nil {
            showAlert(title: "No Path Found.", message: "There is no path present from the start node to the end node.")
            return
        }
        
        while(currentNode !== SolveAlgorithms.startNode) {
            updateNode(node: currentNode!, color: UIColor.systemTeal)
            usleep(useconds_t(SolveAlgorithms.speed*5))
            currentNode = currentNode?.parent
        }
        showAlert(title: "The Shortest Path Was Found!", message: "It is displayed in teal on the grid.")
    }
    
    static func asyncBFShelper(queue: Queue<(Int?, Int?)>, coordinates: (Int, Int), currentNode: Node) {
        queue.enQueue(item: coordinates)
        let nextNode = nodeAt(coordinates: coordinates)
        nextNode.parent = currentNode
        SolveAlgorithms.updateNode(node: nextNode, color: UIColor.systemGreen)
        usleep(useconds_t(SolveAlgorithms.speed))
    }
    
}
