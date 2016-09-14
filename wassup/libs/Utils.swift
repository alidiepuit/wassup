//
//  Utils.swift
//  wassup
//
//  Created by MAC on 8/17/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit
import CoreLocation

class Location {
    var lat:CLLocationDegrees = 0
    var long:CLLocationDegrees = 0
    
    init(lat: CLLocationDegrees, long: CLLocationDegrees) {
        self.lat = lat
        self.long = long
    }
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

var BASE_URL:String {
    return "http://dev.wassup.com.vn"
}

func CONVERT_STRING(a:AnyObject?) -> String {
    return Utils.convertToString(a)
}

func CONVERT_INT(a:AnyObject?) -> Int {
    return Utils.convertToNumber(a).integerValue
}

func CONVERT_INT32(a:AnyObject?) -> Int32 {
    return Utils.convertToNumber(a).intValue
}

func CONVERT_FLOAT(a:AnyObject?) -> Float32 {
    return a!.floatValue
}

func CONVERT_DOUBLE(a:AnyObject?) -> Double {
    return Utils.convertToDouble(a)
}

func CONVERT_BOOL(a:AnyObject?) -> Bool {
    return Utils.convertToBool(a)
}

class Utils: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = Utils()
    
    var location = Location(lat: 0, long: 0)
    let locationManager = CLLocationManager()
    var loop = false
    var hasSetup = false
    
    func refreshLocation(observe: AnyObject, action: Selector, loop: Bool) {
        
        self.hasSetup = false
        
        // Ask for Authorisation from the User.
        if #available(iOS 8.0, *) {
            locationManager.requestAlwaysAuthorization()
        } else {
            // Fallback on earlier versions
        }
        
        // For use in foreground
        if #available(iOS 8.0, *) {
            locationManager.requestWhenInUseAuthorization()
        } else {
            // Fallback on earlier versions
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            NSNotificationCenter.defaultCenter().removeObserver(observe)
            if action != nil {
                NSNotificationCenter.defaultCenter().addObserver(observe, selector: action, name: "callback_location", object: nil)
            }
            self.loop = loop
        }
    }
    
    @objc func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.hasSetup {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            location.lat = locValue.latitude
            location.long = locValue.longitude
            NSNotificationCenter.defaultCenter().postNotificationName("callback_location", object: nil, userInfo: nil)
            self.hasSetup = true
        }
        
        if self.loop {
            self.hasSetup = false
        }
    }
    
    class func convertFromStringToNumber(str: String) -> NSNumber {
        let f = NSNumberFormatter()
        f.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let myNumber = f.numberFromString(str)
        return myNumber!
    }

    class func convertToNumber(str: AnyObject?) -> NSNumber {
        if str == nil {
            return 0
        }
        if let id = str as? NSNumber {
            return id
        }
        if let id = str?.doubleValue {
            return id
        }
        return 0
    }
    
    class func convertToDouble(str: AnyObject?) -> Double {
        if str == nil {
            return 0
        }
        if let id = str?.doubleValue {
            return id
        }
        return 0
    }
    
    class func convertToString(str: AnyObject?) -> String {
        if str == nil {
            return ""
        }
        if let id = str as? NSString {
            return String(id)
        }
        if let id = str as? NSNumber {
            return id.stringValue
        }
        return ""
    }
    
    
    class func convertToBool(str: AnyObject?) -> Bool {
        if str == nil {
            return false
        }
        if let id = str as? Bool {
            return id
        }
        return false
    }
    
    class func HTMLImageCorrector(HTMLString: String) -> String {
        var HTMLToBeReturned = HTMLString
        while HTMLToBeReturned.rangeOfString("(?<=width=\")[^\" height]+", options: .RegularExpressionSearch) != nil{
            if let match = HTMLToBeReturned.rangeOfString("(?<=width=\")[^\" height]+", options: .RegularExpressionSearch) {
                HTMLToBeReturned.removeRange(match)
                if let match2 = HTMLToBeReturned.rangeOfString("(?<=height=\")[^\"]+", options: .RegularExpressionSearch) {
                    HTMLToBeReturned.removeRange(match2)
                    let string2del = "width=\"\" height=\"\""
                    HTMLToBeReturned = HTMLToBeReturned.stringByReplacingOccurrencesOfString( string2del, withString: "")
                }
            }
            
        }
        
        return HTMLToBeReturned
    }
    
    class func lock() {
        let dele = UIApplication.sharedApplication().delegate as! AppDelegate
        let vc = dele.window?.rootViewController
        vc?.view.lock()
    }
    
    class func unlock() {
        let dele = UIApplication.sharedApplication().delegate as! AppDelegate
        let vc = dele.window?.rootViewController
        vc?.view.unlock()
    }
}
