//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Juan Pablo Peñaloza Botero on 6/2/16.
//  Copyright © 2016 Juan Pablo Peñaloza Botero. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject] () // Double if is an operand string if is an operation
    var description = ""
    private var isEqualPressed = false
    private var accumulatorAlreadyAppended = false
    private var unitaryOperationPerformed = false
    
    func setOperand (operand: Double)  {
        accumulator = operand
        internalProgram.append(operand) // The bridgeing makes this work!
        if unitaryOperationPerformed {
            description = ""
            unitaryOperationPerformed = false
            accumulatorAlreadyAppended = false
        }
    }
    
    func setDescription (newElement: String) {
        if (newElement != "=") {
            description += newElement
        }

    }
    
    func addUnitaryOperationToDescription (newSymbol: String) -> String {
        if isEqualPressed && newSymbol != "="{
            description = newSymbol + "(" + description + ")"
            return ""
        } else {
            return newSymbol + "(" + String(accumulator) + ")"
        }

    }

    private var operations: Dictionary <String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant (M_E),
        "√" : Operation.UnitaryOperation (sqrt),
        "cos" : Operation.UnitaryOperation (cos),
        "×" : Operation.BinaryOperation( {$1 * $0} ),
        "÷" : Operation.BinaryOperation( {$0 / $1} ),
        "+" : Operation.BinaryOperation( {$1 + $0} ),
        "−" : Operation.BinaryOperation( {$0 - $1} ),
        "AC": Operation.ClearDisplay,
        "±" : Operation.UnitaryOperation( {-$0} ),
        "^" : Operation.BinaryOperation(pow),
        "log2": Operation.UnitaryOperation(log2),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant (Double)
        case UnitaryOperation ((Double) -> Double)
        case BinaryOperation ((Double, Double) -> Double)
        case ClearDisplay
        case Equals
    }
    
    func performOperantion (symbol: String) {
        internalProgram.append(symbol)
        var toAppend = ""
        if let operation = operations [symbol] {
            switch operation {
            case .Constant (let value) :
                toAppend += symbol
                accumulator = value
                accumulatorAlreadyAppended = true
                unitaryOperationPerformed = true
            case .UnitaryOperation (let function):
                toAppend = addUnitaryOperationToDescription(symbol)
                accumulator = function(accumulator)
                accumulatorAlreadyAppended = true
                unitaryOperationPerformed = true
            case .BinaryOperation(let function):
                unitaryOperationPerformed = false
                toAppend = getToAppendBinaryOperation(symbol, accumulator: accumulator)
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo (binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                isEqualPressed = true
                toAppend = getPendingOperator()
                executePendingBinaryOperation()
                accumulatorAlreadyAppended = true
            case .ClearDisplay:
                clear()
            }
        }
        setDescription(toAppend)
        toAppend = ""
    }
    
    private func getPendingOperator () -> String {
        if (accumulatorAlreadyAppended == false && pending != nil) {
            return String(accumulator)
        } else {
            return ""
        }
    }
    
    private func getToAppendBinaryOperation (symbol: String, accumulator: Double) -> String {
        if accumulatorAlreadyAppended {
            accumulatorAlreadyAppended = false
            return symbol
        } else {
            return String(accumulator) + symbol
        }
    }
    
    private func executePendingBinaryOperation () {
        if (pending != nil) {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var isPartialResult: Bool {
        get {
            if pending == nil {
                return false
            } else {
                return true
            }
        }
    }
    
    typealias PropertyList = AnyObject // We do this for documentation
    
    var program: PropertyList {
        get {
            return internalProgram // Returns a copy of my array, not The array
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] { // Cast to array of AnyObject
                for op in arrayOfOps {
                    if let operand = op as? Double { // Tries to cast the element into a Double
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperantion(operation)
                    }
                }
            }
        }
    }
    
    func clear () {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
        description.removeAll()
        isEqualPressed = false // New
        accumulatorAlreadyAppended = false // New
        unitaryOperationPerformed = false
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
