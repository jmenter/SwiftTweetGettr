
import UIKit

private let kAuthorizationTokenStorageKey = "authorizationToken"

class TwitterAuthorization {
    
    class func token() -> String?
    {
        return NSUserDefaults.standardUserDefaults().stringForKey(kAuthorizationTokenStorageKey)
    }
    
    class func setToken(token:String?) -> Void
    {
        if let actuallyToken = token {
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: kAuthorizationTokenStorageKey)
        } else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(kAuthorizationTokenStorageKey)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func hasToken() -> Bool
    {
        if let actuallyToken = token() { return true }
        return false
    }
}
