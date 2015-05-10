import UIKit
import Parse

class RatingViewController: UIViewController {
    
    @IBOutlet weak var ratingSlider: UISlider!
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "swipedBack")
        screenEdgeRecognizer.edges = .Left
        view.addGestureRecognizer(screenEdgeRecognizer)
    }
    
    
    @IBAction func sliderChanged(sender: AnyObject) {
        
        //Trying to use pod UIColor+CrossFade and failing
        var colorA = UIColor.wetAsphaltColor()
        var colorB = UIColor.turquoiseColor()
        
        var sliderRatio = self.ratingSlider.value/10
                
//        var crossFade: UIColor = UIColor.colorsForFadeBetweenFirstColor(colorA, lastColor: colorB, atRatio: sliderRatio)
        
//        self.view.backgroundColor = crossFade
        
    }
    

    // MARK: - Navigation
    
    func swipedBack(){
        performSegueWithIdentifier("unwindToMain", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addComment" {
            var destinationVC = segue.destinationViewController as! CommentViewController
            destinationVC.passedInRating = ratingSlider.value
        }
    }
    
    @IBAction func returnToRating(segue: UIStoryboardSegue) {
    }
    

    
}