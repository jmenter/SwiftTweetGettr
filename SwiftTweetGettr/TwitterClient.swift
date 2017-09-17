
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

class TwitterClient {
    
    class func fetchAuthorizationToken(success:@escaping () -> Void, _ failure:@escaping (String) -> Void)
    {
        if headerForAuthorization().isEmpty
        {
            failure("API Key & Secret not configured!")
            return
        }
        var tokenRequest = URLRequest(url: kOAuthRootURL.createURL())
        tokenRequest.httpBody = kAuthorizationBody.data()
        tokenRequest.addValue(kAuthorizationContentType, forHTTPHeaderField: kContentTypeHeader)
        tokenRequest.addValue(headerForAuthorization(), forHTTPHeaderField: kAuthorizationHeaderKey)
        tokenRequest.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: tokenRequest) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let validResponse = response?.isHTTPResponseValid() ?? false
            if validResponse {
                TwitterAuthorization.setToken(data?.json()["access_token"] as? String)
                if TwitterAuthorization.hasToken() {
                    success()
                } else {
                    failure("response has no access_token")
                }
            } else {
                self.handleFailure(failure, error: error, response: response)
            }
        }
        task.resume()
    }
    
    class func fetchTweetsForUser(_ userName:String, success:@escaping (Array<Tweet>) -> Void, failure:@escaping (String) -> Void)
    {
        let userURL = kTimelineRootURL + userName.stringByRemovingWhitespace()
        var tweetRequest = URLRequest(url: userURL.createURL())
        tweetRequest.httpMethod = "GET"
        tweetRequest.addValue(headerWithAuthorization(), forHTTPHeaderField: kAuthorizationHeaderKey)

        let task = URLSession.shared.dataTask(with: tweetRequest) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            let validResponse = response?.isHTTPResponseValid() ?? false
            if validResponse {
                if let results:Array<Dictionary<String, AnyObject>> = data?.json() as? Array {
                    success(Tweet.tweetsFromArray(results))
                }
            } else {
                self.handleFailure(failure, error: error, response: response)
            }
        }
        task.resume()
    }
    
    class func fetchImageAtURL(_ url:String, success:@escaping (UIImage?) -> Void) -> Void
    {
        let imageURLRequest = URLRequest(url: url.createURL())
        let task = URLSession.shared.dataTask(with: imageURLRequest) { (data, response, error) -> Void in
            let validResponse = response?.isHTTPResponseValid() ?? false
            if validResponse {
                success(UIImage(data: data!))
            }
        }
        task.resume()
    }

    fileprivate class func handleFailure(_ failure:(String) -> Void, error:Error!, response: URLResponse!) -> Void
    {
        if let actuallyError = error {
            failure(actuallyError.localizedDescription)
        } else if let actuallyResponse = response {
            failure(actuallyResponse.description)
        } else {
            failure("no response or error")
        }
    }
    
    fileprivate class func headerForAuthorization() -> String
    {
        let credentialsPath = Bundle.main.path(forResource: "TwitterCredentials", ofType: "plist")
        let twitterCredentials = NSDictionary(contentsOfFile: credentialsPath!)
        let apiKey = twitterCredentials?["APIKey"] as? String ?? kAPIKey
        let apiSecret = twitterCredentials?["APISecret"] as? String ?? kAPISecret
        if apiKey.isEmpty || apiSecret.isEmpty { return "" }
        return "Basic " + (apiKey + ":" + apiSecret).base64Encoded()
    }
    
    fileprivate class func headerWithAuthorization() -> String
    {
        return "Bearer " + TwitterAuthorization.token()!
    }
    
}
