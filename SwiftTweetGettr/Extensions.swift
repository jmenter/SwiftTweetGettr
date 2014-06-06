
import UIKit

extension NSURLResponse {
    
    func isHTTPResponseValid() -> Bool {
        let httpResponse = self as? NSHTTPURLResponse
        return (httpResponse?.statusCode >= 200 && httpResponse?.statusCode <= 299)
    }
}

extension NSData {
    
    func json() -> AnyObject {
        return NSJSONSerialization.JSONObjectWithData(self, options: nil, error: nil)
    }
}

extension UITableView {
    
    func scrollToTop(#animated: Bool) {
        self.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: animated)
    }
}

extension UIViewController {
    
    func showAlertView(#message : String) {
        var alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension String {
    
    func data() -> NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }
    
    func base64Encoded() -> String {
        return self.data().base64Encoding()
    }
}

