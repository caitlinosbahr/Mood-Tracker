//
//  ChartViewController.swift
//  Mood Tracker
//
//  Created by Caitlin Osbahr on 4/27/15.
//  Copyright (c) 2015 Caitlin Osbahr. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var chartView: BEMSimpleLineGraphView!
    
    // SET UP FOR LINE GRAPH

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView!) -> Int {

        return 7
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView!, valueForPointAtIndex index: Int) -> CGFloat {

        return CGFloat(10)
 
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
