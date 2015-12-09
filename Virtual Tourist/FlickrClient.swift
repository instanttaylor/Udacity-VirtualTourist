//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Taylor Smith on 12/1/15.
//  Copyright © 2015 Taylor Smith. All rights reserved.
//

import Foundation

class Flickr: NSObject {
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func getPhotosFromLocation(lat: Double, long: Double, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let methodArguments = [
            "method": "flickr.photos.search",
            "api_key": "c1149aa1c4532dd7823ecebe416d5331",
            "tags":"tourist, tourism",
            "lat":"\(lat)",
            "long":"\(long)",
            "radius":"1",
            "per_page":"10",
            "page":"1",
            "format": "json",
            "nojsoncallback": "1"
        ]
        
        let session = NSURLSession.sharedSession()
        let urlString = "https://api.flickr.com/services/rest/" + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)

        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(result: nil, error: error)
                return
            }
            
            guard let data = data else {
                print("no data")
                completionHandler(result: nil, error: NSError(domain: "flickr search", code: 2, userInfo: [NSLocalizedDescriptionKey: "something went wrong"]))
                return
            }
         
        self.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)

        }
        
        task.resume()
        return task
    }
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsed: AnyObject!
        
        do {
            parsed = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            print("parsed photos in do block")
        } catch let error as NSError {
            parsed = nil
            print("I'm in parse error")
            return
        }
        
        completionHandler(result: parsed, error: nil)
        
    }
    
}