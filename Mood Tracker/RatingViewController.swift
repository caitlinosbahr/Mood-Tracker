import UIKit
import Parse

class RatingViewController: UIViewController {
    
    @IBOutlet weak var ratingSlider: UISlider!
    
    @IBAction func swipedBack(sender: AnyObject) {
//        performSegueWithIdentifier("unwindToMain", sender: AnyObject?)
        //TODO: GET THIS TO UNWIND
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addComment" {
            var destinationVC = segue.destinationViewController as! CommentViewController
            destinationVC.passedInRating = ratingSlider.value
        }
    }
    
    @IBAction func returnToRating(segue: UIStoryboardSegue) {
    }
}