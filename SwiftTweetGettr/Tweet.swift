
import UIKit

class Tweet {
    
    class func tweetsFromArray(from: Array<NSDictionary>) -> Array<Tweet>
    {
        return from.map( { Tweet(tweetDictionary: $0) } )
    }
    
    private let tweetDictionary:NSDictionary
    var userImage = UIImage(named: "default")
    
    init(tweetDictionary:NSDictionary)
    {
        self.tweetDictionary = tweetDictionary
        Client.fetchImageAtURL(profileImageURL(), success: { (image) -> Void in
            self.userImage = image
        })
    }
    
    func text() -> String
    {
        return tweetDictionary.valueForKeyPath("text") as String
    }
    
    func createdAt() -> String
    {
        return tweetDictionary.valueForKeyPath("created_at") as String
    }
    
    func description() -> String
    {
        return tweetDictionary.description
    }
    
    private func profileImageURL() -> String
    {
        return tweetDictionary.valueForKeyPath("user.profile_image_url") as String
    }
    
}