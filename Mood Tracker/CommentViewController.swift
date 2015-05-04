import UIKit
import Parse

class CommentViewController: UIViewController, UITextFieldDelegate {
    
    var moods = [PFObject]()
    var passedInRating = Float()
    var user = String()
    
    @IBOutlet weak var commentText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        commentText.becomeFirstResponder()
    }
    
    @IBAction func saveMood(sender: AnyObject) {
        
        var mood = PFObject(className:"Moods")
        
        let comment = commentText.text
        mood["comment"] = comment
        
        let rating = passedInRating 
        mood["rating"] = rating
            
        let user = UIDevice.currentDevice().identifierForVendor.UUIDString
        mood["user"] = user
        
        mood.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                println("Mood has been saved.")
            } else {
                println("Error saving mood")
                
                //Show alert to user
                var alert = UIAlertController(title: "Sorry!", message: "Looks like we had a problem saving your mood.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}