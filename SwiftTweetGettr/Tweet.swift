
import UIKit

class Tweet {
    
    class func tweetsFromArray(from: Array<Dictionary<String, AnyObject>>) -> Array<Tweet>
    {
        return from.map( { Tweet(tweetDictionary: $0) } )
    }
    
    private let tweetDictionary:Dictionary<String, AnyObject>
    
    var text:String { return tweetDictionary["text"] as String }
    var createdAt:String { return tweetDictionary["created_at"] as String }
    var name:String { return user()["name"] as String }
    var screenName:String { return user()["screen_name"] as String }
    var description:String { return tweetDictionary.description }
    var userImage = UIImage(named: "default")
    var profileImageURL:String? { return user()["profile_image_url"] as? String }
    var biggerProfileImageURL:String? {
        if let url = user()["profile_image_url"] as? String {
            return url.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
        }
        return nil
    }
    var originalProfileImageURL:String? {
        if let url = user()["profile_image_url"] as? String {
            return url.stringByReplacingOccurrencesOfString("_normal", withString: "")
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

    private func user() -> Dictionary<String, AnyObject>
    {
        return tweetDictionary["user"] as Dictionary<String, AnyObject>
    }
    
}