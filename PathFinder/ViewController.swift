//
//  ViewController.swift
//  PathFinder
//
//  Created by AJ Radik on 3/23/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let GRID_SIZE = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeStacks()
        initializeButtons()
        
    }
    
    var buttons: [UIButton]! = []
    var horizontalStacks: [UIStackView] = []
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(false)
        super.touchesMoved(touches, with: event)
        guard let touch = event?.allTouches?.first else {return}
        buttons.forEach { (button) in
            if button.frame.contains(touch.location(in: button.superview)) {
                button.backgroundColor = UIColor.systemGreen
                print(true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(false)
        super.touchesBegan(touches, with: event)
        guard let touch = event?.allTouches?.first else {return}
        buttons.forEach { (button) in
            if button.frame.contains(touch.location(in: button.superview)) {
                button.backgroundColor = UIColor.systemGreen
                print(true)
            }
        }
    }
    
    func initializeStacks() {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 3
        
        let verticalStackConstraints: [NSLayoutConstraint] = [
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor, constant: -20),
            verticalStack.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5),
//            verticalStack.centerYAnchor.constraint(equalToSystemSpacingBelow: self.view.centerYAnchor, multiplier: 0.8),
            NSLayoutConstraint(item: verticalStack, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 0.8, constant: 0)
        ]
        
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStack)
        NSLayoutConstraint.activate(verticalStackConstraints)
        
        
        for _ in 1...GRID_SIZE {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = 3
            horizontalStacks.append(horizontalStackView)
            verticalStack.addArrangedSubview(horizontalStackView)
        }
        
    }
    
    func initializeButtons() {
        for horizontalStack in horizontalStacks {
            for _ in 1...GRID_SIZE {
                let button = UIButton()
                button.backgroundColor = UIColor.systemGray
                button.cornerRadius = 3
                
                horizontalStack.addArrangedSubview(button)
                buttons.append(button)
                
            }
        }
    }
    
}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
    
}

@IBDesignable
class DesignableLabel: UILabel {
}

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
