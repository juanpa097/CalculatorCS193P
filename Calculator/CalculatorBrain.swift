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
    
    func setOperand (operand: Double)  {
        accumulator = operand
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
        if let operation = operations [symbol] {
            switch operation {
            case .Constant (let value) :
                accumulator = value
            case .UnitaryOperation (let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo (binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .ClearDisplay:
                setOperand(0.0)
                pending = nil
            }
        }
    }
    
    private func executePendingBinaryOperation () {
        if (pending != nil) {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
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
