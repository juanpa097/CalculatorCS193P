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
            return Double (display.text!)!
        }
        set {
            display.text = String(newValue)
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
        }
        displayValue = brain.result
    }
    
    @IBAction private func addFlotingPoint(sender: UIButton) {
        let decimalRemainder = displayValue - floor(displayValue)
        if decimalRemainder == 0 {
            touchDigit(sender)
        }
    }
    
}


