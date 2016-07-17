//
//  GraphViewController.swift
//  Calculator
//
//  Created by Juan Pablo Peñaloza Botero on 7/4/16.
//  Copyright © 2016 Juan Pablo Peñaloza Botero. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {
    
    
    @IBOutlet weak var graph: GraphCalculator! {
        didSet {
            let recognizer = UIPanGestureRecognizer (
                target: graph,
                action: #selector(GraphCalculator.panOverGraph(_:))
            )
            graph.addGestureRecognizer(recognizer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
