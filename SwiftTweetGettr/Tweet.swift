
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
        Client.fetchImageAtURL(profileImageURL(), success: { (image) -> Void in
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
    
    private func profileImageURL() -> String
    {
        return (tweetDictionary["user"] as Dictionary<String, AnyObject>)["profile_image_url"] as String
    }
    
}