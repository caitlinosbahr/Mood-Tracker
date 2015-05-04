import UIKit
import Parse

class RatingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var ratingSlider: UISlider!
    

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