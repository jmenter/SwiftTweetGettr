
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
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        return true
    }

}