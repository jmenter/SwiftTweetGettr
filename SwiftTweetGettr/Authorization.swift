
import UIKit

private let _SharedInstance = Authorization()
private let kAuthorizationTokenStorageKey = "authorizationToken"
private let defaults = NSUserDefaults.standardUserDefaults()

class Authorization {
    
    class var shared: Authorization { return _SharedInstance }
    
    func token()->String? { return defaults.stringForKey(kAuthorizationTokenStorageKey) }
    
    func setToken(token:String) {
        defaults.setObject(token, forKey: kAuthorizationTokenStorageKey)
        defaults.synchronize()
    }
    
    func expireToken() -> Void {
        defaults.removeObjectForKey(kAuthorizationTokenStorageKey)
        defaults.synchronize()
    }
    
    func hasToken()->Bool {
        if let value = token() { return true }
        return false
    }
}
