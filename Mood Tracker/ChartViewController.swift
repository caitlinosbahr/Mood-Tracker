import UIKit
import Parse 

class ChartViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource {

    var moods = [PFObject]()
    let userID = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    @IBOutlet weak var chartView: BEMSimpleLineGraphView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var checkIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIn.layer.cornerRadius = 40
        checkIn.layer.masksToBounds = true
        
        loadMoods()
        beautifyGraph()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadMoods() //Show latest data point after unwind
    }
    
    // Fancy segue to check-in
    
    var transition = QZCircleSegue()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! RatingViewController
        self.transition.animationChild = checkIn
        self.transition.animationColor = UIColor.blueColor()
        self.transition.fromViewController = self
        self.transition.toViewController = destinationViewController
        destinationViewController.transitioningDelegate = transition
    }
    
    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
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
                println("loaded moods")
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
//        self.chartView.alphaLine = 1.0
//        self.chartView.alphaTouchInputLine = 1.0
//        self.chartView.widthLine = 3.0
        
        self.chartView.colorXaxisLabel = UIColor.blueColor()
        self.chartView.colorYaxisLabel = UIColor.blueColor()
        self.chartView.colorTouchInputLine = UIColor.whiteColor()
        self.chartView.colorBottom = UIColor.clearColor()
        self.chartView.colorTop = UIColor.blueColor()
        
        self.chartView.enableTouchReport = true
        self.chartView.enablePopUpReport = true //Is there a way to make this into a float vs. an int?
        
        self.chartView.enableReferenceAxisFrame = true
        
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView!, didTouchGraphWithClosestIndex index: Int) {
        
        var mood = self.moods[index]
        
        var date = mood.createdAt!.description as String
        var rating = mood["rating"] as? String
        var comment = mood["comment"] as? String
        
        println(date)
        println(rating)
        println(comment)
        
        dateLabel.text = mood.createdAt!.description as String
        ratingLabel.text = mood["rating"] as? String
        commentLabel.text = mood["comment"] as? String

    }
    
    func lineGraph(graph: BEMSimpleLineGraphView!, didReleaseTouchFromGraphWithClosestIndex index: CGFloat) {
        //
    }
    

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView!) -> Int {
        return self.moods.count //TODO: this should return the appropriate number of points based on the segmented controller
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView!, valueForPointAtIndex index: Int) -> CGFloat {
        return self.moods[index]["rating"] as! CGFloat
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView!, labelOnXAxisForIndex index: Int) -> String! {
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateStyle = .ShortStyle
//        
//        var dateLabel = String()
//        dateLabel = dateFormatter.stringFromDate(NSDate(self.moods[index].createdAt?.description))
        
        return self.moods[index].createdAt?.description //TODO: Figure out a nicer way to present the date stamps
    }

    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView!) -> Int {
        return 4
    }
    
    func minValueForLineGraph(graph: BEMSimpleLineGraphView!) -> CGFloat {
        return 1
    }
    
    func maxValueForLineGraph(graph: BEMSimpleLineGraphView!) -> CGFloat {
        return 10
    }

}
