
import UIKit

class ViewController : UIViewController, UITextFieldDelegate {
    
    let kAPIKey = ""
    let kAPISecret = ""
    let kPostMethod = "POST"
    let kGetMethod = "GET"
    let kContentTypeHeader = "Content-Type"
    let kAuthorizationHeader = "Authorization"
    let kOAuthRootURL = "https://api.twitter.com/oauth2/token"
    let kTimelineRootURL = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=30&screen_name="
    let kAuthorizationBody = "grant_type=client_credentials"
    let kAuthorizationContentType = "application/x-www-form-urlencoded;charset=UTF-8"

    var spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var tweetsTableViewDelegate = TweetsTableViewDelegate()
    
    @IBOutlet var textField : UITextField
    @IBOutlet var button : UIButton
    @IBOutlet var tableView : UITableView

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.rightView = spinner
        textField.rightViewMode = UITextFieldViewMode.Always
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = button.titleLabel.textColor.CGColor
        tableView.dataSource = tweetsTableViewDelegate
        tableView.delegate = tweetsTableViewDelegate
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow(), animated: animated)
        if textField.text.isEmpty {
            textField.becomeFirstResponder()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tweet = tweetsTableViewDelegate.tweets[tableView.indexPathForSelectedRow().row] as NSDictionary
        (segue.destinationViewController.view as UITextView).text = tweet.description
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if !textField.text.isEmpty {
            buttonWasTapped(nil)
        }
        return textField.resignFirstResponder()
    }

    @IBAction func textFieldDidChange(sender : AnyObject) {
        button.enabled = !textField.text.isEmpty
        button.layer.borderColor = button.titleLabel.textColor.CGColor
    }

    @IBAction func buttonWasTapped(sender : AnyObject?) {
        textField.resignFirstResponder()
        spinner.startAnimating()
        if AppDelegate.shared().authorizationToken? {
            fetchTweets()
        } else {
            fetchAuthorizationToken()
        }
    }

    func fetchAuthorizationToken() {
        var tokenRequest = NSMutableURLRequest(URL: NSURL(string: kOAuthRootURL))
        tokenRequest.HTTPMethod = kPostMethod
        tokenRequest.HTTPBody = kAuthorizationBody.data()
        tokenRequest.addValue(kAuthorizationContentType, forHTTPHeaderField: kContentTypeHeader)
        tokenRequest.addValue("Basic " + (kAPIKey + ":" + kAPISecret).base64Encoded(), forHTTPHeaderField: kAuthorizationHeader)
        
        NSURLConnection.sendAsynchronousRequest(tokenRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response.isHTTPResponseValid() {
                if let token = data.json()["access_token"] as? String {
                    AppDelegate.shared().authorizationToken = token
                    self.fetchTweets()
                }
            } else {
                self.showAlertViewWithMessage("Something went wrong getting access token.")
            }

        })
        spinner.stopAnimating()
    }

    func fetchTweets() {
        var tweetRequest = NSMutableURLRequest(URL: NSURL(string: kTimelineRootURL + textField.text))
        tweetRequest.HTTPMethod = kGetMethod
        tweetRequest.addValue("Bearer " + AppDelegate.shared().authorizationToken!, forHTTPHeaderField: kAuthorizationHeader)
        
        NSURLConnection.sendAsynchronousRequest(tweetRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response.isHTTPResponseValid() {
                self.tweetsTableViewDelegate.tweets = data.json() as NSArray
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.scrollToTop(animated: true)
            } else {
                self.showAlertViewWithMessage("Something went wrong getting tweets.")
            }
        })
        spinner.stopAnimating()
    }

}

