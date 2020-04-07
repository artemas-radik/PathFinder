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
    
    static func checkStartConditions() -> Bool {
        if SolveAlgorithms.startNode == nil {
            ViewController.showAlert(title: "No Start Node Found!", message: "Please add a start node with the draw start node tool.")
            return false
        }
        
        else if SolveAlgorithms.endNode == nil {
            ViewController.showAlert(title: "No End Node Found!", message: "Please add an end node with the draw end node tool.")
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
    
    static func getStartNodeCoordinates() -> (Int, Int) {
        var startNodeCoordinates: (Int?, Int?) = (nil, nil)
        
        for row in 0...SolveAlgorithms.nodes.count-1 {
            for column in 0...SolveAlgorithms.nodes[row].count-1 {
                if SolveAlgorithms.nodes[row][column] === SolveAlgorithms.startNode! {
                    startNodeCoordinates = (row, column)
                }
            }
        }
        
        return (startNodeCoordinates.0!, startNodeCoordinates.1!)
    }
    
    static func findSolutionPath() {
        var currentNode = SolveAlgorithms.endNode!.parent
        
        if currentNode == nil {
            ViewController.showAlert(title: "No Path Found.", message: "There is no path present from the start node to the end node.")
            return
        }
        
        while(currentNode !== SolveAlgorithms.startNode) {
            updateNode(node: currentNode!, color: UIColor.systemTeal)
            usleep(useconds_t(SolveAlgorithms.speed*5))
            currentNode = currentNode?.parent
        }
        ViewController.showAlert(title: "A Path Was Found!", message: "It is displayed in teal on the grid.")
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
        
        if currentNode.type == .end {
            return true
        }
        
        currentNode.isVisited = true
        updateNode(node: currentNode, color: UIColor.systemYellow)
        usleep(useconds_t(SolveAlgorithms.speed))
        
        //go right
        var right = false
        let rightCoordinates = (currentCoordinates.0, currentCoordinates.1+1)
        if rightCoordinates.1 <= SolveAlgorithms.nodes[rightCoordinates.0].count-1 && nodeIsNotVisitedOrWall(coordinates: rightCoordinates) {
            nodeAt(coordinates: rightCoordinates).parent = nodeAt(coordinates: currentCoordinates)
            SolveAlgorithms.updateNode(node: nodeAt(coordinates: rightCoordinates), color: UIColor.systemGreen)
            usleep(useconds_t(SolveAlgorithms.speed))
            right = asyncDFSrecursive(currentCoordinates: rightCoordinates)
            if right {
                return true
            }
        }
        
        //go up
        var up = false
        let upCoordinates = (currentCoordinates.0-1, currentCoordinates.1)
        if upCoordinates.0 >= 0 && nodeIsNotVisitedOrWall(coordinates: upCoordinates) {
            nodeAt(coordinates: upCoordinates).parent = nodeAt(coordinates: currentCoordinates)
            SolveAlgorithms.updateNode(node: nodeAt(coordinates: upCoordinates), color: UIColor.systemGreen)
            usleep(useconds_t(SolveAlgorithms.speed))
            up = asyncDFSrecursive(currentCoordinates: upCoordinates)
            if up {
                return true
            }
        }
        
        // go left
        var left = false
        let leftCoordinates = (currentCoordinates.0, currentCoordinates.1-1)
        if leftCoordinates.1 >= 0 && nodeIsNotVisitedOrWall(coordinates: leftCoordinates) {
            nodeAt(coordinates: leftCoordinates).parent = nodeAt(coordinates: currentCoordinates)
            SolveAlgorithms.updateNode(node: nodeAt(coordinates: leftCoordinates), color: UIColor.systemGreen)
            usleep(useconds_t(SolveAlgorithms.speed))
            left = asyncDFSrecursive(currentCoordinates: leftCoordinates)
            if left {
                return true
            }
        }
        
        //go down
        var down = false
        let downCoordinates = (currentCoordinates.0+1, currentCoordinates.1)
        if downCoordinates.0 <= SolveAlgorithms.nodes.count-1 && nodeIsNotVisitedOrWall(coordinates: downCoordinates) {
            nodeAt(coordinates: downCoordinates).parent = nodeAt(coordinates: currentCoordinates)
            SolveAlgorithms.updateNode(node: nodeAt(coordinates: downCoordinates), color: UIColor.systemGreen)
            usleep(useconds_t(SolveAlgorithms.speed))
            down = asyncDFSrecursive(currentCoordinates: downCoordinates)
            if down {
                return true
            }
        }
        
        return false
    }
    
}
