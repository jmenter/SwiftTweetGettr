
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let greenHue:CGFloat = 123.0/360.0
        self.window?.tintColor = UIColor(hue: greenHue, saturation: 0.5, brightness: 0.5, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(hue: greenHue, saturation: 0.05, brightness: 0.95, alpha: 1.0)
        return true
    }
}
