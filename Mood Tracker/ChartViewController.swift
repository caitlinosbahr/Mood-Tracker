import UIKit
import Parse //Need to import here so we can read from the users previous ratings to present them

class ChartViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var chartView: BEMSimpleLineGraphView!
    
    @IBAction func checkIn(sender: AnyObject) {
        self.performSegueWithIdentifier("checkinSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "checkinSegue" {
            println("segue will happen")
        }
    }
    
    
    // SET UP FOR LINE GRAPH

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView!) -> Int {

        return 7
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView!, valueForPointAtIndex index: Int) -> CGFloat {

        return CGFloat(10)
 
    }
    
    

}
