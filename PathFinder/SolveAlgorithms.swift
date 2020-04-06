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
    
    static func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            SolveAlgorithms.viewController!.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc static func asyncBFS() {
        
        if SolveAlgorithms.startNode == nil {
            showAlert(title: "No Start Node Found!", message: "Please add a start node with the draw start node tool.")
            return
        }
        
        else if SolveAlgorithms.endNode == nil {
            showAlert(title: "No End Node Found!", message: "Please add an end node with the draw end node tool.")
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
            
            let currentCoordinates = queue.deQueue()
            let currentNode = SolveAlgorithms.nodes[currentCoordinates.0!][currentCoordinates.1!]
            
            if currentNode === SolveAlgorithms.endNode {
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
            if rightCoordinates.1 <= SolveAlgorithms.nodes[rightCoordinates.0].count-1 && !SolveAlgorithms.nodes[rightCoordinates.0][rightCoordinates.1].isVisited && SolveAlgorithms.nodes[rightCoordinates.0][rightCoordinates.1].type != .wall {
                queue.enQueue(item: rightCoordinates)
                
                let rightNode = SolveAlgorithms.nodes[rightCoordinates.0][rightCoordinates.1]
                rightNode.parent = currentNode
                
                DispatchQueue.main.async {
                    
                    if rightNode.type != .end && rightNode.type != .start {
                        rightNode.view.backgroundColor = UIColor.systemGreen
                    }
                    
                }
                usleep(useconds_t(SolveAlgorithms.speed))
            }
            
            //go up
            let upCoordinates = (currentCoordinates.0!-1, currentCoordinates.1!)
            if upCoordinates.0 >= 0 && !SolveAlgorithms.nodes[upCoordinates.0][upCoordinates.1].isVisited && SolveAlgorithms.nodes[upCoordinates.0][upCoordinates.1].type != .wall {
                queue.enQueue(item: upCoordinates)
                
                let upNode = SolveAlgorithms.nodes[upCoordinates.0][upCoordinates.1]
                upNode.parent = currentNode
                
                DispatchQueue.main.async {
                    
                    if upNode.type != .end && upNode.type != .start {
                        upNode.view.backgroundColor = UIColor.systemGreen
                    }
                    
                }
                usleep(useconds_t(SolveAlgorithms.speed))
                
            }
            
            // go left
            let leftCoordinates = (currentCoordinates.0!, currentCoordinates.1!-1)
            if leftCoordinates.1 >= 0 && !SolveAlgorithms.nodes[leftCoordinates.0][leftCoordinates.1].isVisited && SolveAlgorithms.nodes[leftCoordinates.0][leftCoordinates.1].type != .wall {
                queue.enQueue(item: leftCoordinates)
                
                let leftNode = SolveAlgorithms.nodes[leftCoordinates.0][leftCoordinates.1]
                leftNode.parent = currentNode
                
                DispatchQueue.main.async {
                    
                    if leftNode.type != .end && leftNode.type != .start {
                        leftNode.view.backgroundColor = UIColor.systemGreen
                    }
                    
                }
                usleep(useconds_t(SolveAlgorithms.speed))
                
            }
            
            //go down
            let downCoordinates = (currentCoordinates.0!+1, currentCoordinates.1!)
            if downCoordinates.0 <= SolveAlgorithms.nodes.count-1 && !SolveAlgorithms.nodes[downCoordinates.0][downCoordinates.1].isVisited && SolveAlgorithms.nodes[downCoordinates.0][downCoordinates.1].type != .wall {
                queue.enQueue(item: downCoordinates)
                
                let downNode = SolveAlgorithms.nodes[downCoordinates.0][downCoordinates.1]
                downNode.parent = currentNode
                
                DispatchQueue.main.async {
                    
                    if downNode.type != .end && downNode.type != .start {
                        downNode.view.backgroundColor = UIColor.systemGreen
                    }
                    
                }
                usleep(useconds_t(SolveAlgorithms.speed))
                
            }
            
        }
        
        var currentNode = SolveAlgorithms.endNode!.parent
        
        if currentNode == nil {
            showAlert(title: "No Path Found.", message: "There is no path present from the start node to the end node.")
            return
        }
        
        
        while(currentNode !== SolveAlgorithms.startNode) {
            
            DispatchQueue.main.async {
                
                if currentNode!.type != .end && currentNode!.type != .start {
                    currentNode!.view.backgroundColor = UIColor.systemTeal
                }
                
            }
            
            usleep(useconds_t(SolveAlgorithms.speed*3))
            
            currentNode = currentNode?.parent
            
        }
        
        showAlert(title: "The Shortest Path Was Found!", message: "It is displayed in teal on the grid.")
        
    }

    
}
