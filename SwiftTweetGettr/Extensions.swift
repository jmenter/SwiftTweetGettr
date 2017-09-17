
import UIKit

extension URLResponse {
    
    func isHTTPResponseValid() -> Bool
    {
        if let response = self as? HTTPURLResponse {
            return (response.statusCode >= 200 && response.statusCode <= 299)
        }
        return false
    }
}

extension Data {
    
    func json() -> AnyObject
    {
        let result = try? JSONSerialization.jsonObject(with: self, options: [])
        return result! as AnyObject
    }
}

extension UITableView {
    
    func scrollToTop(animated: Bool)
    {
        scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 0), animated: true)
    }
}

extension UIViewController {
    
    func showAlertViewWithMessage(_ message : String)
    {
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

extension String {
    
    func data() -> Data
    {
        return self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    func base64Encoded() -> String
    {
        let dataFromString = self.data()
        return dataFromString.base64EncodedString(options: [])
    }
    
    func createURL() -> URL
    {
        let secureURL = self.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: secureURL)!
    }
    
    func stringByRemovingWhitespace() -> String
    {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.replacingOccurrences(of: " ", with:"", options: [], range: nil)
    }
}

extension UIImageView {
    
    func loadURL(_ url:String) {
        
        let request = URLRequest(url: url.createURL())
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            let validResponse = response?.isHTTPResponseValid() ?? false
            if validResponse {
                DispatchQueue.main.async { [unowned self] in
                    if let image = UIImage(data: data!) {
                        self.image = image
                    }
                }
            }
        }
        task.resume()
    }
}
