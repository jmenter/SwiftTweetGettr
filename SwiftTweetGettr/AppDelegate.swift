
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let kAuthorizationTokenStorageKey = "authorizationToken"
    var window: UIWindow?
    var authorizationToken: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(kAuthorizationTokenStorageKey)
        }
        set {
            if newValue {
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: kAuthorizationTokenStorageKey)
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(kAuthorizationTokenStorageKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    class func shared() -> AppDelegate! {
        struct Static {
            static var instance : AppDelegate? = nil
            static var token : dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = AppDelegate()
        }
        
        return Static.instance!
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        return true
    }

}