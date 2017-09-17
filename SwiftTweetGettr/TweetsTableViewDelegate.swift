
import UIKit

class TweetsTableViewDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {
 
    var tweets = Array<Tweet>()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        cell.applyTweet(tweet)
        
        return cell
    }
        
}
