
import UIKit

extension NSURLResponse {
    
    func isHTTPResponseValid() -> Bool
    {
        if let response = self as? NSHTTPURLResponse {
            return (response.statusCode >= 200 && response.statusCode <= 299)
        }
        return false
    }
}

extension NSData {
    
    func json() -> AnyObject
    {
        return NSJSONSerialization.JSONObjectWithData(self, options: nil, error: nil)!
    }
}

extension UITableView {
    
    func scrollToTop(#animated: Bool)
    {
        scrollRectToVisible(CGRectMake(0, 0, 1, 0), animated: true)
    }
}

extension UIViewController {
    
    func showAlertViewWithMessage(message : String)
    {
        var alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}

extension String {
    
    func data() -> NSData
    {
        return dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    }
    
    func base64Encoded() -> String
    {
        return data().base64EncodedStringWithOptions(nil)
    }
    
    func createURL() -> NSURL
    {
        return NSURL(string: self)!
    }
    
    func stringByRemovingWhitespace() -> String
    {
        let trimmed = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return trimmed.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
    }
}

extension NSMutableURLRequest {
    
    class func getRequestWithURL(url:NSURL) -> NSMutableURLRequest
    {
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        return request
    }
    
    class func postRequestWithURL(url:NSURL, body:String) -> NSMutableURLRequest
    {
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = body.data()
        return request
    }
}

extension UIImageView {
    
    func loadURL(url:String) {
        NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL:  NSURL(string: url)!), queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if response.isHTTPResponseValid() {
                if let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }
    }
}