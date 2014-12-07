
import UIKit

private let kAPIKey = ""
private let kAPISecret = ""
private let kPostMethod = "POST"
private let kGetMethod = "GET"
private let kContentTypeHeader = "Content-Type"
private let kAuthorizationHeaderKey = "Authorization"
private let kOAuthRootURL = "https://api.twitter.com/oauth2/token"
private let kTimelineRootURL = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=30&screen_name="
private let kAuthorizationBody = "grant_type=client_credentials"
private let kAuthorizationContentType = "application/x-www-form-urlencoded;charset=UTF-8"

class Client {
    
    class func fetchAuthorizationToken(#success:() -> Void, failure:(String) -> Void)
    {
        var tokenRequest = NSMutableURLRequest.postRequestWithURL(kOAuthRootURL.createURL(), body: kAuthorizationBody)
        tokenRequest.addValue(kAuthorizationContentType, forHTTPHeaderField: kContentTypeHeader)
        tokenRequest.addValue(headerForAuthorization(), forHTTPHeaderField: kAuthorizationHeaderKey)
        
        NSURLConnection.sendAsynchronousRequest(tokenRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response.isHTTPResponseValid() {
                Authorization.shared.setToken(data.json()["access_token"] as? String)
                if Authorization.shared.hasToken() {
                    success()
                } else { failure("response has no access_token") }
            } else { self.handleFailure(failure, error: error, response: response) }
        })
    }
    
    class func fetchTweetsForUser(userName:String, success:(Array<Tweet>) -> Void, failure:(String) -> Void)
    {
        var tweetRequest = NSMutableURLRequest.getRequestWithURL((kTimelineRootURL + userName.stringByRemovingWhitespace()).createURL())
        tweetRequest.addValue(headerWithAuthorization(), forHTTPHeaderField: kAuthorizationHeaderKey)
        
        NSURLConnection.sendAsynchronousRequest(tweetRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if response.isHTTPResponseValid() {
                if let results:Array<NSDictionary> = data.json() as? Array {
                    success(Tweet.tweetsFromArray(results))
                }
            } else { self.handleFailure(failure, error: error, response: response) }
        })
    }
    
    class func fetchImageAtURL(url:String, success:(UIImage?) -> Void) -> Void
    {
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL:  NSURL(string: url)!), queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if (response.isHTTPResponseValid()) { success(UIImage(data: data)) }
        }
    }

    private class func handleFailure(failure:(String) -> Void, error:NSError!, response: NSURLResponse!) -> Void
    {
        if let actuallyError = error { failure(actuallyError.description) }
        else if let actuallyResponse = response { failure(actuallyResponse.description) }
        else { failure("no response or error") }
    }
    
    private class func headerForAuthorization() -> String
    {
        return "Basic " + (kAPIKey + ":" + kAPISecret).base64Encoded()
    }
    
    private class func headerWithAuthorization() -> String
    {
        return "Bearer " + Authorization.shared.token()!
    }
    
}
