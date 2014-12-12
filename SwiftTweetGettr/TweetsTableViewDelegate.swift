
import UIKit

class TweetsTableViewDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {
 
    var tweets = Array<Tweet>()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as UITableViewCell
        let tweet = tweets[indexPath.row]
        
        cell.textLabel?.text = tweet.text()
        cell.detailTextLabel?.text = tweet.createdAt()
        cell.imageView?.image = tweet.userImage
        cell.imageView?.loadURL(tweet.biggerProfileImageURL()!)
        
        return cell
    }
        
}