//
//  UIButtonExtension.swift
//  PathFinder
//
//  Created by AJ Radik on 4/7/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
}
