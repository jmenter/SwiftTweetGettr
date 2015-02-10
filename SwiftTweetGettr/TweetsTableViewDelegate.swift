
import UIKit

class TweetsTableViewDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {
 
    var tweets = Array<Tweet>()
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        cell.applyTweet(tweet)
        
        return cell
    }
        
}