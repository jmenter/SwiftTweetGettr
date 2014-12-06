
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
        return NSJSONSerialization.JSONObjectWithData(self, options: nil, error: nil)!
    }
}

extension UITableView {
    
    func scrollToTop(#animated: Bool) {
        scrollRectToVisible(CGRectMake(0, 0, 1, 0), animated: true)
    }
}

extension UIViewController {
    
    func showAlertViewWithMessage(message : String) {
        var alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension String {
    
    func data() -> NSData {
        return dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }
    
    func base64Encoded() -> String {
        return data().base64EncodedStringWithOptions(nil)
    }
    
    func createURL() -> NSURL {
        return NSURL(string: self)!
    }
    
    func stringByRemovingWhitespace() -> String {
        let trimmed = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return trimmed.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
    }
}

extension NSURL {
    
    func createMutableRequest() -> NSMutableURLRequest {
        return NSMutableURLRequest(URL: self)
    }
}
