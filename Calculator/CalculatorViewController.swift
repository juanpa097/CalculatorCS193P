//
//  ViewController.swift
//  Calculator
//
//  Created by Juan Pablo Peñaloza Botero on 5/29/16.
//  Copyright © 2016 Juan Pablo Peñaloza Botero. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var variableInserted = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping && !variableInserted {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            variableInserted = false
        }
        userIsInTheMiddleOfTyping = true;
    }
    
    private var displayValue: AnyObject {
        get {
            if let currentValue = Double (display.text!) {
                return currentValue
            } else {
                return display.text!
            }
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction private func save() {
        savedProgram = brain.program
    }
    
    @IBAction private func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    private var brain = CalculatorBrain ()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            if let variableName = displayValue as? String {
                brain.setOperand(variableName)
            } else if let currentValue = displayValue as? Double {
                brain.setOperand(currentValue)
            }
            userIsInTheMiddleOfTyping = false
            variableInserted = false
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
    
    @IBAction private func insertVariable(sender: UIButton) {
        if !userIsInTheMiddleOfTyping {
            touchDigit(sender)
            variableInserted = true
            userIsInTheMiddleOfTyping = true
        }
    }
    
    
    @IBAction private func setValueOfMemory(sender: UIButton) {
        if let currentDisplayContent = display.text {
            brain.setVaulueToM(currentDisplayContent)
            save()
            restore()
            userIsInTheMiddleOfTyping = false
        }
    }
    
    
    @IBAction private func displayValueOfMemory(sender: UIButton) {
        if let buttonCurrentTittle = sender.currentTitle {
            brain.setOperand(buttonCurrentTittle)
            displayValue = brain.result
        }
    }
    
    private struct Storyboard {
        static let showGraph = "segueToGraph"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationvc = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        
        if let graphvc = destinationvc as? GraphViewController {
            if let identifier = segue.identifier {
                if !brain.isPartialResult && identifier == Storyboard.showGraph {
                    graphvc.graph.descriptionFunction = brain.description
                    graphvc.navigationItem.title = brain.description
                }
            }
        }
        
    }
    
    
}


