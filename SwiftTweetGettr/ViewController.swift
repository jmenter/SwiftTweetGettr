
import UIKit

extension NSURLResponse {
    
    func httpResponseIsValid() -> Bool {
        let httpResponse = self as? NSHTTPURLResponse
        return (httpResponse?.statusCode >= 200 && httpResponse?.statusCode <= 299)
    }
}

extension NSData {
    
    func json() -> AnyObject {
        return NSJSONSerialization.JSONObjectWithData(self, options: nil, error: nil)
    }
}

extension UITableView {
    
    func scrollToTop(animated: Bool) {
        self.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0),
            atScrollPosition: UITableViewScrollPosition.Top, animated: animated)
    }
}

extension UIViewController {
    
    func showAlertViewWithMessage(message : String) {
        var alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension String {
    
    func base64Encoded() -> String {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false).base64Encoding()
    }
}

class ViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let kAPIKey = "";
    let kAPISecret = "";
    let kPostMethod = "POST"
    let kGetMethod = "GET"
    let kContentTypeHeader = "Content-Type"
    let kAuthorizationHeader = "Authorization"
    let kOAuthRootURL = "https://api.twitter.com/oauth2/token"
    let kTimelineRootURL = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=30&screen_name="
    let kAuthorizationBody = "grant_type=client_credentials"
    let kAuthorizationContentType = "application/x-www-form-urlencoded;charset=UTF-8"

    var spinner : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var tweets = NSArray()

    @IBOutlet var textField : UITextField
    @IBOutlet var button : UIButton
    @IBOutlet var tableView : UITableView

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.rightView = spinner
        textField.rightViewMode = UITextFieldViewMode.Always
    }

    override func viewDidAppear(animated: Bool) {
        tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow(), animated: animated)
        if textField.text.isEmpty {
            textField.becomeFirstResponder()
        }
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if !textField.text.isEmpty {
            buttonWasTapped(button)
        }
        return textField.resignFirstResponder()
    }

    @IBAction func textFieldDidChange(sender : AnyObject) {
        button.enabled = !textField.text.isEmpty
    }

    @IBAction func buttonWasTapped(sender : AnyObject) {
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
        tokenRequest.HTTPBody = kAuthorizationBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        tokenRequest.addValue(kAuthorizationContentType, forHTTPHeaderField: kContentTypeHeader)
        tokenRequest.addValue("Basic " + (kAPIKey + ":" + kAPISecret).base64Encoded(), forHTTPHeaderField: kAuthorizationHeader)
        
        NSURLConnection.sendAsynchronousRequest(tokenRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response.httpResponseIsValid() {
                var json = data.json() as NSDictionary
                AppDelegate.shared().authorizationToken = json["access_token"] as? String
                self.fetchTweets()
            } else {
                self.showAlertViewWithMessage("Something went wrong getting access token.")
            }

        })
        spinner.stopAnimating()
    }

    func fetchTweets() {
        var tweetRequest = NSMutableURLRequest(URL: NSURL(string: kTimelineRootURL + textField.text))
        tweetRequest.HTTPMethod = kGetMethod;
        tweetRequest.addValue("Bearer " + AppDelegate.shared().authorizationToken!, forHTTPHeaderField: kAuthorizationHeader)
        
        NSURLConnection.sendAsynchronousRequest(tweetRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response.httpResponseIsValid() {
                self.tweets = data.json() as NSArray
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.scrollToTop(true)
            } else {
                self.showAlertViewWithMessage("Something went wrong getting tweets.")
            }
        })
        spinner.stopAnimating()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as UITableViewCell
        let tweet = tweets[indexPath.row] as NSDictionary

        cell.textLabel.text = tweet["text"] as String
        cell.detailTextLabel.text = tweet["created_at"] as String
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            let tweet = tweets[tableView.indexPathForSelectedRow().row] as NSDictionary
            (segue.destinationViewController.view as UITextView).text = tweet.description
    }
    
}

