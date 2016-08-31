//
//  Connector.swift
//  App568Play
//
//  Created by SSG on 4/26/16.
//  Copyright © 2016 Ramotion. All rights reserved.
//
import Foundation
public typealias ServiceResponse = (AnyObject?) -> Void

public class Connector: NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    var _call:ServiceResponse?
    
    public func callService(method: String, serviceURL: String, params: Dictionary<String, String>?, callback: ServiceResponse?) {
        var urlString: String = serviceURL
        var paramString: String = ""
        var paramInfo: String = ""
        if params != nil {
            for (key,value) in params! {
                // do stuff
                let v = value.stringByReplacingOccurrencesOfString(" ", withString: "+")
                paramInfo = "\(key)=\(v)&"
                paramString = paramString.stringByAppendingString(paramInfo)
            }
        }
        urlString = urlString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let myURL: NSURL = NSURL(string: urlString)!
        
        print("\(myURL)?\(paramString)")
        let myRequest: NSMutableURLRequest = NSMutableURLRequest(URL: myURL, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 5.0)
        myRequest.HTTPMethod = method
        myRequest.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        myRequest.setValue("76524a53ee60602ac3528f38", forHTTPHeaderField: "X-App-Token")
        NSURLConnection(request: myRequest, delegate: self)!
        _call = callback
    }
    
    public func connection(connection: NSURLConnection, didReceiveData data: NSData) {

//        let str = NSString(data: data, encoding: NSUTF8StringEncoding)
//        print(str)
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if (_call != nil) {
                _call!(jsonObject)
            }
        } catch _ as NSError {
            
        }
        
    }
    
    public func connection(connection: NSURLConnection, didFailWithError error: NSError) {
//        print(error)
        if (_call != nil) {
            _call!(nil)
        }
    }
}