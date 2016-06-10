//
//  ViewController.swift
//  Calculator
//
//  Created by Juan Pablo Peñaloza Botero on 5/29/16.
//  Copyright © 2016 Juan Pablo Peñaloza Botero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var userIsInTheMiddleOfTyping = false;
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true;
    }
    
    private var displayValue: Double {
        get {
            if let currentValue = Double (display.text!) {
                return currentValue
            } else {
                return 0.0
            }
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    private var brain = CalculatorBrain ()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperantion(mathSymbol)
            if brain.isPartialResult {
                descriptionLabel.text = brain.description + "..."
            } else {
                descriptionLabel.text = brain.description + "="
            }
            if mathSymbol == "AC" {
                descriptionLabel.text = " "
            }
        }
        
        displayValue = brain.result
    }
    
    @IBAction private func addFlotingPoint(sender: UIButton) {
        if let currentTittle = display!.text {
            if (currentTittle.rangeOfString(".") == nil || !userIsInTheMiddleOfTyping) {
                touchDigit(sender)
            }
        }
    }
    
}


