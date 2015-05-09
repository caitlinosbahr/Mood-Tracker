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
        
        checkIn.layer.cornerRadius = 30
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
        self.transition.animationColor = UIColor.greenSeaColor()
        self.transition.fromViewController = self
        self.transition.toViewController = destinationViewController
        destinationViewController.transitioningDelegate = transition
    }
    
    
    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // Retrieve Parse data
    
    func loadMoods() {
        var query = PFQuery(className:"Moods")
        
        query.whereKey("user", equalTo: userID)

        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.moods = objects
                }
                self.chartView.reloadGraph()
            } else { // Show alert
                var alert = UIAlertController(title: "Whoops!", message: "Looks we're having some trouble finding your moods. Check back later.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // If no data points available, show a prompt to add a mood
    
    func noDataLabelTextForLineGraph(graph: BEMSimpleLineGraphView) -> String {
        return "Add a mood to get started"
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
        
        self.chartView.noDataLabelColor = UIColor.redColor()
        self.chartView.noDataLabelFont = UIFont (name: "Helvetica Neue", size: 30)!
        
        self.chartView.enableTouchReport = true
        self.chartView.enablePopUpReport = false
        
        self.chartView.enableReferenceAxisFrame = true
    }
    
    
    func lineGraph(graph: BEMSimpleLineGraphView, didTouchGraphWithClosestIndex index: Int) {
        
        var mood = self.moods[index]
        
        var date = mood.createdAt!.description as String
        var rating = mood["rating"] as? CGFloat
        var ratingString = "\(rating!)"
        var comment = mood["comment"] as? String
        
        dateLabel.text = date
        ratingLabel.text = ratingString
        commentLabel.text = comment
    }
    
    
    func lineGraph(graph: BEMSimpleLineGraphView, didReleaseTouchFromGraphWithClosestIndex index: CGFloat) {
        //
    }
    

    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return self.moods.count //TODO: this should return the appropriate number of points based on user input eventually
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return self.moods[index]["rating"] as! CGFloat
    }
    
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        
        var mood = self.moods[index]
        var date = mood.createdAt!.description as String //TODO: make date format prettier?
        
        return date
    }


    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 4
    }
    
    func minValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return 1
    }
    
    func maxValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return 10
    }

}
