
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        let greenHue:CGFloat = 123.0/360.0
        self.window?.tintColor = UIColor(hue: greenHue, saturation: 0.5, brightness: 0.5, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(hue: greenHue, saturation: 0.05, brightness: 0.95, alpha: 1.0)
        return true
    }
}