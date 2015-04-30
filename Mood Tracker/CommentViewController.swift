import UIKit
import Parse

class CommentViewController: UIViewController {
    
    var moods = [PFObject]()
    var passedInRating = Float()


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var commentText: UITextField!

    @IBAction func saveMood(sender: AnyObject) {
        
        navigationController?.popToRootViewControllerAnimated(true) //how do I get the animation dismissing like a modal view?
        
        var mood = PFObject(className:"Moods")
        
        let comment = commentText.text
        mood["comment"] = comment
        
        let rating = passedInRating //rating value needs to get passed from previous screen
        mood["rating"] = rating
        
        mood.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                println("Mood has been saved.")
            } else {
                println("Error saving mood")
            }
        }
        
    }

}
