
import UIKit

private let kAuthorizationTokenStorageKey = "authorizationToken"

class TwitterAuthorization {
    
    class func token() -> String?
    {
        return UserDefaults.standard.string(forKey: kAuthorizationTokenStorageKey)
    }
    
    class func setToken(_ token:String?) -> Void
    {
        if token != nil {
            UserDefaults.standard.set(token, forKey: kAuthorizationTokenStorageKey)
        } else {
            UserDefaults.standard.removeObject(forKey: kAuthorizationTokenStorageKey)
        }
        UserDefaults.standard.synchronize()
    }
    
    class func hasToken() -> Bool
    {
        if token() != nil {
            return true
        }
        return false
    }
}
