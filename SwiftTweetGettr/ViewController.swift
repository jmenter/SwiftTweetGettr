
import UIKit

class ViewController : UIViewController, UITextFieldDelegate {
    
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var tweetsTableViewDelegate = TweetsTableViewDelegate()
    
    @IBOutlet var textField : UITextField!
    @IBOutlet var button : UIButton!
    @IBOutlet var tableView : UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        textField.rightView = spinner
        textField.rightViewMode = .always
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = button.titleLabel?.textColor.cgColor
        
        tableView.dataSource = tweetsTableViewDelegate
        tableView.delegate = tweetsTableViewDelegate
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if tableView.indexPathForSelectedRow != nil {
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: animated)
        }
        if (textField.text?.isEmpty)! {
            textField.becomeFirstResponder()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let index = tableView.indexPathForSelectedRow?.row
        let tweet = tweetsTableViewDelegate.tweets[index!]
        (segue.destination.view as! UITextView).text = tweet.description
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if !(textField.text?.isEmpty)! {
            buttonWasTapped(nil)
        }
        return textField.resignFirstResponder()
    }

    @IBAction func textFieldDidChange(_ sender : AnyObject)
    {
        button.isEnabled = !(textField.text?.isEmpty)!
        button.layer.borderColor = button.titleLabel?.textColor.cgColor
    }

    @IBAction func buttonWasTapped(_ sender : AnyObject?)
    {
        textField.resignFirstResponder()
        spinner.startAnimating()
        
        if TwitterAuthorization.hasToken() {
            fetchTweets()
        } else {
            TwitterClient.fetchAuthorizationToken(success: { () -> Void in
                self.fetchTweets()
                }, { (message) -> Void in
                    self.showAlertViewWithMessage("Something went wrong getting token. \(message)")
                    self.spinner.stopAnimating()
            })
        }
    }

    func fetchTweets() {
        guard let userFieldText = textField.text else { return }
        TwitterClient.fetchTweetsForUser(userFieldText.stringByRemovingWhitespace(), success: { (tweets) -> Void in
            self.tweetsTableViewDelegate.tweets = tweets
            self.tableView.reloadSections(IndexSet([0]), with: UITableViewRowAnimation.fade)
            self.tableView.scrollToTop(animated: true)
            self.spinner.stopAnimating()
            }, failure: { (message) -> Void in
                self.showAlertViewWithMessage("Something went wrong getting tweets. \(message)")
                self.spinner.stopAnimating()
        })
    }

}

