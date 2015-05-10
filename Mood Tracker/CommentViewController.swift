import UIKit
import Parse

class CommentViewController: UIViewController, UITextFieldDelegate {
    
    var moods = [PFObject]()
    var passedInRating = Float()
    var user = String()
    var commentScreenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        commentText.becomeFirstResponder()
        commentText.delegate = self

        saveButton.enabled = false
        saveButton.alpha = 0.5
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "textFieldTextChanged:", name:UITextFieldTextDidChangeNotification, object: nil)
        
        commentScreenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "swipedBackToRating")
        commentScreenEdgeRecognizer.edges = .Left
        view.addGestureRecognizer(commentScreenEdgeRecognizer)
    }
    
    override func viewWillDisappear(animated: Bool) {
        view.removeGestureRecognizer(commentScreenEdgeRecognizer)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func textFieldTextChanged(sender : AnyObject) {
        if commentText.text == "" {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
            saveButton.alpha = 1.0
        }
    }
    
    
    // MARK: - Navigation
    
    func swipedBackToRating(){
        performSegueWithIdentifier("returnToRating", sender: self)
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
                //save it
            } else {
                //Show alert to user
                var alert = UIAlertController(title: "Sorry!", message: "Looks like we had a problem saving your mood.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}