import UIKit
import Parse 

class ChartViewController: UIViewController, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource {

    var moods = [PFObject]()
    var moodCount = Int()
    var moodAverage = 0

    let userID = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    @IBOutlet weak var chartView: BEMSimpleLineGraphView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var checkIn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIn.layer.cornerRadius = 25
        checkIn.layer.masksToBounds = true
        
        loadMoods()
        beautifyGraph()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        loadMoods() //Update with latest data point after unwind
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
        query.cachePolicy = .CacheElseNetwork
        
        query.whereKey("user", equalTo: userID)

        query.findObjectsInBackgroundWithBlock
            { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.moods = objects
                    self.chartView.reloadGraph() // This doesn't seem to be the right place to put this, but when I move it around I get more bugs
                    
                    query.countObjectsInBackgroundWithBlock { (count: Int32, error: NSError?) -> Void in
                        if error == nil {
                            var moodCount = count
                            
                            /*
                            if count != 0 {
                                //how do i get all of the ratings from Parse? confused
                                var sum = 0
                                for rating in ratings {
                                    sum += rating
                                }
                                var moodAverage = sum/count
                            }
                            
                            */
                            
                            self.dateLabel.text = "\(moodCount) checkins"
                            self.ratingLabel.text = "Average mood:"
                            self.commentLabel.text = "\(self.moodAverage)"
                        }
                    }
                }
            } else {
                var alert = UIAlertController(title: "Whoops!", message: "Looks we're having some trouble finding your moods. Check back later.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    

    
    
    // Set up BEM line graph
    
    func beautifyGraph(){

        self.chartView.enableBezierCurve = true
        self.chartView.animationGraphStyle = BEMLineAnimation.Draw
        
        self.chartView.displayDotsWhileAnimating = true
        self.chartView.alwaysDisplayDots = true
        self.chartView.sizePoint = 10
        
        self.chartView.averageLine.enableAverageLine = true
        self.chartView.averageLine.alpha = 0.5
        self.chartView.averageLine.width = 1
        
        self.chartView.enableTopReferenceAxisFrameLine = true
        
        self.chartView.enableXAxisLabel = true
        self.chartView.colorXaxisLabel = UIColor.wetAsphaltColor()
        
        self.chartView.colorTouchInputLine = UIColor.wetAsphaltColor()
        
        self.chartView.noDataLabelColor = UIColor.whiteColor()
        self.chartView.noDataLabelFont = UIFont (name: "Avenir Book", size: 18)!
        
        self.chartView.enableTouchReport = true
    }
    
    
    // If no data points available, show a prompt to add a mood
    
    func noDataLabelTextForLineGraph(graph: BEMSimpleLineGraphView) -> String {
        return "Add a mood to get started."
    }
    
    func lineGraph(graph: BEMSimpleLineGraphView, didTouchGraphWithClosestIndex index: Int) {
        
        var mood = self.moods[index]
        
        var date = mood.createdAt!
        var rating = mood["rating"] as? CGFloat
        var comment = mood["comment"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(date)
        
        dateLabel.text = dateString
        ratingLabel.text = "Rating: \(rating!)"
        commentLabel.text = comment
    }
    
    
    func lineGraph(graph: BEMSimpleLineGraphView, didReleaseTouchFromGraphWithClosestIndex index: CGFloat) {
        
        self.dateLabel.text = "\(moodCount) checkins" //BUG: This reverts to 0. Need to make the count accessible globally, not sure how without using loadMood here and having the chart refresh, which looks terrible
        self.ratingLabel.text = "Average mood:"
        self.commentLabel.text = "TBD"
    }
    
    
    func numberOfPointsInLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return self.moods.count
    }
    
    
    func lineGraph(graph: BEMSimpleLineGraphView, valueForPointAtIndex index: Int) -> CGFloat {
        return self.moods[index]["rating"] as! CGFloat
    }
    
    
    func lineGraph(graph: BEMSimpleLineGraphView, labelOnXAxisForIndex index: Int) -> String {
        var mood = self.moods[index]
        var date = mood.createdAt!
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        
        let dateString = formatter.stringFromDate(date)
        
        return dateString
    }
    

    func numberOfGapsBetweenLabelsOnLineGraph(graph: BEMSimpleLineGraphView) -> Int {
        return 1
    }
    
    
    func minValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return 1
    }
    
    
    func maxValueForLineGraph(graph: BEMSimpleLineGraphView) -> CGFloat {
        return 10
    }

}
