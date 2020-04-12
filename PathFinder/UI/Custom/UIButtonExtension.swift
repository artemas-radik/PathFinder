//
//  UIButtonExtension.swift
//  PathFinder
//
//  Created by AJ Radik on 4/7/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit

let BUTTON_ANIMATION_DURATION = 0.5
let BUTTON_ANIMATION_DELAY: TimeInterval = 0
let BUTTON_ANIMATION_SPRING_WITH_DAMPING: CGFloat = 0.5
let BUTTON_ANIMATION_INITIAL_SPRING_VELOCITY: CGFloat = 6
let BUTTON_ANIMATION_X_Y_SCALE: CGFloat = 1.4

extension UIButton {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        UIView.animate(withDuration: BUTTON_ANIMATION_DURATION, delay: BUTTON_ANIMATION_DELAY, usingSpringWithDamping: BUTTON_ANIMATION_SPRING_WITH_DAMPING, initialSpringVelocity: BUTTON_ANIMATION_INITIAL_SPRING_VELOCITY, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform(scaleX: BUTTON_ANIMATION_X_Y_SCALE, y: BUTTON_ANIMATION_X_Y_SCALE)
        }, completion: nil)
        
        UIView.animate(withDuration: BUTTON_ANIMATION_DURATION, delay: BUTTON_ANIMATION_DELAY, usingSpringWithDamping: BUTTON_ANIMATION_SPRING_WITH_DAMPING, initialSpringVelocity: BUTTON_ANIMATION_INITIAL_SPRING_VELOCITY, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
}
