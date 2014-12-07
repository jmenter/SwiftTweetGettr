
import UIKit

class ViewController : UIViewController, UITextFieldDelegate {
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    var tweetsTableViewDelegate = TweetsTableViewDelegate()
    
    @IBOutlet var textField : UITextField!
    @IBOutlet var button : UIButton!
    @IBOutlet var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.rightView = spinner
        textField.rightViewMode = .Always
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = button.titleLabel?.textColor.CGColor
        
        tableView.dataSource = tweetsTableViewDelegate
        tableView.delegate = tweetsTableViewDelegate
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if let selected = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow()!, animated: animated)
        }
        if textField.text.isEmpty {
            textField.becomeFirstResponder()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let index = tableView.indexPathForSelectedRow()?.row
        let tweet = tweetsTableViewDelegate.tweets[index!]
        (segue.destinationViewController.view as UITextView).text = tweet.description()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if !textField.text.isEmpty { buttonWasTapped(nil) }
        return textField.resignFirstResponder()
    }

    @IBAction func textFieldDidChange(sender : AnyObject) {
        button.enabled = !textField.text.isEmpty
        button.layer.borderColor = button.titleLabel?.textColor.CGColor
    }

    @IBAction func buttonWasTapped(sender : AnyObject?) {
        textField.resignFirstResponder()
        spinner.startAnimating()
        
        if Authorization.shared.hasToken() { fetchTweets() }
        else {
            Client.fetchAuthorizationToken(success: { () -> Void in
                self.fetchTweets()
                }, failure: { (message) -> Void in
                    self.showAlertViewWithMessage("Something went wrong getting token. \(message)")
                    self.spinner.stopAnimating()
            })
        }
    }

    func fetchTweets() {
        Client.fetchTweetsForUser(textField.text.stringByRemovingWhitespace(), success: { (tweets) -> Void in
            self.tweetsTableViewDelegate.tweets = tweets
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableView.scrollToTop(animated: true)
            self.spinner.stopAnimating()
            }, failure: { (message) -> Void in
                self.showAlertViewWithMessage("Something went wrong getting tweets. \(message)")
                self.spinner.stopAnimating()
        })
    }

}

