
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let kAuthorizationTokenStorageKey = "authorizationToken"
    var window: UIWindow?
    var authorizationToken: String?
    
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