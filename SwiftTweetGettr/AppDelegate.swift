
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let kAuthorizationTokenStorageKey = "authorizationToken"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var window: UIWindow?
    var authorizationToken: String? {
        get {
            return defaults.stringForKey(kAuthorizationTokenStorageKey)
        }
        set {
            if newValue {
                defaults.setObject(newValue, forKey: kAuthorizationTokenStorageKey)
            } else {
                defaults.removeObjectForKey(kAuthorizationTokenStorageKey)
            }
            defaults.synchronize()
        }
    }
    
    class func shared() -> AppDelegate! {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        return true
    }

}