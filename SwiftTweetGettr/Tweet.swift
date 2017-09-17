
import UIKit

class Tweet {
    
    class func tweetsFromArray(_ from: Array<Dictionary<String, AnyObject>>) -> Array<Tweet>
    {
        return from.map( { Tweet(tweetDictionary: $0) } )
    }
    
    fileprivate let tweetDictionary:Dictionary<String, AnyObject>
    
    var text:String { return tweetDictionary["text"] as! String }
    var createdAt:String { return tweetDictionary["created_at"] as! String }
    var name:String { return user()["name"] as! String }
    var screenName:String { return user()["screen_name"] as! String }
    var description:String { return tweetDictionary.description }
    var userImage = UIImage(named: "default")
    var profileImageURL:String? { return user()["profile_image_url"] as? String }
    var biggerProfileImageURL:String? {
        if let url = user()["profile_image_url"] as? String {
            return url.replacingOccurrences(of: "_normal", with: "_bigger")
        }
        return nil
    }
    var originalProfileImageURL:String? {
        if let url = user()["profile_image_url"] as? String {
            return url.replacingOccurrences(of: "_normal", with: "")
        }
        return nil
    }
    
    init(tweetDictionary:Dictionary<String, AnyObject>)
    {
        self.tweetDictionary = tweetDictionary
        TwitterClient.fetchImageAtURL(biggerProfileImageURL!, success: { (image) -> Void in
            self.userImage = image
        })
    }

    fileprivate func user() -> Dictionary<String, AnyObject>
    {
        return tweetDictionary["user"] as! Dictionary<String, AnyObject>
    }
    
}
