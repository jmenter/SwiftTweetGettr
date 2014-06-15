
import UIKit

extension NSURLResponse {
    
    func isHTTPResponseValid() -> Bool {
        if let httpResponse = self as? NSHTTPURLResponse {
            return (httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299)
        }
        return false
    }
}

extension NSData {
    
    func json() -> AnyObject {
        return NSJSONSerialization.JSONObjectWithData(self, options: nil, error: nil)
    }
}

extension UITableView {
    
    func scrollToTop(#animated: Bool) {
        scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: animated)
    }
}

extension UIViewController {
    
    func showAlertViewWithMessage(message : String) {
        var alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension String {
    
    func data() -> NSData {
        return dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }
    
    func base64Encoded() -> String {
        return data().base64Encoding()
    }
    
    func createURL() -> NSURL {
        return NSURL.URLWithString(self)
    }
}

extension NSURL {
    
    func createMutableRequest() -> NSMutableURLRequest {
        return NSMutableURLRequest(URL: self)
    }
}
