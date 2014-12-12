
import UIKit

class Tweet {
    
    class func tweetsFromArray(from: Array<Dictionary<String, AnyObject>>) -> Array<Tweet>
    {
        return from.map( { Tweet(tweetDictionary: $0) } )
    }
    
    private let tweetDictionary:Dictionary<String, AnyObject>
    var userImage = UIImage(named: "default")
    
    init(tweetDictionary:Dictionary<String, AnyObject>)
    {
        self.tweetDictionary = tweetDictionary
        TwitterClient.fetchImageAtURL(biggerProfileImageURL()!, success: { (image) -> Void in
            self.userImage = image
        })
    }
    
    func text() -> String
    {
        return tweetDictionary["text"] as String
    }
    
    func createdAt() -> String
    {
        return tweetDictionary["created_at"] as String
    }
    
    func description() -> String
    {
        return tweetDictionary.description
    }
    
    func profileImageURL() -> String?
    {
        return user()["profile_image_url"] as? String
    }
    
    func biggerProfileImageURL() -> String?
    {
        if let url = user()["profile_image_url"] as? String {
            return url.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
        }
        return nil
    }
    
    func originalProfileImageURL() -> String?
    {
        if let url = user()["profile_image_url"] as? String {
            return url.stringByReplacingOccurrencesOfString("_normal", withString: "")
        }
        return nil
    }
    
    private func user() -> Dictionary<String, AnyObject>
    {
        return tweetDictionary["user"] as Dictionary<String, AnyObject>
    }
    
}