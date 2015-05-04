import UIKit
import Parse 

class ChartViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource {

    var moods = [PFObject]()
    let userID = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    @IBOutlet weak var chartView: BEMSimpleLineGraphView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMoods()
        beautifyGraph()
    }
    
    
    // Segue to check-in
    
    @IBAction func checkIn(sender: AnyObject) {
        self.performSegueWithIdentifier("checkinSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "checkinSegue" {
//            println("segue will happen")
        }
    }
    
    
    // Retrieve Parse data
    //TODO: If no data points available, show a prompt
    //TODO: Show a spinner before the chart loads. With the query this is now slow
    
    func loadMoods() {
        var query = PFQuery(className:"Moods")
        
        query.whereKey("user", equalTo: userID)

        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.moods = objects
                }
                self.chartView.reloadGraph()
            } else {
                println("error loading moods") //TODO: show an error dialog

            }
        }
    }
    
    
    // Set up for BEM line graph
    
    func beautifyGraph(){
        self.chartView.enableBezierCurve = true
//        self.chartView.enableYAxisLabel = true
        self.chartView.autoScaleYAxis = true
//        self.chartView.alwaysDisplayDots = true
        self.chartView.alphaLine = 1.0
        self.chartView.colorXaxisLabel = UIColor.whiteColor()
        self.chartView.colorYaxisLabel = UIColor.whiteColor()
        self.chartView.colorTouchInputLine = UIColor.whiteColor()
        self.chartView.alphaTouchInputLine = 1.0
//          self.chartView.widthLine = 3.0
        self.chartView.enableTouchReport = true
        self.chartView.enablePopUpReport = true
//        self.chartView.enableReferenceAxisLines = true
        self.chartView.enableReferenceAxisFrame = true
        self.chartView.reloadGraph()
    }

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView!) -> Int {
        return self.moods.count //TODO: this should return the appropriate number of points based on the segmented controller
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView!, valueForPointAtIndex index: Int) -> CGFloat {
        return self.moods[index]["rating"] as! CGFloat //TODO: Set the min and max of the chart as 1 to 10 based on the values of the slider
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView!, labelOnXAxisForIndex index: Int) -> String! {
        return self.moods[index].createdAt?.description //TODO: Figure out a nicer way to present the date stamps
    }

    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView!) -> Int {
        return 25 //TODO: IDK what this does?
    }
    
//    func minValueForLineGraph(graph: BEMSimpleLineGraphView!) -> CGFloat {
//        return 1
//    }
//    
//    func maxValueForLineGraph(graph: BEMSimpleLineGraphView!) -> CGFloat {
//        return 10
//    }

}
