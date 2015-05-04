import UIKit
import Parse

class CommentViewController: UIViewController {
    
    var moods = [PFObject]()
    var passedInRating = Float()
    var user = String()
    
    @IBOutlet weak var commentText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
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
                println("Error saving mood") //TODO: show a dialog that there was an error
            }
        }
    }
}