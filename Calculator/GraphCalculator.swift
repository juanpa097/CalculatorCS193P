//
//  GraphCalculator.swift
//  Calculator
//
//  Created by Juan Pablo Peñaloza Botero on 7/4/16.
//  Copyright © 2016 Juan Pablo Peñaloza Botero. All rights reserved.
//

import UIKit
@IBDesignable // Tag to make the draw on the storyboard

class GraphCalculator: UIView {
    
    private var scale: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    private var lineWidth: CGFloat = 1.0
    private var pathForXAxis = UIBezierPath() {
        didSet {
            setNeedsDisplay()
            print("Set")
        }
    }
    var descriptionFunction = "" { didSet { print(descriptionFunction) } }
    
    private func drawInitialStateOfYAxis () {
        let startPoint = CGPoint (x: 0, y: bounds.midY)
        let endPoint = CGPoint (x: bounds.maxX, y: bounds.midY)
        pathForXAxis.moveToPoint(startPoint)
        pathForXAxis.addLineToPoint(endPoint)
        pathForXAxis.lineWidth = lineWidth
    }
    
    func panOverGraph (recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Changed: fallthrough
        case .Ended:
            let translation = recognizer.translationInView(self)
            var newPoint = pathForXAxis.currentPoint
            newPoint.x += translation.x
            newPoint.y += translation.y
            print("x: \(newPoint.y)")
            pathForXAxis.moveToPoint(newPoint)
            pathForXAxis.stroke()
            setNeedsDisplay()
        default: break
        }
    }

    override func drawRect(rect: CGRect) {
        UIColor.blackColor().set()
        drawInitialStateOfYAxis()
        pathForXAxis.stroke()
    }
 

}
