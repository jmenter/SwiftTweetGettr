
import UIKit

class TweetCell : UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var handleTextField: UILabel!
    @IBOutlet weak var statusTextField: UILabel!
    
    func applyTweet(tweet:Tweet) -> Void
    {
        nameTextField.text = tweet.name
        handleTextField.text = tweet.screenName
        statusTextField.text = tweet.text
        userImageView.image = tweet.userImage
        userImageView.loadURL(tweet.biggerProfileImageURL!)
    }
}