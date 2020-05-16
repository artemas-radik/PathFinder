//
//  Node.swift
//  PathFinder
//
//  Created by AJ Radik on 4/6/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

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
    
    var f: Int?
    var g: Int?
    var h: Int?
    
    init(view: UIView) {
        self.view = view
    }
    
}
